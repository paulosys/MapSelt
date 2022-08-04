import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locationgps;
import 'package:mapselt/components/location_info.dart';
import 'package:mapselt/components/marker_info.dart';
import 'package:mapselt/helpers/database_helper.dart';
import 'package:mapselt/model/user_marker_model.dart';

class GoogleMapsController extends ChangeNotifier {
  // Set para armazenar os Markers e que o Widget utiliza para criar os Markers
  Set<Marker> markers = <Marker>{};

  late GoogleMapController _mapsController;
  late GlobalKey key; // Usada para obter o context e abrir os Modal de info;

  TextEditingController pesquisarController = TextEditingController();

  get mapsController => _mapsController;

  onMapCreated(GoogleMapController gmc, GlobalKey scaffoldKey) async {
    key = scaffoldKey;
    _mapsController = gmc;
    localizacaoAtual();
    loadMarkers();
  }

  void criarMarkerGPS() async {
    List dados = await localizacaoAtual();

    if (dados.isNotEmpty) {
      LatLng coords = LatLng(dados[0], dados[1]);
      showMarkerInfo(coords);
    }
  }

  // Método chamado no OnLongPress do Widget do GoogleMaps
  // para mostrar as informações do lugar onde o usuário pressionou.
  void showMarkerInfo(LatLng coords) async {
    List<geocoding.Placemark> dados = await geocoding.placemarkFromCoordinates(
        coords.latitude, coords.longitude);

    if (dados.isEmpty) return;

    geocoding.Placemark marker = dados.first;

    String endereco =
        "${marker.street}, ${marker.name} - ${marker.subLocality}, ${marker.subAdministrativeArea} - ${marker.administrativeArea}, ${marker.postalCode}, ${marker.country}";

    showModalBottomSheet(
        // Cria um Modal e mostra as informações
        context: key.currentState!.context,
        builder: (context) => LocationInfo(
              endereco: endereco,
              latitude: coords.latitude,
              longitude: coords.longitude,
            ));
  }

  void pesquisarMapa(String endereco) async {
    try {
      List<geocoding.Location> dados =
          await geocoding.locationFromAddress(endereco);

      geocoding.Location coords = dados.first;
      _mapsController.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(coords.latitude, coords.longitude), 15));

      showMarkerInfo(LatLng(coords.latitude, coords.longitude));
    } on Exception catch (e) {
      return;
    }
  }

  void loadMarkers() async {
    DatabaseHelper dbHelper = DatabaseHelper.instancia;
    List<UserMarker> dados = await dbHelper.consultarTodasMarcacoes();
    markers.clear();

    if (dados.isNotEmpty) {
      for (UserMarker marker in dados) {
        markers.add(Marker(
            markerId: MarkerId(marker.id),
            position: LatLng(marker.latitude, marker.longitude),
            onTap: () {
              showModalBottomSheet(
                  context: key.currentState!.context,
                  builder: (context) => MarkerInfo(
                        marker: marker,
                      ));
            }));
      }
    }
    notifyListeners();
  }

  // Obtem a localização do usuário e move o mapa para ela.
  Future<List> localizacaoAtual() async {
    List coords = [];
    String erro = "";
    try {
      locationgps.LocationData dados = await _localizacaoPermissoes();
      coords.addAll([dados.latitude, dados.longitude]);
      erro = "";
      _mapsController.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(dados.latitude!, dados.longitude!), 15));
    } on Exception catch (e) {
      erro = e.toString();
    }
    notifyListeners();
    return coords;
  }

  // Para obter a localização é necessario verificar se o usuário
  // liberou o acesso, se sim chama o método para obter a localização.
  Future<locationgps.LocationData> _localizacaoPermissoes() async {
    locationgps.Location location = locationgps.Location();
    locationgps.PermissionStatus permissao;

    bool servicoAtivado = await location.serviceEnabled();
    if (!servicoAtivado) {
      servicoAtivado = await location.requestService();
      if (!servicoAtivado) {
        return Future.error(
            'Por favor, habilite a localização do seu dispositivo');
      }
    }

    permissao = await location.hasPermission();
    if (permissao == locationgps.PermissionStatus.denied) {
      permissao = await location.requestPermission();
      if (permissao == locationgps.PermissionStatus.denied) {
        return Future.error(
            'Por favor, habilite a permissão para acessar a localização do seu dispositivo');
      }
    }

    if (permissao == locationgps.PermissionStatus.deniedForever) {
      return Future.error(
          'Você precisa autorizar a permissão para acessar a localização do seu dispositivo');
    }

    return await location.getLocation();
  }
}

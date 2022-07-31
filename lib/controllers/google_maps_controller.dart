import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as locationgps;
import 'package:mapselt/components/location_info.dart';
import 'package:mapselt/components/marker_info.dart';
import 'package:mapselt/helpers/database_helper.dart';
import 'package:mapselt/model/user_marker_model.dart';

class GoogleMapsController extends ChangeNotifier {
  double latitude = 0.0;
  double longitude = 0.0;
  String erro = "";

  Set<Marker> markers = <Marker>{};

  late GoogleMapController _mapsController;
  late GlobalKey key; // Usada para obter o context;

  get mapsController => _mapsController;

  onMapCreated(GoogleMapController gmc, GlobalKey scaffoldKey) async {
    key = scaffoldKey;
    _mapsController = gmc;
    getLocalizacao();
    loadMarkers();
  }

  void showMarkerInfo(LatLng coords) async {
    List<geocoding.Placemark> dados = await geocoding.placemarkFromCoordinates(
        coords.latitude, coords.longitude);

    if (dados.isEmpty) return;

    geocoding.Placemark marker = dados.first;

    String endereco =
        "${marker.street}, ${marker.name} - ${marker.subLocality}, ${marker.subAdministrativeArea} - ${marker.administrativeArea}, ${marker.postalCode}, ${marker.country}";

    showModalBottomSheet(
        context: key.currentState!.context,
        builder: (context) => LocationInfo(
              endereco: endereco,
              latitude: coords.latitude,
              longitude: coords.longitude,
            ));

    loadMarkers();
  }

  void loadMarkers() async {
    DatabaseHelper dbHelper = DatabaseHelper.instancia;
    var dados = await dbHelper.consultarTodasMarcacoes();

    if (dados.isEmpty) return;

    for (UserMarker marker in dados) {
      markers.add(Marker(
          markerId: MarkerId(marker.id.toString()),
          position: LatLng(marker.latitude, marker.longitude),
          onTap: () {
            showModalBottomSheet(
                context: key.currentState!.context,
                builder: (context) => MarkerInfo(
                      marker: marker,
                    ));
          }));
    }
    notifyListeners();
  }

  getLocalizacao() async {
    try {
      locationgps.LocationData dados = await _localizacaoAtual();
      latitude = dados.latitude!;
      longitude = dados.longitude!;
      erro = "";
      _mapsController.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 15));
    } on Exception catch (e) {
      erro = e.toString();
    }
    notifyListeners();
  }

  Future<locationgps.LocationData> _localizacaoAtual() async {
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

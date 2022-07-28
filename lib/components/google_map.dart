import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapselt/localizacao_gps.dart';

import '../pages/register_page.dart';

class MapaGoogle extends StatefulWidget {
  const MapaGoogle({Key? key}) : super(key: key);

  @override
  State<MapaGoogle> createState() => _MapaGoogle();
}

class _MapaGoogle extends State<MapaGoogle> {

  late GoogleMapController mapaControlador;
  late LatLng localizacaoUsuario;

  List<Marker> marcadores = [];

  bool temLocalizacaoUsuario = false;

  @override
  void initState() {
    super.initState();
    getLocalizacaoUsuario();
  }

  void getLocalizacaoUsuario() async {
    dynamic coords = await LocalizacaoGPS().localizacaoUsuario;
    setState(() {
      localizacaoUsuario = LatLng(coords.latitude, coords.longitude);
      temLocalizacaoUsuario = true;
      mapaControlador.animateCamera(
        CameraUpdate.newLatLngZoom(localizacaoUsuario, 15)
        );
    });
  }

  void _onMapCreated(GoogleMapController controlador) async {
    mapaControlador = controlador;
  }

  void adicionarMarcacao(double lat, double long) {
    setState(() {
      Marker novaMarcacao = Marker(
        markerId: MarkerId((marcadores.length + 1).toString()),
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarker,
        onTap: (){
          Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistrarMarcacao()),
              );
        }
      );
      marcadores.add(novaMarcacao);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        zoomControlsEnabled: false,
        initialCameraPosition: const CameraPosition(
          target: LatLng(-23.5489, -46.6388), //sao paulo coords
          zoom: 3.0,
        ),
        myLocationEnabled: temLocalizacaoUsuario,
        markers: marcadores.map((mark) => mark).toSet(),
        onLongPress: (argument) {
          adicionarMarcacao(argument.latitude, argument.longitude);
        },
      ),
    );
  }
}

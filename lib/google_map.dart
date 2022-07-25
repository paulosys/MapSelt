import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatefulWidget {
  const Mapa({Key? key}) : super(key: key);

  @override
  _MapaState createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  late GoogleMapController mapController;
  
  final LatLng _center = const LatLng(-7.112698572494305, -34.88402598608657);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

   

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
        target: _center,
        zoom: 11.0,
      ),
    );
  }
}
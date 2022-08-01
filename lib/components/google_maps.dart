import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapselt/controllers/google_maps_controller.dart';
import 'package:provider/provider.dart';

class MapaGoogle extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  MapaGoogle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: ChangeNotifierProvider<GoogleMapsController>(
        create: (context) => GoogleMapsController(),
        child: Builder(builder: (context) {
          final local = context.watch<GoogleMapsController>();
          return Stack(
            children: [
              GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(-23.5489, -46.6388), //sao paulo coords
                  zoom: 3.0,
                ),
                zoomControlsEnabled: false,
                onMapCreated: (controller) {
                  local.onMapCreated(controller, scaffoldKey);
                },
                myLocationEnabled: true,
                markers: local.markers,
                onLongPress: ((argument) {
                  local.showMarkerInfo(argument);
                }),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      local.loadMarkers();
                    },
                    icon: const Icon(Icons.autorenew),
                    color: Colors.black,
                  ),
                  IconButton(
                    onPressed: () {
                      local.criarMarkerGPS();
                    },
                    icon: const Icon(Icons.location_on_outlined),
                    color: Colors.black,
                  )
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}

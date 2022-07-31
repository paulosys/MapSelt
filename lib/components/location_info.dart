import 'package:flutter/material.dart';
import 'package:mapselt/pages/register_page.dart';

class LocationInfo extends StatelessWidget {
  late String endereco;
  late double latitude;
  late double longitude;

  LocationInfo(
      {Key? key,
      required this.endereco,
      required this.latitude,
      required this.longitude})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.cyan,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(endereco,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              Text("$latitude, $longitude",
                  style: const TextStyle(color: Colors.white)),
            ],
          ),
          Wrap(children: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrarMarcacao(
                              latitude: latitude, longitude: longitude)));
                },
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: 'Salvar  ',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      WidgetSpan(child: Icon(Icons.save, color: Colors.white)),
                    ],
                  ),
                )),
          ]),
        ],
      ),
    );
  }
}

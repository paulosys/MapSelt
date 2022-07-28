import 'package:flutter/material.dart';
import 'package:mapselt/pages/register_page.dart';
import '../components/google_map.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("MapSelt"),
          backgroundColor: Colors.green[700],
        ),
        body: const MapaGoogle(),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegistrarMarcacao()),
              );
            },
            backgroundColor: Colors.green[900],
            child: const Icon(Icons.add)));
  }
}

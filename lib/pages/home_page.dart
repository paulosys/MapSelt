import 'package:flutter/material.dart';
import '../components/google_maps.dart';

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
      body: MapaGoogle(),
    );
  }
}

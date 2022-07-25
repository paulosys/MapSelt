import 'package:flutter/material.dart';
import 'google_map.dart';
import 'locationGPS.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var inputAddrController = TextEditingController();
  var locationGPS = new LocationGPS();

  @override
  void initState() {
    super.initState();
    locationGPS.getLoc();
  }

  void searchGeoCord(text) {
    print(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MapSelt'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          /*Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: TextField(
              controller: inputAddrController,
              onSubmitted: (value) {
                searchGeoCord(value);
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: IconButton(
                  onPressed: () => searchGeoCord(inputAddrController.text),
                  icon: const Icon(Icons.search),
                ),
                hintText: 'Digite o endereço: ',
              ),
            ),
          ),*/
          const Expanded(
            child: Mapa(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("clicou");
        },
        backgroundColor: Colors.green[900],
        child: const Icon(Icons.add),
      ),
    );
  }
}

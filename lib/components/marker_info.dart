import 'package:flutter/material.dart';
import 'package:mapselt/pages/marker_crud.dart';
import 'package:mapselt/model/user_marker_model.dart';

class MarkerInfo extends StatelessWidget {
  UserMarker marker;
  MarkerInfo({Key? key, required this.marker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green[300],
      child: Column(
        children: [
        if (1 != 1) Image.network(marker.tipo),
        Padding(
            padding: const EdgeInsets.only(top: 24, left: 24),
            child: Text(
              marker.nome,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              marker.descricao,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              marker.tipo,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              marker.dataVisita,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )),
        Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Text(
              marker.observacao,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MarkerCRUD(
                                marker: marker,
                              )));
                },
                child: const Text("Editar"))
          ],
        )
      ]),
    );
  }
}

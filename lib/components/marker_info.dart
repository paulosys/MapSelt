import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapselt/pages/marker_crud.dart';
import 'package:mapselt/model/user_marker_model.dart';

class MarkerInfo extends StatelessWidget {
  UserMarker marker;
  MarkerInfo({Key? key, required this.marker}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? imagemSelecionada = marker.imagemPath;

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(marker.nome,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              imagemSelecionada == null
                  ? Container()
                  : SizedBox(
                      height: 200,
                      child: Image.file(File(imagemSelecionada)),
                    ),
              Column(
                children: [
                  Text("Descrição: ${marker.descricao}",
                      style: const TextStyle(color: Colors.black)),
                  Text("Tipo: ${marker.tipo}",
                      style: const TextStyle(color: Colors.black)),
                  Text("Data da Visita: ${marker.dataVisita}",
                      style: const TextStyle(color: Colors.black)),
                  Text("Observações: ${marker.observacao}",
                      style: const TextStyle(color: Colors.black)),
                ],
              ),
            ],
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
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
                    child: const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                              text: 'Editar  ',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          WidgetSpan(
                              child: Icon(Icons.edit, color: Colors.black)),
                        ],
                      ),
                    )),
              ]),
        ],
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mapselt/helpers/database_helper.dart';
import 'package:mapselt/model/user_marker_model.dart';
import 'package:image_picker/image_picker.dart';

class RegistrarMarcacao extends StatefulWidget {
  late double latitude;
  late double longitude;

  RegistrarMarcacao({Key? key, required this.latitude, required this.longitude})
      : super(key: key);

  @override
  State<RegistrarMarcacao> createState() => _RegistrarMarcacaoState();
}

class _RegistrarMarcacaoState extends State<RegistrarMarcacao> {
  final _registerFormKey = GlobalKey<FormState>();

  TextEditingController nomeController = TextEditingController(),
      descricaoController = TextEditingController(),
      dataVisitaController = TextEditingController(),
      observacaoController = TextEditingController();

  String tipoMarker = "publico";

  final dbHelper = DatabaseHelper.instancia;

  ImagePicker imagePicker = ImagePicker();
  XFile? imagemSelecionada;

  void registrarMarker() async {
    String nome = nomeController.text;
    String descricao = descricaoController.text;
    String dataVisita = dataVisitaController.text;
    String tipo = tipoMarker;
    String observacao = observacaoController.text;
    String? imgpath;

    if (imagemSelecionada != null) {
      imgpath = imagemSelecionada!.path;
    }

    UserMarker novaMarcacao = UserMarker(
      id: await dbHelper.getLenghtDb() + 1,
      nome: nome,
      descricao: descricao,
      dataVisita: dataVisita,
      tipo: tipo,
      observacao: observacao,
      imagemPath: imgpath,
      latitude: widget.latitude,
      longitude: widget.longitude,
    );

    dbHelper.inserirMarker(novaMarcacao);
  }

  void pegarImagemGaleria() async {
    final XFile? imgTemp =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (imgTemp != null) {
      setState(() {
        imagemSelecionada = imgTemp;
      });
    }
  }

  void pegarImagemCamera() async {
    final XFile? imgTemp =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (imgTemp != null) {
      setState(() {
        imagemSelecionada = imgTemp;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("MapSelt"),
          backgroundColor: Colors.green[700],
        ),
        body: Form(
          key: _registerFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              children: <Widget>[
                imagemSelecionada == null
                    ? Container()
                    : SizedBox(
                        height: 200,
                        child: Image.file(File(imagemSelecionada!.path)),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: pegarImagemCamera,
                        icon: const Icon(Icons.camera_alt_outlined)),
                    IconButton(
                        onPressed: pegarImagemGaleria,
                        icon: const Icon(Icons.photo_album)),
                  ],
                ),
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Nome da localização:',
                  ),
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return "Campo Obrigatorio";
                    }
                    return null;
                  }),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: descricaoController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Descrição:',
                  ),
                  textInputAction: TextInputAction.next,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Radio(
                      value: "publico",
                      groupValue: tipoMarker,
                      onChanged: (value) {
                        setState(() {
                          tipoMarker = value.toString();
                        });
                      },
                    ),
                    const Text("Publico"),
                    Radio(
                      value: "privado",
                      groupValue: tipoMarker,
                      onChanged: (value) {
                        setState(() {
                          tipoMarker = value.toString();
                        });
                      },
                    ),
                    const Text("Privado"),
                    Radio(
                      value: "outro",
                      groupValue: tipoMarker,
                      onChanged: (value) {
                        setState(() {
                          tipoMarker = value.toString();
                        });
                      },
                    ),
                    const Text("Outro"),
                  ],
                ),
                TextFormField(
                  controller: dataVisitaController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Data da visita:',
                  ),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: observacaoController,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Observações:',
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_registerFormKey.currentState!.validate()) {
              registrarMarker();
              Navigator.pop(context);
            }
          },
          backgroundColor: Colors.green[900],
          child: const Icon(Icons.save),
        ));
  }
}

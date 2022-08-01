import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapselt/helpers/database_helper.dart';
import 'package:mapselt/model/user_marker_model.dart';

class MarkerCRUD extends StatefulWidget {
  late UserMarker marker;

  MarkerCRUD({Key? key, required this.marker}) : super(key: key);

  @override
  State<MarkerCRUD> createState() => _MarkerCRUDState();
}

class _MarkerCRUDState extends State<MarkerCRUD> {
  final _crudFormKey = GlobalKey<FormState>();

  late TextEditingController nomeController;
  late TextEditingController descricaoController;
  late TextEditingController dataVisitaController;
  late TextEditingController observacaoController;
  late String? imagempath;
  late String tipoMarker;

  ImagePicker imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.marker.nome);
    descricaoController = TextEditingController(text: widget.marker.descricao);
    dataVisitaController =
        TextEditingController(text: widget.marker.dataVisita);
    observacaoController =
        TextEditingController(text: widget.marker.observacao);
    tipoMarker = widget.marker.tipo;
    imagempath = widget.marker.imagemPath;
  }

  void excluirMarker(UserMarker marker) {
    final dbHelper = DatabaseHelper.instancia;
    dbHelper.deleteMarker(marker.id);
    Navigator.pop(context);
  }

  void atualizarMarker() {
    final dbHelper = DatabaseHelper.instancia;
    String nome = nomeController.text;
    String descricao = descricaoController.text;
    String dataVisita = dataVisitaController.text;
    String tipo = tipoMarker;
    String observacao = observacaoController.text;
    String? img = imagempath;

    UserMarker marker = UserMarker(
      id: widget.marker.id,
      nome: nome,
      descricao: descricao,
      dataVisita: dataVisita,
      tipo: tipo,
      observacao: observacao,
      imagemPath: img,
      latitude: widget.marker.latitude,
      longitude: widget.marker.longitude,
    );

    dbHelper.updateMarker(marker);
  }

  void pegarImagemGaleria() async {
    final XFile? imgTemp =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (imgTemp != null) {
      setState(() {
        imagempath = imgTemp.path;
      });
    }
  }

  void pegarImagemCamera() async {
    final XFile? imgTemp =
        await imagePicker.pickImage(source: ImageSource.camera);
    if (imgTemp != null) {
      setState(() {
        imagempath = imgTemp.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.marker.nome),
                IconButton(
                    onPressed: (() => excluirMarker(widget.marker)),
                    icon: const Icon(Icons.delete_forever))
              ],
            ),
          ),
        ),
        body: Form(
          key: _crudFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 10.0,
            ),
            child: Column(
              children: <Widget>[
                imagempath == null
                    ? Container()
                    : SizedBox(
                        height: 200,
                        child: Image.file(File(imagempath!)),
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
                      labelText: 'Nome: ',
                      suffixIcon: Icon(Icons.edit)),
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
                      labelText: 'Descrição: ',
                      suffixIcon: Icon(Icons.edit)),
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
                      suffixIcon: Icon(Icons.edit)),
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  controller: observacaoController,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Observações:',
                      suffixIcon: Icon(Icons.edit)),
                  textInputAction: TextInputAction.done,
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_crudFormKey.currentState!.validate()) {
              atualizarMarker();
              Navigator.pop(context);
            }
          },
          backgroundColor: Colors.green[900],
          child: const Icon(Icons.save),
        ));
  }
}

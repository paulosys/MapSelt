import 'package:flutter/material.dart';
import 'package:mapselt/helpers/database_helper.dart';
import 'package:mapselt/model/user_marker_model.dart';

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

  String tipoMarker = "public";
  final dbHelper = DatabaseHelper.instancia;

  void registrarLugar() async {
    String nome = nomeController.text;
    String descricao = descricaoController.text;
    String dataVisita = dataVisitaController.text;
    String tipo = tipoMarker;
    String observacao = observacaoController.text;

    UserMarker novaMarcacao = UserMarker(
      id: await dbHelper.getLenghtDb() + 1,
      nome: nome,
      descricao: descricao,
      dataVisita: dataVisita,
      tipo: tipo,
      observacao: observacao,
      latitude: widget.latitude,
      longitude: widget.longitude,
    );

    dbHelper.inserirMarker(novaMarcacao);
  }

  Future uepa() async {
    var marcacoes = await dbHelper.consultarTodasMarcacoes();

    marcacoes.forEach(
      (element) {
        print(element.toMap());
      },
    );

    return marcacoes;
  }

  @override
  Widget build(BuildContext context) {
    String _tipo = 'publico';

    return Scaffold(
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
                      groupValue: _tipo,
                      onChanged: (value) {
                        setState(() {
                          tipoMarker = value.toString();
                          _tipo = value.toString();
                        });
                      },
                    ),
                    const Text("Publico"),
                    Radio(
                      value: "privado",
                      groupValue: _tipo,
                      onChanged: (value) {
                        setState(() {
                          tipoMarker = value.toString();
                          _tipo = value.toString();
                        });
                      },
                    ),
                    const Text("Privado"),
                    Radio(
                      value: "outro",
                      groupValue: _tipo,
                      onChanged: (value) {
                        setState(() {
                          tipoMarker = value.toString();
                          _tipo = value.toString();
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
                TextButton(
                    onPressed: () {
                      uepa();
                    },
                    child: const Text("Consultar"))
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_registerFormKey.currentState!.validate()) {
              registrarLugar();
              Navigator.pop(context);
            }
          },
          backgroundColor: Colors.green[900],
          child: const Icon(Icons.save),
        ));
  }
}

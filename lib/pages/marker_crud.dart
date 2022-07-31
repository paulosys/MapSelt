import 'package:flutter/material.dart';
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
  String tipoMarker = 'publico';

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.marker.nome);
    descricaoController = TextEditingController(text: widget.marker.descricao);
    dataVisitaController =
        TextEditingController(text: widget.marker.dataVisita);
    observacaoController =
        TextEditingController(text: widget.marker.observacao);
  }

  Future uepa() async {
    final dbHelper = DatabaseHelper.instancia;
    var marcacoes = await dbHelper.consultarTodasMarcacoes();

    marcacoes.forEach(
      (element) {
        print(element.toMap());
      },
    );

    return marcacoes;
  }

  void excluirMarker(UserMarker marker) {
    final dbHelper = DatabaseHelper.instancia;
    dbHelper.deleteMarker(marker.id);
  }

  void atualizarLugar() {
    final dbHelper = DatabaseHelper.instancia;
    String nome = nomeController.text;
    String descricao = descricaoController.text;
    String dataVisita = dataVisitaController.text;
    String tipo = tipoMarker;
    String observacao = observacaoController.text;

    UserMarker marker = UserMarker(
      id: widget.marker.id,
      nome: nome,
      descricao: descricao,
      dataVisita: dataVisita,
      tipo: tipo,
      observacao: observacao,
      latitude: widget.marker.latitude,
      longitude: widget.marker.longitude,
    );

    dbHelper.updateMarker(marker);
  }

  @override
  Widget build(BuildContext context) {
    String _tipo = 'publico';

    return Scaffold(
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
            if (_crudFormKey.currentState!.validate()) {
              atualizarLugar();
              Navigator.pop(context);
            }
          },
          backgroundColor: Colors.green[900],
          child: const Icon(Icons.save),
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:mapselt/helpers/database_helper.dart';
import 'package:mapselt/model/model.dart';

class RegistrarMarcacao extends StatefulWidget {
  const RegistrarMarcacao({Key? key}) : super(key: key);

  @override
  State<RegistrarMarcacao> createState() => _RegistrarMarcacaoState();
}

class _RegistrarMarcacaoState extends State<RegistrarMarcacao> {
  TextEditingController nomeControlador = TextEditingController(),
      descricaoControlador = TextEditingController(),
      dataVisitaControlador = TextEditingController(),
      observacaoControlador = TextEditingController();

  final dbHelper = DatabaseHelper.instancia;

  void registrarLugar() {
    String nome = nomeControlador.text;
    String descricao = descricaoControlador.text;
    String dataVisita = dataVisitaControlador.text;
    String tipo = "public";
    String observacao = observacaoControlador.text;

    MarcacaoUsuario novaMarcacao = MarcacaoUsuario(
        nome: nome,
        descricao: descricao,
        dataVisita: dataVisita,
        tipo: tipo,
        observacao: observacao);

    dbHelper.inserirMarcacao(novaMarcacao);
  }

  Future uepa() async {
    var marcacoes = await dbHelper.consultarTodasMarcacoes();
    print(marcacoes);
    return marcacoes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("MapSelt"),
          backgroundColor: Colors.green[700],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: nomeControlador,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nome da localização:',
                ),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: descricaoControlador,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Descrição:',
                ),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: dataVisitaControlador,
                keyboardType: TextInputType.datetime,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Data da visita:',
                ),
                textInputAction: TextInputAction.next,
              ),
              TextFormField(
                controller: observacaoControlador,
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
        floatingActionButton: FloatingActionButton(
          onPressed: registrarLugar,
          backgroundColor: Colors.green[900],
          child: const Icon(Icons.save),
        ));
  }
}

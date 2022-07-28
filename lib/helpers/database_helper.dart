import 'dart:io';
import 'dart:async';
import 'package:mapselt/model/model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final String _tabelaMarcacao = 'marcacao_mapa';
  final String _colId = 'id';
  final String _colNome = 'nome';
  final String _colDescricao = 'descricao';
  final String _colTipo = 'tipo';
  final String _colDataVisita = 'dataVisita';
  final String _colObservacao = 'observacao';

  // Contrutor com acesso privado
  DatabaseHelper._();

  // Criar uma instancia de DatabaseHelper
  static final DatabaseHelper instancia = DatabaseHelper._();

  // Instancia do SQLite
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'markpoint'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(Database db, version) async {
    await db.execute('''
          CREATE TABLE $_tabelaMarcacao (
            $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_colNome TEXT NOT NULL,
            $_colDescricao TEXT,
            $_colTipo TEXT,
            $_colDataVisita INT,
            $_colObservacao TEXT
          )
          ''');
  }

  void inserirMarcacao(MarcacaoUsuario marcacao) async {
    Database db = await DatabaseHelper.instancia.database;

    await db.insert(_tabelaMarcacao, marcacao.toMap());
  }

  Future<Set<Map<String, dynamic>>?> consultarTodasMarcacoes() async {
    Database db = await instancia.database;
    List<Map<String, dynamic>> item = await db.query(_tabelaMarcacao);

    if (item.isNotEmpty) {
      return item.toSet();
    }

    return null;
    //return await db.query(_tabelaMarcacao);
  }
}

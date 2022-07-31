import 'dart:async';
import 'package:mapselt/model/user_marker_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  final String _tabelaMarker = 'marker_mapa';
  final String _colId = 'id';
  final String _colNome = 'nome';
  final String _colDescricao = 'descricao';
  final String _colTipo = 'tipo';
  final String _colDataVisita = 'dataVisita';
  final String _colObservacao = 'observacao';
  final String _colLatitude = 'latitude';
  final String _colLongitude = 'longitude';

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
          CREATE TABLE $_tabelaMarker (
            $_colId INTEGER PRIMARY KEY AUTOINCREMENT,
            $_colNome TEXT NOT NULL,
            $_colDescricao TEXT,
            $_colTipo TEXT,
            $_colDataVisita TEXT,
            $_colObservacao TEXT,
            $_colLatitude NUMERIC NOT NULL,
            $_colLongitude NUMERIC NOT NULL
          )
          ''');
  }

  Future<UserMarker> getMarker(id) async {
    Database db = await instancia.database;
    List<Map<String, Object?>> maps =
        await db.query(_tabelaMarker, where: 'id = ?', whereArgs: [id]);

    UserMarker marker = UserMarker.fromMap(maps.first);
    print("marker: $marker");
    return marker;
  }

  void inserirMarker(UserMarker marker) async {
    Database db = await DatabaseHelper.instancia.database;
    await db.insert(_tabelaMarker, marker.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  void deleteMarker(id) async {
    Database db = await DatabaseHelper.instancia.database;

    db.delete(_tabelaMarker, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<UserMarker>> consultarTodasMarcacoes() async {
    Database db = await instancia.database;

    List<Map<String, dynamic>> maps = await db.query(_tabelaMarker);

    return List.generate(maps.length, (index) {
      return UserMarker.fromMap(maps[index]);
    });
  }

  void updateMarker(UserMarker marker) async {
    Database db = await instancia.database;
    await db.update(_tabelaMarker, marker.toMap(),
        where: 'id = ?', whereArgs: [marker.id]);
  }

  Future<int> getLenghtDb() async {
    Database db = await instancia.database;
    List<Map<String, dynamic>> maps = await db.query(_tabelaMarker);
    return maps.length;
  }
}

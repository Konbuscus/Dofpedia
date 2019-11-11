
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'models/classes.dart';

class DataBaseHelper {
  static final databaseName = "userData.db";
  static final databaseVersion = 1;
  static final charactersTable = "characters";
  static final columnId = "_id";
  static final columnName = "nom";
  static final columnClass = "type";
  static final columnItemsEquipped = "items";
  static final columnUrlImg = "url";

  //On fait un singleton
  DataBaseHelper._privateConstructor();
  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, databaseName);
    return await openDatabase(path,
        version: databaseVersion, onCreate: onCreate);
  }

  Future onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE $charactersTable (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnUrlImg TEXT NULL,
        $columnClass TEXT NOT NULL,
        $columnItemsEquipped TEXT NOT NULL
      )
      ''');

      //Tables des classes
     //Récupération des classes et insertion dans la base + création de la table 
 
     //await db.execute("CREATE TABLE CLASSES (_id INTEGER PRIMARY KEY, " +
     // "nom TEXT NOT NULL, url TEXT NOT NULL)"); 

      
  }
  //$columnClass TEXT NOT NULL,
  /*Méthodes helper*/

  //Insère une ligne dans la base ou chaque clé est un nom de colonne
  //La valeur retournée est l'id de la ligne créee
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(charactersTable, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(charactersTable);
  }

  //Mise à joru d'une ligne via l'id
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db
        .update(charactersTable, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Supprime une ligne via l'id
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db
        .delete(charactersTable, where: '$columnId = ?', whereArgs: [id]);
  }

  //Exemple d'une méthode sql pure
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $charactersTable'));
  }

 
}

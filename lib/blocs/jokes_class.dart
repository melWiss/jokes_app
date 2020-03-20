import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Joke {
  String table,id, content;
  int upvotes, downvotes;
  Joke({this.id, this.content, this.upvotes, this.downvotes,this.table});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'upvotes': upvotes,
      'downvotes': downvotes
    };
  }

  Future retrieveJokesDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'jokes_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE "+table+"(id TEXT PRIMARY KEY, content TEXT, upvotes INTEGER, downvotes INTEGER)",
        );
      },
      version: 1,
    );

    return database;
  }

  Future<void> insertJoke(Joke joke) async {
    final Database db = await retrieveJokesDatabase();
    await db.insert(
      table,
      joke.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Joke>> getLocalJokes() async {
    final Database db = await retrieveJokesDatabase();
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Joke(
        id: maps[i]['id'],
        content: maps[i]['content'],
        upvotes: maps[i]['upvotes'],
        downvotes: maps[i]['downvotes'],
      );
    });
  }

  Future<void> updateLocalJokes(Joke joke) async {
    final db = await retrieveJokesDatabase();
    await db.update(
      table,
      joke.toMap(),
      where: "id = ?",
      whereArgs: [joke.id],
    );
  }

  Future<void> deleteLocalJoke(String id) async {
    final db = await retrieveJokesDatabase();
    await db.delete(
      table,
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
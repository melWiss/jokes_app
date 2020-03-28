import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Joke {
  String table, joke;
  int id, upvotes, downvotes, votes;
  Joke(
      {this.id,
      this.joke,
      this.upvotes,
      this.downvotes,
      this.table,
      this.votes});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'joke': joke,
      'upvotes': upvotes,
      'downvotes': downvotes,
      'votes': votes,
    };
  }

  Future retrieveJokesDatabase() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'jokes_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE " +
              table +
              "(id INTEGER PRIMARY KEY, joke TEXT, upvotes INTEGER, downvotes INTEGER, votes INTEGER)",
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
          joke: maps[i]['joke'],
          upvotes: maps[i]['upvotes'],
          downvotes: maps[i]['downvotes'],
          votes: maps[i]['votes']);
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

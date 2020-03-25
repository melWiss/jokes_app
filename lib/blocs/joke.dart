import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'jokes_class.dart';

class JokesApi {
  List _jokes = [];
  int _counter = 0;
  final StreamController<List> _streamController = StreamController<List>();
  Stream<List> get jokesStream => _streamController.stream;
  StreamSink<List> get _jokesSink => _streamController.sink;

  JokesApi() {
    //_streamController.add(_jokes);
    initJokes();
  }

  initJokes() {
    _counter = 0;
    _jokes = [];
    for (int i = 0; i < 3; i++) {
      getJokes().then((value) {
        if (value != "NULL") _jokes.add(value);
      }).whenComplete(() => _jokesSink.add(_jokes));
    }
  }

  tellJoke(String joke) async {
    var response = await http.post(
      "https://elwiss-jokes.herokuapp.com/postJoke",
      body: jsonEncode({
        "joke":joke,
      },)
    );
  }

  swipeRight() {
    Joke jo = Joke(table: 'JOKES');
    jo.insertJoke(Joke(
      id: _jokes[_counter]['id'],
      joke: _jokes[_counter]['joke'],
      upvotes: _jokes[_counter]['upvotes'] + 1,
      downvotes: _jokes[_counter]['downvotes'],
      votes: _jokes[_counter]['votes'] + 1,
    ));
    voteJoke(_jokes[_counter]['id'], true).then((value) {
      if (value != "NULL") {
        print("upvotes:joke " + value['upvotes'].toString());
      }
    });
    _counter++;
    print("index: " + _counter.toString());
    getJokes().then((value) {
      if (value != "NULL") {
        _jokes.add(value);
        _jokesSink.add(_jokes);
      }
    });
  }

  swipeLeft() {
    voteJoke(_jokes[_counter]['id'], false).then((value) {
      if (value != "NULL") {
        print("downvotes: " + value['downvotes'].toString());
      }
    });
    _counter++;
    print("index: " + _counter.toString());
    getJokes().then((value) {
      if (value != "NULL") {
        _jokes.add(value);
        _jokesSink.add(_jokes);
      }
    });
  }

  Future voteJoke(int jokeId, bool jokeVote) async {
    var result;
    var response;
    try {
      if (jokeVote)
        response = await http.post(
          "https://elwiss-jokes.herokuapp.com/upvoteJoke",
          body: jsonEncode(
            {'id': jokeId},
          ),
        );
      else
        response = await http.post(
          "https://elwiss-jokes.herokuapp.com/downvoteJoke",
          body: jsonEncode(
            {
              'id': jokeId,
            },
          ),
        );
      result = jsonDecode(response.body)['jokes'];
      print(jsonEncode(result));
    } catch (e) {
      print(e.toString());
      result = "NULL";
    }
    return result;
  }

  Future getJokes() async {
    var result;
    try {
      var response = await http.get(
        "https://elwiss-jokes.herokuapp.com/getRandomJoke",
      );
      result = jsonDecode(response.body)['jokes'];
    } catch (e) {
      result = "NULL";
    }
    return result;
  }

  dispose() {
    _streamController.close();
  }

  int getCounter() {
    return _counter;
  }
}

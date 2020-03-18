import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  initJokes(){
    for (int i = 0; i < 3; i++) {
      getJokes().then((value) {
        if (value != "NULL") _jokes.add(value);
      }).whenComplete(() => _jokesSink.add(_jokes));
    }
  }

  swipeRight() {
    _counter++;
    print("index: "+_counter.toString());
    getJokes().then((value) {
      if (value != "NULL") {
        _jokes.add(value);
        _jokesSink.add(_jokes);
      }
    });
  }

  Future getJokes() async {
    var result;
    try {
      var response =
          await http.get("https://joke3.p.rapidapi.com/v1/joke", headers: {
        "x-rapidapi-host": "joke3.p.rapidapi.com",
        "x-rapidapi-key": "82f039ffd4msh4f43b5938417b2fp11abd7jsne56264a66ebb"
      });
      result = jsonDecode(response.body)['content'];
    } catch (e) {
      result = "NULL";
    }
    return result;
  }

  dispose() {
    _streamController.close();
  }

  int getCounter(){
    return _counter;
  }
}

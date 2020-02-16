import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JokesApi {
  List _jokes = [];
  final StreamController<List> _streamController = StreamController<List>();
  Stream<List> get jokesStream => _streamController.stream;
  StreamSink<List> get _jokesSink => _streamController.sink;

  JokesApi() {
    //_streamController.add(_jokes);
    /*for (int i = 0; i < 3; i++) {
      getJokes().then((value) {
        _jokes.add(value);
      }).whenComplete(() => _jokesSink.add(_jokes));
    }*/
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      getJokes().then((value) {
        _jokes.add(value);
      }).whenComplete(() => _jokesSink.add(_jokes));
    });
  }

  swipeRight() {
    /*getJokes().then((value) {
        _jokes.add(value);
        _jokesSink.add(_jokes);
      });*/
  }

  Future getJokes() async {
    var response =
        await http.get("https://joke3.p.rapidapi.com/v1/joke", headers: {
      "x-rapidapi-host": "joke3.p.rapidapi.com",
      "x-rapidapi-key": "82f039ffd4msh4f43b5938417b2fp11abd7jsne56264a66ebb"
    });
    var result = jsonDecode(response.body);
    return result['content'];
  }

  dispose() {
    _streamController.close();
  }
}

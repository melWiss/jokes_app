import 'package:flutter/material.dart';
import 'dart:io';
import 'swipable_cards.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:jokes_app/blocs/joke.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux)
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokes',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        fontFamily: 'Roboto',
      ),
      home: MyHomePage(title: 'Jokes'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var bottomIndex;
  int index;
  JokesApi jokesApi = JokesApi();

  @override
  void initState() {
    super.initState();
    bottomIndex = 0;
    index = 0;
  }

  @override
  void dispose() {
    jokesApi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: StreamBuilder<List>(
            stream: jokesApi.jokesStream,
            builder: (context, snap) {
              if (snap.hasData) {
                print(snap.data.length);
                if (snap.data.length != 0 &&
                    jokesApi.getCounter() < snap.data.length)
                  return SwipeCards(
                    borderColor: Colors.black,
                    onSwipedLeftAppear: Container(
                      color: Colors.red,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "😒",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 100,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Meh",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onSwipedRightAppear: Container(
                      color: Colors.green,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "😂",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 100,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "Haha",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    screenHeight: MediaQuery.of(context).size.height,
                    screenWidth: MediaQuery.of(context).size.width,
                    onDoubleTap: () => print("double tapped"),
                    onSwipeLeft: () {
                      setState(() {
                        jokesApi.swipeLeft();
                      });
                    },
                    onSwipeRight: () {
                      setState(() {
                        jokesApi.swipeRight();
                      });
                    },
                    children: List<Widget>.generate(
                      snap.data.length,
                      (index) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Text(
                              snap.data[index]['content'].toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                else
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "There's no jokes :(\nCheck your internet connection.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18),
                      ),
                      FlatButton(
                        onPressed: () {
                          jokesApi.initJokes();
                        },
                        child: Text(
                          "Refresh",
                          style: TextStyle(color: Colors.black),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            side: BorderSide(width: 2, color: Colors.yellow)),
                        color: Colors.yellow,
                      )
                    ],
                  );
              }
              return CircularProgressIndicator();
            }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.yellow,
        currentIndex: bottomIndex,
        onTap: (int tappedIndex) {
          setState(() {
            bottomIndex = tappedIndex;
          });
        },
        items: [
          BottomNavigationBarItem(
            title: Text("Jokes"),
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            title: Text("My Jokes"),
            icon: Icon(Icons.local_activity),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.yellowAccent,
        label: Text("Tell a Joke!"),
        onPressed: () {},
        tooltip: 'Tell a joke to the community',
        icon: Icon(Icons.add),
      ),
    );
  }
}

/*
return SwipeCards(
                  onSwipedLeftAppear: Container(
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        "LEFT",
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  onSwipedRightAppear: Container(
                    color: Colors.blue,
                    child: Center(
                      child: Text(
                        "RIGHT",
                        style: TextStyle(
                          fontSize: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  screenHeight: MediaQuery.of(context).size.height,
                  screenWidth: MediaQuery.of(context).size.width,
                  onDoubleTap: () => print("double tapped"),
                  onSwipeLeft: () => jokesApi.swipeRight(),
                  onSwipeRight: () => jokesApi.swipeRight(),
                  children: List<Widget>.generate(
                    snap.data.length,
                    (index) {
                      return Center(
                        child: Text(
                          snap.data[index].toString() + " $index",
                          style: TextStyle(fontSize: 30),
                        ),
                      );
                    },
                  ),
                )
*/

//----------------------------------------------------
/*return ListView.builder(itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(50),
                          child: Center(
                            child: Text(snap.data[index]),
                          ),
                        ),
                      ),
                    ),
                  );
                },itemCount: snap.data.length,);*/

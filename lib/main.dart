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
                print(snap.data);
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
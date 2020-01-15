import 'package:flutter/material.dart';
import 'dart:io';
import 'swipable_cards.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;

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
  SwipeCards swipeCards;

  @override
  void initState() {
    super.initState();
    bottomIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    swipeCards = SwipeCards(
      screenHeight: screenHeight,
      screenWidth: screenWidth,
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: swipeCards,
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
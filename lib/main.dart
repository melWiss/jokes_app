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
  int index;

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
        child: SwipeCards(
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
          children: List<Widget>.generate(
            10,
            (index) {
              return Center(
                child: Text(
                  "Card number $index",
                  style: TextStyle(fontSize: 30),
                ),
              );
            },
          ),
        ),
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

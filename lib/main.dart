import 'package:flutter/material.dart';
import 'dart:io';
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
  SwipeCards2 swipeCards2;

  @override
  void initState() {
    super.initState();
    bottomIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    swipeCards2 = SwipeCards2(
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
        child: swipeCards2,
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

class SwipeCards extends StatelessWidget {
  const SwipeCards({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .7,
      width: MediaQuery.of(context).size.width * .9,
      //color: Colors.white,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 2,
            height: (MediaQuery.of(context).size.height * .7) * .55,
            width: (MediaQuery.of(context).size.width * .9) * .75,
            left: ((MediaQuery.of(context).size.width * .9) * .25) / 2,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Container(
                  color: Colors.white38,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            height: (MediaQuery.of(context).size.height * .7) * .75,
            width: (MediaQuery.of(context).size.width * .9) * .95,
            left: ((MediaQuery.of(context).size.width * .9) * .05) / 2,
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Container(
                  color: Colors.white38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SwipeCards2 extends StatefulWidget {
  const SwipeCards2({
    Key key,
    this.screenHeight,
    this.screenWidth,
  }) : super(key: key);
  final double screenHeight, screenWidth;

  @override
  _SwipeCards2State createState() => _SwipeCards2State();
}

class _SwipeCards2State extends State<SwipeCards2> {
  double dx1, dx1b, dy1, dx1End, dy1End;
  double dx2, dy2, dx2End, dy2End;
  double dx3, dy3;
  double heightCard2,widthCard2,heightCard2End,widthCard2End;
  Color thirdCardColor;
  int duration;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init(){
    dx1 = ((widget.screenWidth * .9) * .05) / 2;
    dy1 = ((widget.screenHeight * .7) * .25);
    dx1End = dx1;
    dy1End = dy1;
    dx2 = ((widget.screenWidth * .9) * .25) / 2;
    dy2 = ((widget.screenHeight * .7) * .01);
    dx2End = dx2;
    dy2End = dy2;
    heightCard2 = (widget.screenHeight * .7) * .55;
    widthCard2 = (widget.screenWidth * .9) * .75;
    heightCard2End = (widget.screenHeight * .7) * .55;
    widthCard2End = (widget.screenWidth * .9) * .75;
    dx3 = dx2;
    dy3 = dy2;
    thirdCardColor = Colors.white10;
    duration = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .7,
      width: MediaQuery.of(context).size.width * .9,
      child: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(dx3, dy3),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: duration),
                  color: thirdCardColor,
                  height: heightCard2,
                  width: widthCard2,
                ),
              ),
            ),
          ),
          TweenAnimationBuilder(
            tween: Tween<Offset>(
              begin: Offset(dx2, dy2),
              end: Offset(dx2End, dy2End),
            ),
            onEnd: (){
              setState(() {
                init();
              });
            },
            duration: Duration(milliseconds: duration),
            child: Material(
              elevation: 8,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: duration),
                  height: heightCard2End,
                  width: widthCard2End,
                  color: Colors.white38,
                ),
              ),
            ),
            builder: (context, Offset offsetAnimated, Widget card) {
              return Transform.translate(
                child: card,
                offset: offsetAnimated,
              );
            },
          ),
          GestureDetector(
            onHorizontalDragStart: (DragStartDetails details) {
              setState(() {
                dx1 = details.globalPosition.dx - widget.screenWidth / 2;
                dx1End = dx1;
                if(duration == 0)
                  duration = 200;
              });
            },
            onHorizontalDragUpdate: (DragUpdateDetails details) {
              setState(() {
                dx1 = details.globalPosition.dx - widget.screenWidth / 2;
                dx1End = dx1;
              });
            },
            onHorizontalDragEnd: (DragEndDetails details) {
              //print(details.velocity.pixelsPerSecond.toString());
              if (details.velocity.pixelsPerSecond.dx >= 1200) {
                print("dragged right");
                setState(() {
                  dx1End = widget.screenWidth + 20;
                });
              } else if (details.velocity.pixelsPerSecond.dx <= -1200) {
                print("dragged left");
                setState(() {
                  dx1End = -widget.screenWidth - 20;
                });
              } else {
                print("reset position");
                setState(() {
                  dx1 = ((widget.screenWidth * .9) * .05) / 2;
                  dx1End = dx1;
                });
              }
            },
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: dx1, end: dx1End),
              duration: Duration(milliseconds: duration),
              onEnd: () {
                setState(() {
                  if (dx1 != dx1End) {
                    dx2End = ((widget.screenWidth * .9) * .05) / 2;
                    dy2End = dy1;
                    heightCard2End = (widget.screenHeight * .7) * .75;
                    widthCard2End = (widget.screenWidth * .9) * .95;
                    thirdCardColor = Colors.white38;
                  }
                });
              },
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Container(
                    height: (widget.screenHeight * .7) * .75,
                    width: (widget.screenWidth * .9) * .95,
                    color: Colors.white38,
                  ),
                ),
              ),
              builder: (context, double dx1a, card) {
                dx1b = dx1a;
                return Transform.translate(
                  offset: Offset(dx1b, dy1),
                  child: card,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

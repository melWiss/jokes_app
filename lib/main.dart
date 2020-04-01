import 'package:flutter/material.dart';
import 'dart:io';
import 'swipable_cards.dart';
import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:jokes_app/blocs/joke.dart';
import 'package:jokes_app/blocs/jokes_class.dart';

void main() {
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
  Joke joke;
  JokesApi jokesApi = JokesApi();
  double height, width;

  @override
  void initState() {
    super.initState();
    bottomIndex = 0;
    joke = Joke(table: "JOKES");
  }

  @override
  void dispose() {
    jokesApi.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Row(
        children: <Widget>[
          height >= width
              ? Container()
              : NavigationRail(
                  selectedIndex: bottomIndex,
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                        icon: Icon(
                          Icons.home,
                        ),
                        label: Text("Jokes")),
                    NavigationRailDestination(
                        icon: Icon(
                          Icons.local_activity,
                        ),
                        label: Text("My Jokes")),
                  ],
                  onDestinationSelected: (index) {
                    setState(() {
                      bottomIndex = index;
                    });
                  },
                  leading: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton.extended(
                      backgroundColor: Colors.yellowAccent,
                      label: Text("Tell a Joke!"),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => TellJoke(
                              jokesApi: jokesApi,
                            ),
                          ),
                        );
                      },
                      tooltip: 'Tell a joke to the community',
                      icon: Icon(Icons.add),
                    ),
                  ),
                  elevation: 10,
                  labelType: NavigationRailLabelType.selected,
                ),
          Expanded(
            child: IndexedStack(
              index: bottomIndex,
              children: [
                Center(
                  child: StreamBuilder<List>(
                      stream: jokesApi.jokesStream,
                      builder: (context, snap) {
                        if (snap.hasData) {
                          try {
                            print(
                                "u mean here? " + snap.data.length.toString());
                            if (snap.data.length != 0 &&
                                jokesApi.getCounter() < snap.data.length)
                              return SwipeCards(
                                borderColor: Colors.black,
                                onSwipedLeftAppear: Container(
                                  color: Colors.red,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                                screenHeight:
                                    MediaQuery.of(context).size.height,
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
                                          snap.data[index]['joke'].toString(),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        side: BorderSide(
                                            width: 2, color: Colors.yellow)),
                                    color: Colors.yellow,
                                  )
                                ],
                              );
                          } catch (e) {
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      side: BorderSide(
                                          width: 2, color: Colors.yellow)),
                                  color: Colors.yellow,
                                )
                              ],
                            );
                          }
                        }
                        return CircularProgressIndicator();
                      }),
                ),
                FutureBuilder(
                  future: joke.getLocalJokes(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.active)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else if (snap.hasError)
                      return Center(
                        child: Text(
                          snap.error,
                        ),
                      );
                    else if (snap.hasData)
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: height>=width?2:4,
                          crossAxisSpacing: 5
                        ),
                        itemCount: snap.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Material(
                              elevation: 18,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Stack(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                      top: 14,
                                      bottom: 24,
                                      left: 14,
                                      right: 14,
                                    ),
                                    child: Text(
                                      snap.data[index].toMap()['joke'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 5,
                                    right: 5,
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.thumb_up,
                                          color: Colors.green,
                                        ),
                                        Text(snap.data[index]
                                            .toMap()['upvotes']
                                            .toString()),
                                        Icon(
                                          Icons.thumb_down,
                                          color: Colors.red,
                                        ),
                                        Text(snap.data[index]
                                            .toMap()['downvotes']
                                            .toString()),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: height >= width
          ? BottomNavigationBar(
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
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: height >= width
          ? FloatingActionButton.extended(
              backgroundColor: Colors.yellowAccent,
              label: Text("Tell a Joke!"),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TellJoke(
                      jokesApi: jokesApi,
                    ),
                  ),
                );
              },
              tooltip: 'Tell a joke to the community',
              icon: Icon(Icons.add),
            )
          : null,
    );
  }
}

class TellJoke extends StatelessWidget {
  final JokesApi jokesApi;
  TellJoke({this.jokesApi});
  @override
  Widget build(BuildContext context) {
    String joke = "";
    return Scaffold(
      appBar: AppBar(
        title: Text('Tell a joke'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            maxLines: null,
            onChanged: (value) => joke = value,
            style: TextStyle(fontSize: 18),
          ),
          FlatButton(
            onPressed: () async {
              if (joke.length > 0) {
                await jokesApi.tellJoke(joke);
                jokesApi.initJokes();
                Navigator.of(context).pop();
              }
            },
            child: Text(
              "Tell!",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            color: Colors.yellow,
            shape: Border.all(
                width: 2, color: Colors.yellow, style: BorderStyle.solid),
          ),
        ],
      ),
    );
  }
}

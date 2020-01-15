import 'package:flutter/material.dart';

class SwipeCards extends StatefulWidget {
  const SwipeCards({
    Key key,
    this.screenHeight,
    this.screenWidth,
  }) : super(key: key);
  final double screenHeight, screenWidth;

  @override
  _SwipeCardsState createState() => _SwipeCardsState();
}

class _SwipeCardsState extends State<SwipeCards> {
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
    duration = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.screenHeight * .7,
      width: widget.screenWidth * .9,
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
                  duration: Duration(microseconds: duration),
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
                if(duration == 1)
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
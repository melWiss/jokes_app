import 'package:flutter/material.dart';

class SwipeCards extends StatefulWidget {
  const SwipeCards({
    Key key,
    this.screenHeight,
    this.screenWidth,
    this.itemCount,
    this.children,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.onDoubleTap,
  }) : super(key: key);
  final double screenHeight, screenWidth;
  final int itemCount;
  final List<Widget> children;
  final Function onSwipeLeft;
  final Function onSwipeRight;
  final Function onDoubleTap;

  @override
  _SwipeCardsState createState() => _SwipeCardsState();
}

class _SwipeCardsState extends State<SwipeCards> {
  double dx1, dx1b, dy1, dx1End, dy1End;
  double dx2, dy2, dx2End, dy2End;
  double dx3, dy3;
  double heightCard2, widthCard2, heightCard2End, widthCard2End;
  Color thirdCardColor;
  int duration;
  int itemCount;
  Widget card1, card2, card3;
  List<Widget> cards;
  int counter;
  Function onSwipeLeft,onSwipeRight, onDoubleTap;
  @override
  void initState() {
    super.initState();
    itemCount = widget.itemCount;
    counter = 0;
    onSwipeLeft = widget.onSwipeLeft;
    onSwipeRight = widget.onSwipeRight;
    onDoubleTap = widget.onDoubleTap;
    if (widget.children != null) {
      cards = widget.children;
      cards.add(null);
      cards.add(null);
      cards.add(null);
      card1 = cards[counter];
      card2 = cards[counter + 1];
      card3 = cards[counter + 2];
    } else
      cards = [null, null, null];
    init();
  }

  void init() {
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
          card3 != null
              ? Transform.translate(
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
                        child: card3,
                      ),
                    ),
                  ),
                )
              : Container(),
          card2 != null
              ? TweenAnimationBuilder(
                  tween: Tween<Offset>(
                    begin: Offset(dx2, dy2),
                    end: Offset(dx2End, dy2End),
                  ),
                  onEnd: () {
                    setState(() {
                      if ((dx1 != dx1End) && (dx1End.abs() - dx1b.abs() < 1)) {
                        counter++;
                        card1 = cards[counter];
                        card2 = cards[counter + 1];
                        card3 = cards[counter + 2];
                        init();
                      }
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
                        child: card2,
                      ),
                    ),
                  ),
                  builder: (context, Offset offsetAnimated, Widget card) {
                    return Transform.translate(
                      child: card,
                      offset: offsetAnimated,
                    );
                  },
                )
              : Container(),
          card1 != null
              ? GestureDetector(
                onDoubleTap: onDoubleTap,
                  onHorizontalDragStart: (DragStartDetails details) {
                    setState(() {
                      dx1 = details.globalPosition.dx - widget.screenWidth / 2;
                      dx1End = dx1;
                      if (duration == 1) duration = 200;
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
                      onSwipeRight();
                      setState(() {
                        dx1End = widget.screenWidth + 20;
                      });
                    } else if (details.velocity.pixelsPerSecond.dx <= -1200) {
                      onSwipeLeft();
                      setState(() {
                        dx1End = -widget.screenWidth - 20;
                      });
                    } else {
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
                          child: card1,
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
                )
              : Container(),
        ],
      ),
    );
  }
}

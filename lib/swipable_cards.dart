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
    this.onSwipedRightAppear,
    this.onSwipedLeftAppear,
    this.borderColor,
  }) : super(key: key);
  final double screenHeight, screenWidth;
  final int itemCount;
  final List<Widget> children;
  final Function onSwipeLeft;
  final Function onSwipeRight;
  final Function onDoubleTap;
  final Widget onSwipedLeftAppear, onSwipedRightAppear;
  final Color borderColor;

  @override
  _SwipeCardsState createState() => _SwipeCardsState();
}

class _SwipeCardsState extends State<SwipeCards> {
  double screenHeight, screenWidth;
  double dx1, dx1b, dy1, dx1End, dy1End, heightCard1, widthCard1;
  double dx2, dy2, dx2End, dy2End;
  double dx3, dy3;
  double heightCard2, widthCard2, heightCard2End, widthCard2End;
  Color thirdCardColor;
  int duration;
  int itemCount;
  Widget card1, card2, card3, onSwipedLeftAppear, onSwipedRightAppear;
  double swipedCardLeftOpacity, swipedCardRightOpacity;
  List<Widget> cards;
  int counter;
  Function onSwipeLeft, onSwipeRight, onDoubleTap;
  Color borderColor;
  @override
  void initState() {
    super.initState();
    onSwipedLeftAppear = widget.onSwipedLeftAppear;
    onSwipedRightAppear = widget.onSwipedRightAppear;
    screenHeight = widget.screenHeight;
    screenWidth = widget.screenWidth;
    itemCount = widget.itemCount;
    counter = 0;
    onSwipeLeft = widget.onSwipeLeft;
    onSwipeRight = widget.onSwipeRight;
    onDoubleTap = widget.onDoubleTap;
    borderColor =
        widget.borderColor != null ? widget.borderColor : Colors.transparent;
    initCards();
    init();
  }

  void init() {
    dx1 = ((widget.screenWidth * .9) * .05) / 2;
    dy1 = ((widget.screenHeight * .7) * .25);
    swipedCardLeftOpacity = 0;
    swipedCardRightOpacity = 0;
    dx1b = dx1;
    dx1End = dx1;
    dy1End = dy1;
    heightCard1 = (widget.screenHeight * .7) * .75;
    widthCard1 = (widget.screenWidth * .9) * .95;
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
    if (screenHeight != widget.screenHeight)
      setState(() {
        print("initiated");
        screenHeight = widget.screenHeight;
        screenWidth = widget.screenWidth;
        init();
      });
    initCards();
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
                        height: heightCard2,
                        width: widthCard2,
                        child: card3,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: thirdCardColor,
                          border: Border.all(
                            width: 1.5,
                            color: borderColor,
                          ),
                        ),
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
                        child: card2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.white38,
                          border: Border.all(
                            width: 1.5,
                            color: borderColor,
                          ),
                        ),
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
              ? TweenAnimationBuilder(
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
                      if (dx1End == screenWidth)
                        onSwipeRight();
                      else if (dx1End == -screenWidth) onSwipeLeft();
                    });
                  },
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(width: 2, color: borderColor),
                        ),
                        height: heightCard1,
                        width: widthCard1,
                        child: Stack(
                          children: <Widget>[
                            card1,
                            onSwipedLeftAppear != null
                                ? AnimatedContainer(
                                    duration: Duration(milliseconds: duration),
                                    child: Opacity(
                                      child: onSwipedLeftAppear,
                                      opacity: swipedCardLeftOpacity,
                                    ),
                                  )
                                : Container(),
                            onSwipedRightAppear != null
                                ? AnimatedContainer(
                                    duration: Duration(milliseconds: duration),
                                    child: Opacity(
                                      child: onSwipedRightAppear,
                                      opacity: swipedCardRightOpacity,
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  builder: (context, double dx1a, card) {
                    dx1b = dx1a;
                    return Transform.translate(
                      offset: Offset(dx1b, dy1),
                      child: GestureDetector(
                        onDoubleTap: onDoubleTap,
                        onHorizontalDragStart: (DragStartDetails details) {
                          setState(() {
                            dx1 = details.globalPosition.dx -
                                widget.screenWidth / 2;
                            dx1End = dx1;
                            if (dx1 > 0) {
                              if (dx1 < screenWidth / 2)
                                swipedCardRightOpacity = dx1 / screenWidth;
                              else
                                swipedCardRightOpacity = 1;
                              swipedCardLeftOpacity = 0;
                            } else if (dx1 < 0) {
                              if (dx1.abs() < screenWidth / 2)
                                swipedCardLeftOpacity = dx1.abs() / screenWidth;
                              else
                                swipedCardLeftOpacity = 1;
                              swipedCardRightOpacity = 0;
                            } else {
                              swipedCardLeftOpacity = 0;
                              swipedCardRightOpacity = 0;
                            }
                            if (duration == 0) duration = 200;
                          });
                        },
                        onHorizontalDragUpdate: (DragUpdateDetails details) {
                          setState(() {
                            dx1 = details.globalPosition.dx -
                                widget.screenWidth / 2;
                            dx1End = dx1;
                            if (dx1 > 0) {
                              if (dx1 < screenWidth / 2)
                                swipedCardRightOpacity = dx1 / screenWidth;
                              else
                                swipedCardRightOpacity = 1;
                              swipedCardLeftOpacity = 0;
                            } else if (dx1 < 0) {
                              if (dx1.abs() < screenWidth / 2)
                                swipedCardLeftOpacity = dx1.abs() / screenWidth;
                              else
                                swipedCardLeftOpacity = 1;
                              swipedCardRightOpacity = 0;
                            } else {
                              swipedCardLeftOpacity = 0;
                              swipedCardRightOpacity = 0;
                            }
                          });
                        },
                        onHorizontalDragEnd: (DragEndDetails details) {
                          if (details.velocity.pixelsPerSecond.dx >= 1200) {
                            setState(() {
                              dx1End = widget.screenWidth;
                              dx1 = ((widget.screenWidth * .9) * .05) / 2;
                              swipedCardRightOpacity = 1;
                              swipedCardLeftOpacity = 0;
                            });
                          } else if (details.velocity.pixelsPerSecond.dx <=
                              -1200) {
                            setState(() {
                              dx1End = -widget.screenWidth;
                              dx1 = ((widget.screenWidth * .9) * .05) / 2;
                              swipedCardLeftOpacity = 1;
                              swipedCardRightOpacity = 0;
                            });
                          } else {
                            setState(() {
                              dx1 = ((widget.screenWidth * .9) * .05) / 2;
                              dx1End = dx1;
                              swipedCardLeftOpacity = 0;
                              swipedCardRightOpacity = 0;
                            });
                          }
                        },
                        child: Stack(
                          children: <Widget>[
                            card,
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(),
        ],
      ),
    );
  }

  void initCards() {
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
  }
}

import 'dart:async';

import 'package:digital_clock/clock_dial_painter.dart';
import 'package:digital_clock/flip_panel.dart';
import 'package:digital_clock/hand_second.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
  pointerCanvas,
  dayStartBackground,
  dayEndBackground,
  canvasStartBackground,
  canvasEndBackground,
}

final _lightTheme = {
  _Element.background: Colors.black12,
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
  _Element.pointerCanvas: Colors.red,
  _Element.dayStartBackground: Colors.orange,
  _Element.dayEndBackground: Colors.black,
};
final _darkTheme = {
  _Element.background: Colors.transparent,
  _Element.text: Colors.white,
  _Element.shadow: Colors.white,
  _Element.pointerCanvas: Colors.red,
  _Element.dayStartBackground: Colors.black,
  _Element.dayEndBackground: Colors.orange,
  _Element.canvasStartBackground: Colors.black87,
  _Element.canvasEndBackground: Colors.orange,
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock>
    with TickerProviderStateMixin {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
//  Animation<Offset> animation;
//  AnimationController animationController;
  Animation<double> animation;
  AnimationController controller;
  AnimationController _controller;
  List<Map<dynamic, String>> _categories = [
    {'icon': "images/cloudy.gif"},
    {'icon': "images/foggy.gif"},
    {'icon': "images/rainy.gif"},
    {'icon': "images/snowy.gif"},
    {'icon': "images/sunny.gif"},
    {'icon': "images/stormy.gif"},
    {'icon': "images/windy.gif"},
  ];

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _controller = AnimationController(
      duration: const Duration(minutes: 1),
      vsync: this,
    )
      ..repeat();
    super.initState();
//    animationController =
//        AnimationController(vsync: this, duration: Duration(seconds: 5));
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(
          () {
        _dateTime = DateTime.now();
        controller.forward(from: 0);
        _timer = Timer(
          Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
          _updateTime,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var hour = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 2.0)
        .chain(CurveTween(curve: Curves.linear))
        .animate(controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        }
      });
    final colors = Theme
        .of(context)
        .brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final fontSize = MediaQuery
        .of(context)
        .size
        .width / 3.5;
    Animatable<Color> background = TweenSequence<Color>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: colors[_Element.dayStartBackground],
            end: colors[_Element.dayEndBackground],
          ),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: colors[_Element.dayEndBackground],
            end: colors[_Element.dayStartBackground],
          ),
        ),
      ],
    );

    final defaultStyle = TextStyle(
      backgroundColor: background
          .chain(
        CurveTween(curve: Curves.linear),
      )
          .evaluate(
        AlwaysStoppedAnimation(_controller.value),
      ),
      fontFamily: 'Rock Salt',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 3,
          color: colors[_Element.shadow],
          offset: Offset(3, 0),
        ),
      ],
    );
    return AnimatedBuilder(
        animation: _controller, builder: (context, child) {
      return Scaffold(
        backgroundColor: background
            .chain(
          CurveTween(curve: Curves.easeInOutCirc),
        )
            .evaluate(
          AlwaysStoppedAnimation(_controller.value),
        ),
        body: Center(
          child: DefaultTextStyle(
            style: defaultStyle,
            child: new AspectRatio(
              aspectRatio: 1.0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Scaffold(
                    backgroundColor: background
                        .chain(
                      CurveTween(curve: Curves.easeInOutCirc),
                    )
                        .evaluate(
                      AlwaysStoppedAnimation(_controller.value),
                    ),
                    body: new Stack(
                      children: <Widget>[
                        Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
//                          color: colors[_Element.shadow],
                                color: background
                                    .chain(
                                  CurveTween(curve: Curves.linear),
                                )
                                    .evaluate(
                                  AlwaysStoppedAnimation(_controller.value),
                                ),

                                blurRadius: 250.0,
                                spreadRadius: 1,
                              ),
                              BoxShadow(
//                            color: colors[_Element.pointerCanvas],
                                color: background
                                    .chain(
                                  CurveTween(curve: Curves.linear),
                                )
                                    .evaluate(
                                  AlwaysStoppedAnimation(_controller.value),
                                ),
                                blurRadius: 50.0,
                                spreadRadius: 10,
                              ),
                              BoxShadow(
                                color: colors[_Element.text],
                                blurRadius: 10.0,
                                spreadRadius: 1,
                              )
                            ],
                            color: background
                                .chain(
                              CurveTween(curve: Curves.linear),
                            )
                                .evaluate(
                              AlwaysStoppedAnimation(_controller.value),
                            ),
                          ),
                          width: double.infinity,
                          height: double.infinity,
                          padding: const EdgeInsets.all(10.0),
                          child: new CustomPaint(
                            painter: new ClockDialPainter(
                              colors[_Element.text],
                            ),
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1.0,
                          child: new Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20.0),
                            child: new Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                new CustomPaint(
                                  painter: new SecondHandPainter(
                                    secondHandPaintColor:
                                    colors[_Element.pointerCanvas],
                                    secondHandPointsPaintColor:
                                    colors[_Element.pointerCanvas],
                                    seconds: _dateTime.second,
                                  ),
                                ),
                                Center(
                                  child: SizedBox(
                                    height: 160,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                                  hour,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 36.0,
                                                      color: Colors.white),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                              ),
                                              width: 18 / 3,
                                              height: 45,
                                              alignment: Alignment.center,
                                              child: Text(
                                                ":",
                                                style: TextStyle(
                                                  fontSize: 36,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            FlipClock.simple(
                                              backgroundColor: Colors.transparent,
                                              startTime: _dateTime,
                                              width: 20,
                                              digitColor: colors[_Element.text],
                                              flipDirection: FlipDirection.down,
                                              digitSize: 36.0,
                                            ),
                                          ],
                                        ),

//                                      FlipClock(digitBuilder: null, separator: null, startTime: _dateTime),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0, bottom: 15),
                                          child: new Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: <Widget>[
                                              AnimatedBuilder(
                                                animation: offsetAnimation,
                                                builder: (buildContext, child) {
                                                  return Container(
                                                    margin: EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5.0),
                                                    padding: EdgeInsets.only(
                                                        left:
                                                        offsetAnimation.value +
                                                            2.0,
                                                        right: 2.0 -
                                                            offsetAnimation
                                                                .value),
                                                    child: Center(
                                                      child: Container(
                                                        alignment: Alignment
                                                            .center,
//                                                        child: Icon(
//                                                          _categories[widget
//                                                              .model
//                                                              .weatherCondition
//                                                              .index]['icon'],
//                                                          color:
//                                                          colors[_Element.text],
//                                                          size: 40.0,
//                                                        ),
                                                        child: Tab(
                                                          icon: new Image
                                                              .asset(
                                                            _categories[widget
                                                                .model
                                                                .weatherCondition
                                                                .index]['icon'],
                                                            color:Colors.white,
                                                            height: 40,
                                                            width: 40,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    widget.model
                                                        .temperatureString,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color: colors[_Element
                                                          .text],
                                                      fontWeight: FontWeight
                                                          .bold,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                   children: <Widget>[
                                                     Text(
                                                    widget.model.weatherString,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: colors[_Element
                                                          .text],
                                                      fontWeight: FontWeight
                                                          .bold,
                                                    ),
                                                  ),
                                                     Text(
                                                    '(' + widget.model.lowString + " ~ " + widget.model.highString + ')',
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: colors[_Element
                                                          .text],
                                                      fontWeight: FontWeight
                                                          .bold,
                                                    ),
                                                  ),
                                                   ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          DateFormat('EEEEE, MMMM dd')
                                              .format(_dateTime)
                                              .toUpperCase(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colors[_Element.text],
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 25.0),
                                          child: Text(
                                            '${widget.model.location}',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: colors[_Element.text],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}

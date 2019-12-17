import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';
import 'package:sanket_clock/clock_dial_canvas.dart';
import 'package:sanket_clock/flip_panel.dart';
import 'package:sanket_clock/hand_second.dart';

enum _Substance {
  background,
  text,
  shadow,
  pointerCanvas,
  dayStartBackground,
  dayEndBackground,
}

final _lightTheme = {
  _Substance.background: Colors.black12,
  _Substance.text: Colors.white,
  _Substance.shadow: Colors.black38,
  _Substance.pointerCanvas: Colors.red,
  _Substance.dayStartBackground: Colors.orange,
  _Substance.dayEndBackground: Colors.black,
};
final _darkTheme = {
  _Substance.background: Colors.transparent,
  _Substance.text: Colors.white,
  _Substance.shadow: Colors.black38,
  _Substance.pointerCanvas: Colors.red,
  _Substance.dayStartBackground: Colors.black,
  _Substance.dayEndBackground: Colors.orange,
};

class SanketClock extends StatefulWidget {
  const SanketClock(this.clockModel);

  final ClockModel clockModel;

  @override
  _SanketClockState createState() => _SanketClockState();
}

class _SanketClockState extends State<SanketClock>
    with TickerProviderStateMixin {
  DateTime _currentDateTime = DateTime.now();
  Timer _timer;

  Animation<double> animation;
  AnimationController timeUpdateController;
  AnimationController bgUpdateController;
  List<Map<dynamic, String>> _currentWeatherConditions = [
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
    timeUpdateController = AnimationController(
        duration: const Duration(milliseconds: 700), vsync: this);
    bgUpdateController = AnimationController(
      value: _currentDateTime.hour / 24,
      upperBound: 1,
      lowerBound: 0,
      duration: const Duration(hours: 24),
      vsync: this,
    )..repeat();
    super.initState();
    widget.clockModel.addListener(_updateCurrentModel);
    _updateCurrentTime();
    _updateCurrentModel();
  }

  @override
  void didUpdateWidget(SanketClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.clockModel != oldWidget.clockModel) {
      oldWidget.clockModel.removeListener(_updateCurrentModel);
      widget.clockModel.addListener(_updateCurrentModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.clockModel.removeListener(_updateCurrentModel);
    widget.clockModel.dispose();
    timeUpdateController.dispose();
    bgUpdateController.dispose();
    animation.removeListener(null);
    super.dispose();
  }

  void _updateCurrentModel() {
    setState(() {});
  }

  void _updateCurrentTime() {
    setState(
      () {
        _currentDateTime = DateTime.now();
        timeUpdateController.forward(from: 0);
        _timer = Timer(
          Duration(seconds: 1),
          _updateCurrentTime,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateFormat(widget.clockModel.is24HourFormat ? 'HH' : 'hh')
        .format(_currentDateTime);
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 2.0)
        .chain(CurveTween(curve: Curves.linear))
        .animate(timeUpdateController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              timeUpdateController.reverse();
            }
          });
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    Animatable<Color> background = TweenSequence<Color>(
      [
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: colors[_Substance.dayEndBackground],
            end: colors[_Substance.dayStartBackground],
          ),
        ),
        TweenSequenceItem(
          weight: 1.0,
          tween: ColorTween(
            begin: colors[_Substance.dayStartBackground],
            end: colors[_Substance.dayEndBackground],
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
            AlwaysStoppedAnimation(bgUpdateController.value),
          ),
      fontFamily: 'Rock Salt',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 3,
          color: colors[_Substance.shadow],
          offset: Offset(2, 0),
        ),
      ],
    );
    return AnimatedBuilder(
      animation: bgUpdateController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: background
              .chain(
                CurveTween(curve: Curves.easeInOutCirc),
              )
              .evaluate(
                AlwaysStoppedAnimation(bgUpdateController.value),
              ),
          body: Center(
            child: DefaultTextStyle(
              style: defaultStyle,
              child: new AspectRatio(
                aspectRatio: 1.0,
                child: AnimatedBuilder(
                  animation: bgUpdateController,
                  builder: (context, child) {
                    return new Stack(
                      children: <Widget>[
                        Transform.rotate(
                          angle: _currentDateTime.second.toDouble(),
                          child: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              color: background
                                  .chain(
                                    CurveTween(curve: Curves.linear),
                                  )
                                  .evaluate(
                                    AlwaysStoppedAnimation(
                                        bgUpdateController.value),
                                  ),
                              boxShadow: [
                                BoxShadow(
                                  color: background
                                      .chain(
                                        CurveTween(curve: Curves.easeInOutCirc),
                                      )
                                      .evaluate(
                                        AlwaysStoppedAnimation(
                                            bgUpdateController.value),
                                      ),
                                  blurRadius: 6.0,
                                  spreadRadius: 2.5,
                                  offset: Offset(
                                    0.0,
                                    3.0,
                                  ),
                                ),
                                BoxShadow(
                                  color: background
                                      .chain(
                                        CurveTween(curve: Curves.linear),
                                      )
                                      .evaluate(
                                        AlwaysStoppedAnimation(
                                            bgUpdateController.value),
                                      ),
                                  blurRadius: 250.0,
                                  spreadRadius: 1,
                                ),
                                BoxShadow(
                                  color: background
                                      .chain(
                                        CurveTween(curve: Curves.linear),
                                      )
                                      .evaluate(
                                        AlwaysStoppedAnimation(
                                            bgUpdateController.value),
                                      ),
                                  blurRadius: 50.0,
                                  spreadRadius: 10,
                                ),
                                BoxShadow(
                                  color: colors[_Substance.text],
                                  blurRadius: 10.0,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                            width: double.infinity,
                            height: double.infinity,
                            padding: const EdgeInsets.all(10.0),
                            child: Transform.rotate(
                              angle: -_currentDateTime.second.toDouble(),
                              child: new CustomPaint(
                                painter: new ClockDialCanvas(
                                  colors[_Substance.text],
                                ),
                              ),
                            ),
                          ),
                        ),
                        AspectRatio(
                          aspectRatio: 1.0,
                          child: ClipOval(
                            child: new Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20.0),
                              child: new Stack(
                                fit: StackFit.expand,
                                children: <Widget>[
                                  new CustomPaint(
                                    painter: new SecondHandPainter(
                                      secondHandPaintColor:
                                          colors[_Substance.pointerCanvas],
                                      secondHandPointsPaintColor:
                                          colors[_Substance.pointerCanvas],
                                      seconds: _currentDateTime.second,
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
                                                width: 15,
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
                                                backgroundColor:
                                                    Colors.transparent,
                                                startTime: _currentDateTime,
                                                width: 27,
                                                digitColor:
                                                    colors[_Substance.text],
                                                flipDirection:
                                                    FlipDirection.down,
                                                digitSize: 36.0,
                                              ),
                                            ],
                                          ),
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
                                                  builder:
                                                      (buildContext, child) {
                                                    return Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.0),
                                                      padding: EdgeInsets.only(
                                                          left: offsetAnimation
                                                                  .value +
                                                              2.0,
                                                          right: 2.0 -
                                                              offsetAnimation
                                                                  .value),
                                                      child: Center(
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Tab(
                                                            icon:
                                                                new Image.asset(
                                                              _currentWeatherConditions[widget
                                                                  .clockModel
                                                                  .weatherCondition
                                                                  .index]['icon'],
                                                              color:
                                                                  Colors.white,
                                                              height: 35,
                                                              width: 35,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      widget.clockModel
                                                          .temperatureString,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        color: colors[
                                                            _Substance.text],
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          widget.clockModel
                                                              .weatherString,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: colors[
                                                                _Substance
                                                                    .text],
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          '(' +
                                                              widget.clockModel
                                                                  .lowString +
                                                              " ~ " +
                                                              widget.clockModel
                                                                  .highString +
                                                              ')',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 10,
                                                            color: colors[
                                                                _Substance
                                                                    .text],
                                                            fontWeight:
                                                                FontWeight.bold,
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
                                                .format(_currentDateTime)
                                                .toUpperCase(),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: colors[_Substance.text],
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 25.0),
                                            child: Text(
                                              '${widget.clockModel.location}',
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: colors[_Substance.text],
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
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

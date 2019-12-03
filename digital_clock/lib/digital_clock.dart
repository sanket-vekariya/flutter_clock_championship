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
  backgroundCanvas,
  pointerCanvas,
}

final _lightTheme = {
  _Element.background: Colors.black12,
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
  _Element.pointerCanvas: Colors.black,
  _Element.backgroundCanvas: Colors.white,
};

final _darkTheme = {
  _Element.background: Colors.transparent,
  _Element.text: Colors.white,
  _Element.shadow: Colors.lightBlueAccent,
  _Element.pointerCanvas: Colors.orangeAccent,
  _Element.backgroundCanvas: Colors.white,
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  double temp;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    temp = ClockModel().temperature;
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
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(
      () {
        _dateTime = DateTime.now();
        _timer = Timer(
          Duration(seconds: 1),
          _updateTime,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final fontSize = MediaQuery.of(context).size.width / 3.5;
    final defaultStyle = TextStyle(
      color: colors[_Element.backgroundCanvas],
      backgroundColor: Colors.transparent,
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
    return Container(
      alignment: Alignment.center,
      color: colors[_Element.background],
      child: DefaultTextStyle(
        style: defaultStyle,
        child: new Padding(
          padding: const EdgeInsets.all(1.0),
          child: new AspectRatio(
            aspectRatio: 1.0,
            child: new Container(
              width: double.infinity,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: colors[_Element.background],
              ),
              child: new Stack(
                children: <Widget>[
                  new Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: const EdgeInsets.all(10.0),
                    child: new CustomPaint(
                      painter: new ClockDialPainter(
                          colors[_Element.backgroundCanvas]),
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
                              height: 125, //53 each widget
                              child: Column(
                                children: <Widget>[
                                  FlipClock.simple(
                                    backgroundColor: Colors.transparent,
                                    startTime: _dateTime,
                                    digitColor: colors[_Element.text],
                                    flipDirection: FlipDirection.down,
                                    digitSize: 32.0,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  new Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      new Expanded(
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.only(
                                              right: 35.0),
                                          child: Icon(
                                            Icons.cloud,
                                            color: colors[_Element.text],
                                            size: 40.0,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              '${ClockModel().location}',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                shadows: <Shadow>[
                                                  Shadow(
                                                    offset: Offset(1, 0),
                                                    blurRadius: 2,
                                                    color: colors[_Element.text],
                                                  ),
                                                  Shadow(
                                                    blurRadius: 2,
                                                    color: colors[_Element.shadow],
                                                    offset: Offset(3, 0),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Text(
                                              DateFormat('EEEEE, MMMM dd')
                                                  .format(_dateTime)
                                                  .toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                shadows: <Shadow>[
                                                  Shadow(
                                                    offset: Offset(1, 0),
                                                    blurRadius: 2,
                                                    color: colors[_Element.text],
                                                  ),
                                                  Shadow(
                                                    blurRadius: 2,
                                                    color: colors[_Element.shadow],
                                                    offset: Offset(3, 0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        ClockModel().temperature.toString() +ClockModel().unitString,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          shadows: <Shadow>[
                                            Shadow(
                                              offset: Offset(1, 0),
                                              blurRadius: 2,
                                              color: colors[_Element.text],
                                            ),
                                            Shadow(
                                              blurRadius: 2,
                                              color: colors[_Element.shadow],
                                              offset: Offset(3, 0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
            ),
          ),
        ),
      ),
    );
  }
}

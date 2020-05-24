import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/models/timer_detail_model.dart';
import 'package:sportstimer/models/workout_time_model.dart';
import 'package:sportstimer/providers/workout_time_provider.dart';
import 'package:sportstimer/utils/number_picker_formatter.dart';

class TimerScreen extends StatefulWidget {
  static String route = '/TimerScreen';

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  TimerDetailModel timerDetailModel;

  int _numberOfSets;
  bool isWorkMode = true;
  String id;
  bool isWorkoutFinished = false;

  Future<void> _startAnimation() async {
    try {
      while (_numberOfSets > 0) {
        if (isWorkMode) {
          _controller.duration = Duration(seconds: _workTime);
        } else {
          _controller.duration = Duration(seconds: _restTime);
        }

        if (!(_numberOfSets == 1 && !isWorkMode)) {
          await _controller
              .reverse(from: _controller.value == 0.0 ? 1.0 : _controller.value)
              .orCancel;
        }
        setState(() {
          /// decrease number of sets after rest period
          if (!isWorkMode) {
            _numberOfSets -= 1;
          }
          isWorkMode = !isWorkMode;

          ///if workout is finished
          if (_numberOfSets == 0) {
            workoutFinished();
          }
        });
      }
    } catch (error) {
      print("error");
    }
  }

  void workoutFinished() {
    WorkoutTimeModel workout = WorkoutTimeModel(
      id: id,
      workDuration: (_workTime* int.parse(timerDetailModel.sets)).toString(),
      date:  new DateFormat('yyyy-MM-dd').format(DateTime.now()),
    );

    Provider.of<WorkoutProvider>(context, listen: false)
        .addWorkoutDetail(workout);

    setState(() {
      isWorkoutFinished = !isWorkoutFinished;
    });
  }

  void _pauseAnimation() {
    _controller.stop(canceled: true);
  }

  @override
  void didChangeDependencies() {
    timerDetailModel =
        ModalRoute.of(context).settings.arguments as TimerDetailModel;
    if (timerDetailModel == null) {
      return;
    }

    id = timerDetailModel.id;
    _numberOfSets = int.parse(timerDetailModel.sets);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _workTime),
    );

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  String get timerString {
    Duration duration = _controller.duration * _controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  int get _workTime {
    return NumberPickerFormatter.extractNumberPickerTime(
        "work", timerDetailModel);
  }

  int get _restTime {
    return NumberPickerFormatter.extractNumberPickerTime(
        "rest", timerDetailModel);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: isWorkoutFinished
            ? Column(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Text(_numberOfSets == 1
                        ? 'Last Set'
                        : 'Remaining Sets: $_numberOfSets'),
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.center,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: AnimatedBuilder(
                                animation: _controller,
                                builder: (BuildContext context, Widget child) {
                                  return CustomPaint(
                                      painter: TimerPainter(
                                    animation: _controller,
                                    backgroundColor: Colors.white,
                                    color: themeData.indicatorColor,
                                  ));
                                },
                              ),
                            ),
                            Align(
                              alignment: FractionalOffset.center,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    isWorkMode ? 'Work' : 'Rest',
                                    style: themeData.textTheme.subtitle1,
                                  ),
                                  AnimatedBuilder(
                                      animation: _controller,
                                      builder:
                                          (BuildContext context, Widget child) {
                                        return Text(
                                          timerString,
                                          style: themeData.textTheme.display4,
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FloatingActionButton(
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (BuildContext context, Widget child) {
                              return Icon(_controller.isAnimating
                                  ? Icons.pause
                                  : Icons.play_arrow);
                            },
                          ),
                          onPressed: () {
                            _controller.isAnimating
                                ? _pauseAnimation()
                                : _startAnimation();
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  TimerPainter({
    this.animation,
    this.backgroundColor,
    this.color,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        backgroundColor != old.backgroundColor;
  }
}

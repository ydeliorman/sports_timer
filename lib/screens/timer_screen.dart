import 'dart:math' as math;

import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  static String route = '/TimerScreen';

  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  Map<String, String> _timerData = {
    'sets': '',
    'work': '',
    'rest': '',
  };

  int _numberOfSets;
  bool isWorkMode = true;

  @override
  void didChangeDependencies() {
    _timerData =
        ModalRoute.of(context).settings.arguments as Map<String, String>;
    if (_timerData == null) {
      return;
    }

    _numberOfSets = int.parse(_timerData['sets']);

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _workTime),
    )..addStatusListener((AnimationStatus status) {
        if (_numberOfSets > 0 && status == AnimationStatus.dismissed) {
          if (controller.isAnimating) {
            controller.stop(canceled: true);
          } else if(status == AnimationStatus.dismissed){
//            controller.duration = Duration(milliseconds: _restTime);
            controller.reverse(
                from: controller.value == 0.0 ? 1.0 : controller.value);
          }
        }
        if (_numberOfSets > 0 && status == AnimationStatus.completed) {
          setState(() {
            _numberOfSets--;
          });
        }
      });

    super.didChangeDependencies();
  }

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  int get _workTime {
    return _extractNumberPickerTime("work");
  }

  int get _restTime {
    return _extractNumberPickerTime("rest");
  }

  int _extractNumberPickerTime(String numberPickerType) {
    int workDurationDecimalPart;

    ///if the number is 0 18 -> workDurationInDecimal will be 0.18
    var workDurationInDecimal = double.parse(_timerData[numberPickerType]);
    int workDurationIntPart = workDurationInDecimal.toInt();

    ///if the decimal part is divided by 10(length == 1), multiply by then the extracted decimal part
    if (workDurationInDecimal.toString().split('.')[1].length == 1) {
      workDurationDecimalPart =
          int.tryParse(workDurationInDecimal.toString().split('.')[1]) * 10;
    } else if (workDurationInDecimal.toString().split('.')[1].length == 2) {
      workDurationDecimalPart =
          int.tryParse(workDurationInDecimal.toString().split('.')[1]);
    }

    return 60 * workDurationIntPart + workDurationDecimalPart;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              ///todo yed place remaining sets in a better place
              child: Text(_numberOfSets == 0
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
                          animation: controller,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                                painter: TimerPainter(
                              animation: controller,
                              backgroundColor: Colors.white,
                              color: themeData.indicatorColor,
                            ));
                          },
                        ),
                      ),
                      Align(
                        alignment: FractionalOffset.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              isWorkMode ? 'Work' : 'Rest',
                              style: themeData.textTheme.subhead,
                            ),
                            AnimatedBuilder(
                                animation: controller,
                                builder: (BuildContext context, Widget child) {
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
                      animation: controller,
                      builder: (BuildContext context, Widget child) {
                        return Icon(controller.isAnimating
                            ? Icons.pause
                            : Icons.play_arrow);
                      },
                    ),
                    onPressed: () {
                      if (controller.isAnimating) {
                        controller.stop(canceled: true);
                      } else {
                        controller.reverse(
                            from: controller.value == 0.0
                                ? 1.0
                                : controller.value);
                      }
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

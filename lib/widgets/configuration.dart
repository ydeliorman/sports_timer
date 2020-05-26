import 'package:flutter/material.dart';
import 'package:sportstimer/models/timer_detail_model.dart';
import 'package:sportstimer/screens/start_screen.dart';

class Configuration extends StatefulWidget {
  PageController pageController;
  List<TimerDetailModel> timerDetails = [];
  StartScreenState parent;
  final Function toggleOff;

  Configuration({
    @required this.pageController,
    @required this.timerDetails,
    @required this.parent,
    @required this.toggleOff,
  });

  @override
  _ConfigurationState createState() => _ConfigurationState();
}

class _ConfigurationState extends State<Configuration> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Container(
          child: PageView(
            controller: widget.pageController,
            children: <Widget>[
              Text(
                "Configuration 1/3",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: constraints.maxWidth * 0.1),
              ),
              Text(
                "Configuration 2/3",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: constraints.maxWidth * 0.1),
              ),
              Text(
                "Configuration 3/3",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: constraints.maxWidth * 0.1),
              ),
            ],
            onPageChanged: (index) {
              setState(
                () {
                  TimerDetailModel timerDetail = widget.timerDetails
                      .where((timerDetail) => timerDetail.id == "${index + 1}")
                      .first;
                  if (timerDetail == null) timerDetail = widget.timerDetails[index];
                  widget.parent.id = "${index + 1}";
                  widget.parent.sets = timerDetail.sets;
                  widget.parent.work = timerDetail.workDuration;
                  widget.parent.rest = timerDetail.restDuration;
                  widget.parent.collapseNumberPickers();
                },
              );
            },
          ),
        );
      },
    );
  }
}

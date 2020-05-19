import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/models/timer_detail_model.dart';
import 'package:sportstimer/models/workout_time_model.dart';
import 'package:sportstimer/providers/timer_detail_provider.dart';
import 'package:sportstimer/providers/workout_time_provider.dart';
import 'package:sportstimer/screens/timer_screen.dart';
import 'package:sportstimer/utils/number_picker_formatter.dart';
import 'package:sportstimer/widgets/barchart.dart';
import 'package:sportstimer/widgets/custom_calendar.dart';
import 'package:sportstimer/widgets/expanded_section.dart';
import 'package:sportstimer/widgets/start_screen_item.dart';

class StartScreen extends StatefulWidget {
  static String route = '/StartScreen';

  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String id;
  String sets = "3";
  String work = "0.3";
  String rest = "0.05";
  List<TimerDetailModel> timerDetails = [];
  bool _isExpandedSets = false;
  bool _isExpandedWork = false;
  bool _isExpandedRest = false;
  PageController _pageController = PageController();

  ///Expande or collapes while clicking between rest, work or sets
  void _toggleExpand(int expandedItem) {
    setState(() {
      if (expandedItem == 1) {
        _isExpandedSets = !_isExpandedSets;
        if (_isExpandedWork) _isExpandedWork = !_isExpandedWork;
        if (_isExpandedRest) _isExpandedRest = !_isExpandedRest;
      } else if (expandedItem == 2) {
        _isExpandedWork = !_isExpandedWork;
        if (_isExpandedSets) _isExpandedSets = !_isExpandedSets;
        if (_isExpandedRest) _isExpandedRest = !_isExpandedRest;
      } else {
        _isExpandedRest = !_isExpandedRest;
        if (_isExpandedSets) _isExpandedSets = !_isExpandedSets;
        if (_isExpandedWork) _isExpandedWork = !_isExpandedWork;
      }
    });
  }

  ///collapse all number pickers
  void toggleOff() {
    setState(() {
      _isExpandedSets = false;
      _isExpandedWork = false;
      _isExpandedRest = false;
    });
  }

  void _startWorkout(String id) {
    _formKey.currentState.save();

    TimerDetailModel timerDetailModel = TimerDetailModel(
      id: id,
      sets: sets,
      restDuration: rest,
      workDuration: work,
    );

    Navigator.of(context)
        .pushNamed(TimerScreen.route, arguments: timerDetailModel);

    ///remove the current modified one for update
    Provider.of<TimerProvider>(context, listen: false).removeTimerDetail(id);

    ///add the modified one
    Provider.of<TimerProvider>(context, listen: false)
        .addTimerDetail(timerDetailModel);

    _pageController.jumpToPage(0);
  }

  ///fetchSaved data from shared preferences at starting
  void fetchSavedData() {
    timerDetails =
        Provider.of<TimerProvider>(context, listen: true).timerDetails;
    if (timerDetails.length > 0) {
      sets = timerDetails[0].sets;
      work = timerDetails[0].workDuration;
      rest = timerDetails[0].restDuration;
    }
  }

  ///adding timerDetail function
  void addTimerDetail() {
    int i = 1;
    TimerDetailModel timerDetailModel = TimerDetailModel(
      id: "Configuration $i/3",
      sets: sets,
      restDuration: rest,
      workDuration: work,
    );

    i++;
    Provider.of<TimerProvider>(context, listen: false)
        .addTimerDetail(timerDetailModel);
  }

  @override
  void didChangeDependencies() {
    fetchSavedData();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CustomCalendar(
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: PageView(
                      controller: _pageController,
                      children: <Widget>[
                        Text(
                          "Configuration 1/3",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        ),
                        Text("Configuration 2/3",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 25)),
                        Text(
                          "Configuration 3/3",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                      onPageChanged: (index) {
                        setState(
                          () {
                            TimerDetailModel timerDetail = timerDetails
                                .where((timerDetail) =>
                                    timerDetail.id == "${index + 1}")
                                .first;
                            if (timerDetail == null)
                              timerDetail = timerDetails[index];
                            id = "${index + 1}";
                            sets = timerDetail.sets;
                            work = timerDetail.workDuration;
                            rest = timerDetail.restDuration;
                            toggleOff();
                          },
                        );
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _toggleExpand(1);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Sets',
                          style: TextStyle(fontSize: 25),
                        ),
                        Spacer(),
                        Text(
                          sets,
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _toggleExpand(2);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Work',
                          style: TextStyle(fontSize: 25),
                        ),
                        Spacer(),
                        Text(
                          NumberPickerFormatter.gatherTimeForRichText(work)[0] +
                              ":" +
                              NumberPickerFormatter.gatherTimeForRichText(
                                  work)[1],
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _toggleExpand(3);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          'Rest',
                          style: TextStyle(fontSize: 25),
                        ),
                        Spacer(),
                        Text(
                          NumberPickerFormatter.gatherTimeForRichText(rest)[0] +
                              ":" +
                              NumberPickerFormatter.gatherTimeForRichText(
                                  rest)[1],
                          style: TextStyle(fontSize: 25),
                        ),
                      ],
                    ),
                  ),
                  ExpandedSection(
                    expand: _isExpandedSets,
                    child: StartScreenItem(
                      "SETS",
                      sets,
                      this,
                    ),
                  ),
                  ExpandedSection(
                    expand: _isExpandedWork,
                    child: StartScreenItem(
                      "WORK",
                      work,
                      this,
                    ),
                  ),
                  ExpandedSection(
                    expand: _isExpandedRest,
                    child: StartScreenItem(
                      "REST",
                      rest,
                      this,
                    ),
                  ),
                  const Divider(),
                  NiceButton(
                    width: 255,
                    elevation: 8.0,
                    radius: 52.0,
                    text: "Start",
                    background: Colors.lightBlue,
                    icon: Icons.accessibility,
                    onPressed: () => _startWorkout(id),
                  ),
                  FloatingActionButton(
                    onPressed: () {
                      WorkoutTimeModel workout = WorkoutTimeModel(
                        id: id,
                        workDuration: '50',
                        date: DateTime.now().toIso8601String(),
                      );

                      Provider.of<WorkoutProvider>(context, listen: false)
                          .addWorkoutDetail(workout);
                    },
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

class Slider extends StatelessWidget {
  final String textName;

  Slider({Key key, @required this.textName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: 50,
        width: double.infinity,
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Text(
          textName,
          style: TextStyle(color: Colors.grey),
        ));
  }
}

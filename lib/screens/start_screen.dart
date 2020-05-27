import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/models/timer_detail_model.dart';
import 'package:sportstimer/providers/timer_detail_provider.dart';
import 'package:sportstimer/screens/timer_screen.dart';
import 'package:sportstimer/utils/appcolors.dart';
import 'package:sportstimer/widgets/configuration.dart';
import 'package:sportstimer/widgets/custom_calendar.dart';
import 'package:sportstimer/widgets/voice_slider.dart';
import 'package:sportstimer/widgets/workout_item.dart';

class StartScreen extends StatefulWidget {
  static String route = '/StartScreen';

  @override
  StartScreenState createState() => StartScreenState();
}

class StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  String id = "1";
  String sets = "3";
  String work = "0.3";
  String rest = "0.05";
  List<TimerDetailModel> timerDetails = [];
  bool _isExpandedSets = false;
  bool _isExpandedWork = false;
  bool _isExpandedRest = false;
  PageController _pageController = PageController();
  double sliderValue = 0;

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
  void collapseNumberPickers() {
    setState(() {
      _isExpandedSets = false;
      _isExpandedWork = false;
      _isExpandedRest = false;
    });
  }

  void _startWorkout(String id) {
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
    Map<String, String> timerData =
        Provider.of<TimerProvider>(context).getTimerData();
    TimerDetailModel timerDetailModel = TimerDetailModel(
      id: "Configuration $i/3",
      sets: timerData["sets"],
      restDuration: timerData["rest"],
      workDuration: timerData["work"],
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
    final mediaQuery = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: white2,

      body: Padding(
        padding: EdgeInsets.all(mediaQuery.height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: CustomCalendar(),
              ),
              Container(
                height: mediaQuery.height * 0.05,
                width: mediaQuery.width * 0.8,
                child: Configuration(
                  parent: this,
                  pageController: _pageController,
                  timerDetails: timerDetails,
                  toggleOff: collapseNumberPickers,
                ),
              ),
              SizedBox(
                height: mediaQuery.height * 0.06,
              ),
              WorkoutItem(
                value: sets,
                name: "SETS",
                toggleExpand: _toggleExpand,
                isExpanded: _isExpandedSets,
                parent: this,
              ),
              SizedBox(
                height: mediaQuery.height * 0.04,
              ),
              WorkoutItem(
                value: work,
                name: "WORK",
                toggleExpand: _toggleExpand,
                isExpanded: _isExpandedWork,
                parent: this,
              ),
              SizedBox(
                height: mediaQuery.height * 0.04,
              ),
              WorkoutItem(
                value: rest,
                name: "REST",
                toggleExpand: _toggleExpand,
                isExpanded: _isExpandedRest,
                parent: this,
              ),
              SizedBox(
                height: mediaQuery.height * 0.04,
              ),
              Container(
                  height: mediaQuery.height * 0.05,
                  width: mediaQuery.width,
                  child: VoiceSlider(sliderValue)),
              const Divider(),
              SizedBox(
                height: mediaQuery.height * 0.15,
              ),
              Container(
                height: mediaQuery.height * 0.1,
                width: mediaQuery.width * 0.7,
                child: NiceButton(
                  elevation: 10.0,
                  radius: 30.0,
                  text: "Start",
                  background: primaryColor,
                  icon: Icons.accessibility,
                  onPressed: () => _startWorkout(id),
                ),
              ),
              SizedBox(
                height: mediaQuery.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

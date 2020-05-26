import 'package:flutter/material.dart';
import 'package:nice_button/nice_button.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/models/timer_detail_model.dart';
import 'package:sportstimer/providers/timer_detail_provider.dart';
import 'package:sportstimer/screens/timer_screen.dart';
import 'package:sportstimer/utils/appcolors.dart';
import 'package:sportstimer/utils/number_picker_formatter.dart';
import 'package:sportstimer/widgets/custom_calendar.dart';
import 'package:sportstimer/widgets/expanded_section.dart';
import 'package:sportstimer/widgets/number_picker.dart';

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
  double _sliderValue = 0;

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
    final mediaQuery = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: white2,
      body: Padding(
        padding: EdgeInsets.all(mediaQuery.height * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CustomCalendar(),
              SizedBox(
                height: mediaQuery.height * 0.05,
              ),
              Container(
                width: double.infinity,
                height: mediaQuery.height * 0.05,
                child: PageView(
                  controller: _pageController,
                  children: <Widget>[
                    Text(
                      "Configuration 1/3",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    ),
                    Text(
                      "Configuration 2/3",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    ),
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
              SizedBox(
                height: mediaQuery.height * 0.04,
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
                      style: TextStyle(fontSize: 25, color: primaryColor),
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
              SizedBox(
                height: mediaQuery.height * 0.04,
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
                          NumberPickerFormatter.gatherTimeForRichText(work)[1],
                      style: TextStyle(fontSize: 25, color: primaryColor),
                    ),
                  ],
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
              SizedBox(
                height: mediaQuery.height * 0.04,
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
                          NumberPickerFormatter.gatherTimeForRichText(rest)[1],
                      style: TextStyle(fontSize: 25, color: primaryColor),
                    ),
                  ],
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
              SizedBox(
                height: mediaQuery.height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Volume',
                    style: TextStyle(fontSize: 25),
                  ),
                  Container(
                    width: mediaQuery.width * 0.7,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.blue[700],
                        inactiveTrackColor: Colors.blue[100],
                        trackShape: RectangularSliderTrackShape(),
                        trackHeight: 4.0,
                        thumbColor: primaryColor,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 12.0),
                        overlayColor: Colors.red.withAlpha(32),
                        overlayShape:
                            RoundSliderOverlayShape(overlayRadius: 28.0),
                      ),
                      child: Slider(
                        value: _sliderValue,
                        onChanged: (value) {
                          setState(() {
                            _sliderValue = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(
                height: mediaQuery.height * 0.15,
              ),
              NiceButton(
                width: mediaQuery.width * 0.7,
                elevation: 10.0,
                radius: 30.0,
                text: "Start",
                background: primaryColor,
                icon: Icons.accessibility,
                onPressed: () => _startWorkout(id),
              ),
              SizedBox(
                height: mediaQuery.height * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


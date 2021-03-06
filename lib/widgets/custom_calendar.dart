import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/models/workout_time_model.dart';
import 'package:sportstimer/providers/workout_time_provider.dart';
import 'package:sportstimer/widgets/barchart.dart';
import 'package:sportstimer/widgets/expanded_section.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendar extends StatefulWidget {
  @override
  _CustomCalendarState createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  CalendarController _calendarController = CalendarController();
  List _selectedEvents;
  Map<DateTime, List> _events;
  List<WorkoutTimeModel> workoutDetails = [];
  DateTime startDayOfWeek;
  DateTime endDayOfWeek;
  bool _isExpanded = false;

  ///fetch data for workout date and work time.put them in events for making them visible on calendar.
  void fetchSavedData() {
    workoutDetails =
        Provider.of<WorkoutProvider>(context, listen: true).allWorkoutModels;
    workoutDetails.forEach((workout) {
      _events.putIfAbsent(
          DateTime.parse(workout.date), () => [workout.workDuration]);
    });
  }

  @override
  void didChangeDependencies() {
    fetchSavedData();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    final _selectedDay = DateTime.now();
    _events = {};
    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
  }

  void _onFocusChange() {
    setState(() {
      _isExpanded = false;
    });
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Column(
      children: <Widget>[
        InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: _buildTableCalendar()),
        ExpandedSection(
          expand: _isExpanded,
          child: Container(
            width: double.infinity,
            height: mediaQuery.height * 0.4,
            child: CustomBarChart(
              startDayOfWeek: startDayOfWeek,
              endDayOfWeek: endDayOfWeek,
            ),
          ),
        ),
        SizedBox(
          height: mediaQuery.height * 0.05,
        ),
      ],
    );
  }

  Widget _buildTableCalendar() {
    return TableCalendar(
        calendarController: _calendarController,
        events: _events,
        startingDayOfWeek: StartingDayOfWeek.monday,

        ///TODO YED if you want all 3 types to be displayed uncomment these below
        headerVisible: true,
        initialCalendarFormat: CalendarFormat.week,
        availableCalendarFormats: {
          CalendarFormat.week: "1",
        },

        ///until here
        calendarStyle: CalendarStyle(
          todayColor: Colors.lightBlue,
          markersColor: Colors.black,
          outsideDaysVisible: true,
        ),
//      headerStyle: HeaderStyle(
//        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
//        formatButtonDecoration: BoxDecoration(
//          color: Colors.deepOrange[400],
//          borderRadius: BorderRadius.circular(16.0),
//        ),
//      ),
        onDaySelected: (clickedDate, b) {
          setState(() {
            ///if the date clicked is today's date close bar chart, else keep is open
            String userClickedDate =
                DateFormat('yyyy-MM-dd').format(clickedDate);
            String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
            if (todayDate == userClickedDate) {
              _isExpanded = !_isExpanded;
            } else {
              _isExpanded = true;
            }
          });
        },
        onVisibleDaysChanged: (dateTime1, dateTime2, _) {
          setState(() {
            startDayOfWeek =
                DateTime.parse(DateFormat('yyyy-MM-dd').format(dateTime1));
            endDayOfWeek =
                DateTime.parse(DateFormat('yyyy-MM-dd').format(dateTime2))
                    .add(new Duration(hours: 23));
          });
        });
  }
}

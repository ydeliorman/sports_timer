import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/models/workout_time_model.dart';
import 'package:sportstimer/providers/workout_time_provider.dart';
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

    _events = {
//      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
//      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
//
//      _selectedDay.subtract(Duration(days: 30)): ['Event A0', 'Event B0', 'Event C0'],
//      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
//      _selectedDay.subtract(Duration(days: 20)): ['Event A2', 'Event B2', 'Event C2', 'Event D2'],
//      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
//      _selectedDay.subtract(Duration(days: 10)): ['Event A4', 'Event B4', 'Event C4'],
//      _selectedDay.subtract(Duration(days: 4)): ['Event A5', 'Event B5', 'Event C5'],
//      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
//      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
//      _selectedDay.add(Duration(days: 1)): ['Event A8', 'Event B8', 'Event C8', 'Event D8'],
//      _selectedDay.add(Duration(days: 3)): Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
//      _selectedDay.add(Duration(days: 7)): ['Event A10', 'Event B10', 'Event C10'],
//      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
//      _selectedDay.add(Duration(days: 17)): ['Event A12', 'Event B12', 'Event C12', 'Event D12'],
//      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
//      _selectedDay.add(Duration(days: 26)): ['Event A14', 'Event B14', 'Event C14'],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents = events;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildTableCalendar(),
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
          selectedColor: Colors.deepOrange[400],
          todayColor: Colors.deepOrange[200],
          markersColor: Colors.brown[700],
          outsideDaysVisible: true,
        ),
//      headerStyle: HeaderStyle(
//        formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
//        formatButtonDecoration: BoxDecoration(
//          color: Colors.deepOrange[400],
//          borderRadius: BorderRadius.circular(16.0),
//        ),
//      ),
        onDaySelected: _onDaySelected,
        ///TODO YED when date is changed from MAY 2020 fetch data again. barchart.fetchSavedData()
        onVisibleDaysChanged: (s, d, f) => print("changed"));
  }
}

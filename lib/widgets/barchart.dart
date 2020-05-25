// Copyright 2018 the Charts project authors. Please see the AUTHORS file
// for details.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sportstimer/models/workout_time_model.dart';
import 'package:sportstimer/providers/workout_time_provider.dart';

class CustomBarChart extends StatefulWidget {
  final DateTime startDayOfWeek;
  final DateTime endDayOfWeek;

  const CustomBarChart({Key key, this.startDayOfWeek, this.endDayOfWeek})
      : super(key: key);

  @override
  _CustomBarChartState createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  List<WorkoutTimeModel> workoutDetails = [];
  List<WorkoutGraphInfo> data = [];

  DateTime _retrieveMondayOrSundayOfTheWeek(bool isMonday) {
    var dateTime = DateTime.now();
    var desiredDay = 1;
    isMonday ? desiredDay = 1 : desiredDay = 7;
    while (dateTime.weekday != desiredDay) {
      if (isMonday) {
        dateTime = dateTime.subtract(new Duration(days: 1));
      } else {
        dateTime = dateTime.add(new Duration(days: 1));
      }
    }

    return dateTime;
  }

  void fetchSavedData() {
    DateTime startDayOfWeek = widget.startDayOfWeek;
    DateTime endDayOfWeek = widget.endDayOfWeek;

    ///startDayOfWeek,endDayOfWeek  are set from custom_calendar#onVisibleDaysChanged
    ///if they are null retrieve as below
    if (startDayOfWeek == null) {
      startDayOfWeek = _retrieveMondayOrSundayOfTheWeek(true);
    }

    ///subtracted by 1 day because Date.isAfter looks for day later
    startDayOfWeek = startDayOfWeek.subtract(new Duration(days: 1));

    if (endDayOfWeek == null) {
      endDayOfWeek = _retrieveMondayOrSundayOfTheWeek(false);
    }

    ///added by 1 day because Date.isAfter looks for day later
    endDayOfWeek = endDayOfWeek.add(new Duration(days: 1));

    workoutDetails =
        Provider.of<WorkoutProvider>(context, listen: true).allWorkoutModels;
    data.add(WorkoutGraphInfo("Mon", 0));
    data.add(WorkoutGraphInfo("Tue", 0));
    data.add(WorkoutGraphInfo("Wed", 0));
    data.add(WorkoutGraphInfo("Thu", 0));
    data.add(WorkoutGraphInfo("Fri", 0));
    data.add(WorkoutGraphInfo("Sat", 0));
    data.add(WorkoutGraphInfo("Sun", 0));
    workoutDetails.forEach((workout) {
      DateTime workoutDate = DateTime.parse(workout.date);
      if (workoutDate.isAfter(startDayOfWeek) &&
          workoutDate.isBefore(endDayOfWeek)) {
        data.add(WorkoutGraphInfo(
            DateFormat('EEEE')
                .format(DateTime.parse(workout.date))
                .substring(0, 3),
            int.parse(workout.workDuration)));
      }
    });
  }

  List<charts.Series<WorkoutGraphInfo, String>> _createData() {
    return [
      new charts.Series<WorkoutGraphInfo, String>(
        id: 'Workouts',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Theme.of(context).primaryColor),
        domainFn: (WorkoutGraphInfo workout, _) => workout.day,
        measureFn: (WorkoutGraphInfo workout, _) => workout.workDuration,
        data: data,
      )
    ];
  }

  void setStateFromCalender() {
    setState(() {
      fetchSavedData();
    });
  }

  @override
  void didChangeDependencies() {
    fetchSavedData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    fetchSavedData();
    return new charts.BarChart(
      _createData(),
      animate: true,
    );
  }
}

class WorkoutGraphInfo {
  final String day;
  final int workDuration;

  WorkoutGraphInfo(this.day, this.workDuration);
}

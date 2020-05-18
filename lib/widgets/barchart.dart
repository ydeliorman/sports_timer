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
  @override
  _CustomBarChartState createState() => _CustomBarChartState();
}

class _CustomBarChartState extends State<CustomBarChart> {
  List<WorkoutTimeModel> workoutDetails = [];
  List<WorkoutGraphInfo> data = [];

  ///TODO YED when date is changed from MAY 2020 fetch data again
  void fetchSavedData() {
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
      data.add(WorkoutGraphInfo(
          DateFormat('EEEE')
              .format(DateTime.parse(workout.date))
              .substring(0, 3),
          int.parse(workout.workDuration)));
    });
  }

  List<charts.Series<WorkoutGraphInfo, String>> _createData() {
    return [
      new charts.Series<WorkoutGraphInfo, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (WorkoutGraphInfo sales, _) => sales.day,
        measureFn: (WorkoutGraphInfo sales, _) => sales.workDuration,
        data: data,
      )
    ];
  }

  @override
  void didChangeDependencies() {
    fetchSavedData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
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

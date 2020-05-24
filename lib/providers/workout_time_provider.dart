import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportstimer/models/workout_time_model.dart';

class WorkoutProvider with ChangeNotifier {
  List<WorkoutTimeModel> workoutModels = [];

  WorkoutProvider() {
    initialState();
  }

  List<WorkoutTimeModel> get allWorkoutModels => workoutModels;

  void initialState() {
    syncDataWithProvider();
  }

  void addWorkoutDetail(WorkoutTimeModel _workoutDetail) {
    List<WorkoutTimeModel> listOfMatchingWorkouts = workoutModels
        .where((workoutModel) => workoutModel.date == _workoutDetail.date)
        .toList();

    ///if any workout is done at same day update work duration
    if (listOfMatchingWorkouts != null && listOfMatchingWorkouts.length > 0) {
      WorkoutTimeModel matchingWorkout = listOfMatchingWorkouts[0];
      workoutModels.remove(matchingWorkout);
      int newWorkDuration = int.parse(_workoutDetail.workDuration) +
          int.parse(matchingWorkout.workDuration);
      _workoutDetail.workDuration = newWorkDuration.toString();
    }

    workoutModels.add(_workoutDetail);

    updateSharedPreferences();

    notifyListeners();
  }

  void removeWorkoutDetail(String id) {
    workoutModels.removeWhere((workoutDetail) => workoutDetail.id == id);

    updateSharedPreferences();

    notifyListeners();
  }

  int getWorkoutDetailLength() {
    return workoutModels.length;
  }

  Future updateSharedPreferences() async {
    List<String> workoutDetailList =
        workoutModels.map((f) => json.encode(f.toJson())).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('workoutDetailList', workoutDetailList);
  }

  Future syncDataWithProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getStringList('workoutDetailList');

    if (result != null) {
      workoutModels =
          result.map((f) => WorkoutTimeModel.fromJson(json.decode(f))).toList();
    }

    notifyListeners();
  }
}

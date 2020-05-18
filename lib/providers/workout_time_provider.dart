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

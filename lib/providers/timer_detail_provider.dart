import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportstimer/enums/StartScreenItemType.dart';
import 'package:sportstimer/models/timer_detail_model.dart';

class TimerProvider with ChangeNotifier {
  List<TimerDetailModel> timerDetails = [];
  static var id = "";
  static var sets = "3";
  static var workDuration = "0.3";
  static var restDuration = "0.05";

  TimerProvider() {
    initialState();
  }

  List<TimerDetailModel> get allTimerDetails => timerDetails;

  void initialState() {
    syncDataWithProvider();
  }

  void addTimerDetail(TimerDetailModel _timerDetail) {
    timerDetails.add(_timerDetail);

    updateSharedPreferences();

    notifyListeners();
  }

  Map<String, String> getTimerData() {
    return {
      'id': id,
      'sets': sets,
      'work': workDuration,
      'rest': restDuration,
    };
  }

  setTimerData(String value, StartScreenItemType type) {
    if (type == StartScreenItemType.Sets) {
      sets = value;
    } else if (type == StartScreenItemType.Work) {
      workDuration = value;
    } else if (type == StartScreenItemType.Rest) {
      restDuration = value;
    }
  }

  void removeTimerDetail(TimerDetailModel _timerDetail) {
//    timerDetails.removeWhere((timerDetail) => timerDetail.presetName == _timerDetail.presetName);

    updateSharedPreferences();

    notifyListeners();
  }

  int getTimerDetailLength() {
    return timerDetails.length;
  }

  Future updateSharedPreferences() async {
    List<String> timerDetailList =
        timerDetails.map((f) => json.encode(f.toJson())).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('timerDetailList', timerDetailList);
  }

  Future syncDataWithProvider() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var result = prefs.getStringList('timerDetailList');

    if (result != null) {
      timerDetails =
          result.map((f) => TimerDetailModel.fromJson(json.decode(f))).toList();
    } else {
      initTimerDetailForFirstTime();
    }

    notifyListeners();
  }

  void initTimerDetailForFirstTime() {
    TimerDetailModel timerDetailModel1 = TimerDetailModel(
      id: "Configuration 1/3",
      sets: "3",
      workDuration: "0.3",
      restDuration: "0.05",
    );
    TimerDetailModel timerDetailModel2 = TimerDetailModel(
      id: "Configuration 2/3",
      sets: "5",
      workDuration: "0.4",
      restDuration: "0.1",
    );
    TimerDetailModel timerDetailModel3 = TimerDetailModel(
      id: "Configuration 3/3",
      sets: "7",
      workDuration: "0.5",
      restDuration: "0.15",
    );

    addTimerDetail(timerDetailModel1);
    addTimerDetail(timerDetailModel2);
    addTimerDetail(timerDetailModel3);
  }
}

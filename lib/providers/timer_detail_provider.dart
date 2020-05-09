import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportstimer/enums/StartScreenItemType.dart';
import 'package:sportstimer/models/timer_detail_model.dart';

class TimerProvider with ChangeNotifier {
  List<TimerDetailModel> timerDetails = [];
  static var presetName = "";
  static var sets = "3";
  static var workDuration = "0.3";
  static var restDuration = "0.05";

  TimerProvider() {
    initialState();
  }

  List<TimerDetailModel> get allTimerDetails =>
      timerDetails;

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
      'presetName': presetName,
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
    timerDetails.removeWhere((timerDetail) => timerDetail.presetName == _timerDetail.presetName);

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
    }

    notifyListeners();
  }
}

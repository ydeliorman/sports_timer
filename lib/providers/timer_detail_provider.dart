import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportstimer/enums/StartScreenItemType.dart';

class TimerDetail with ChangeNotifier {
  static var presetName = "";
  static var sets = "3";
  static var workDuration = "0.3";
  static var restDuration = "0.05";
  Map<String, String> _timerData = {
    'presetName': presetName,
    'sets': sets,
    'work': workDuration,
    'rest': restDuration,
  };

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

  getStoredWorkOutInfo(presetName) async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(presetName)) {
      return {
        'presetName': '',
        'sets': '',
        'work': '',
        'rest': '',
      };
    }

    ///TODO yed burası exceğtion atıyo
    return json.decode(prefs.getString('workOutData')) as Map<String, String> ?? getTimerData();
  }

  getAllWorkOutInfo() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> keyList = prefs.getKeys().toList();

    List<Map<String, String>> workOutList = [];

    for (var i = 0; i < keyList.length; i++) {
      workOutList.add(await getStoredWorkOutInfo(keyList[i]));
    }

    return workOutList;
  }

  Future<void> storeWorkOutInfo(String presetName) async {
    var timerData = getTimerData();
    if (timerData == null) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final workOutData = jsonEncode({
      'presetName': presetName,
      'sets': timerData['sets'],
      'work': timerData['work'],
      'rest': timerData['rest'],
    });

    prefs.setString(presetName, workOutData);
  }
}

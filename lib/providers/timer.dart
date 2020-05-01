import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sportstimer/enums/StartScreenItemType.dart';

class TimerDetail with ChangeNotifier {
  String sets = "3";
  String workDuration = "0.3";
  String restDuration = "0.05";

  Map<String, String> getTimerData() {
    return {
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

    prefs.setString('workOutData', workOutData);
  }

  Future<Map<String, String>> getStoredWorkOutInfo() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('workOutData')) {
      return {
        'presetName': '',
        'sets': '',
        'work': '',
        'rest': '',
      };
    }

    return json.decode(prefs.getString('workOutData')) as Map<String, String>;
  }
}

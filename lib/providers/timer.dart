import 'package:flutter/foundation.dart';
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
}

import 'package:flutter/foundation.dart';
import 'package:sportstimer/enums/StartScreenItemType.dart';

class TimerDetail with ChangeNotifier {
  String sets;
  String workDuration;
  String restDuration;

  TimerDetail({
    @required this.sets,
    @required this.workDuration,
    @required this.restDuration,
  });

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
    } else if(type == StartScreenItemType.Rest){
      restDuration = value;
    }
  }
}

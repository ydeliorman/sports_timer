import 'package:flutter/foundation.dart';

class TimerDetail with ChangeNotifier {
  final String sets;
  final String workDuration;
  final String restDuration;

  TimerDetail({
    @required this.sets,
    @required this.workDuration,
    @required this.restDuration,
  });
}

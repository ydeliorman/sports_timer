import 'package:sportstimer/models/timer_detail_model.dart';

class NumberPickerFormatter {
  static int extractNumberPickerTime(
      String numberPickerType, TimerDetailModel timerDetailModel) {
    int workDurationDecimalPart;

    ///if the number is 0 18 -> workDurationInDecimal will be 0.18

    var workDurationInDecimal;
    if (numberPickerType == 'work') {
      workDurationInDecimal = double.parse(timerDetailModel.workDuration);
    } else {
      workDurationInDecimal = double.parse(timerDetailModel.restDuration);
    }

    int workDurationIntPart = workDurationInDecimal.toInt();

    ///if the decimal part is divided by 10(length == 1), multiply by then the extracted decimal part
    if (workDurationInDecimal.toString().split('.')[1].length == 1) {
      workDurationDecimalPart =
          int.tryParse(workDurationInDecimal.toString().split('.')[1]) * 10;
    } else if (workDurationInDecimal.toString().split('.')[1].length == 2) {
      workDurationDecimalPart =
          int.tryParse(workDurationInDecimal.toString().split('.')[1]);
    }

    return 60 * workDurationIntPart + workDurationDecimalPart;
  }

  static List<String> gatherTimeForRichText(String _timer) {
    String intPart = '';
    String decimalPart = '';

    ///if the number is 0 18 -> workDurationInDecimal will be 0.18
    var workDurationInDecimal = double.parse(_timer);
    int workDurationIntPart = workDurationInDecimal.toInt();

    ///if the decimal part is divided by 10(length == 1), multiply by then the extracted decimal part
    if (workDurationInDecimal.toString().split('.')[1].length == 1) {
      decimalPart =
          workDurationInDecimal.toString().split('.')[1].padRight(2, '0');
    } else if (workDurationInDecimal.toString().split('.')[1].length == 2) {
      decimalPart = workDurationInDecimal.toString().split('.')[1];
    }

    intPart = workDurationInDecimal.toString().split('.')[0].padLeft(2, '0');

    return [intPart, decimalPart];
  }
}

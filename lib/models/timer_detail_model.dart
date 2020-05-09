class TimerDetailModel {
  String presetName;
  String sets;
  String workDuration;
  String restDuration;

  TimerDetailModel(
      {this.presetName, this.sets, this.workDuration, this.restDuration});

  Map toJson() => {
        'name': presetName,
        'bankName': sets,
        'number': workDuration,
        'currency': restDuration,
      };

  TimerDetailModel.fromJson(Map json)
      : presetName = json['presetName'],
        sets = json['bankName'],
        workDuration = json['number'],
        restDuration = json['currency'];
}

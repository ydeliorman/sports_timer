class TimerDetailModel {
  String presetName;
  String sets;
  String workDuration;
  String restDuration;

  TimerDetailModel(
      {this.presetName, this.sets, this.workDuration, this.restDuration});

  Map toJson() => {
        'presetName': presetName,
        'sets': sets,
        'workDuration': workDuration,
        'restDuration': restDuration,
      };

  TimerDetailModel.fromJson(Map json)
      : presetName = json['presetName'],
        sets = json['sets'],
        workDuration = json['workDuration'],
        restDuration = json['restDuration'];
}

class TimerDetailModel {
  String id;
  String sets;
  String workDuration;
  String restDuration;

  TimerDetailModel(
      {this.id, this.sets, this.workDuration, this.restDuration});

  Map toJson() => {
        'id': id,
        'sets': sets,
        'workDuration': workDuration,
        'restDuration': restDuration,
      };

  TimerDetailModel.fromJson(Map json)
      : id = json['id'],
        sets = json['sets'],
        workDuration = json['workDuration'],
        restDuration = json['restDuration'];
}

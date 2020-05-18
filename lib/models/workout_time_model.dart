class WorkoutTimeModel {
  String id;
  String date;
  String workDuration;

  WorkoutTimeModel(
      {this.id, this.date, this.workDuration,});

  Map toJson() => {
    'id': id,
    'date': date,
    'workDuration': workDuration,
  };

  WorkoutTimeModel.fromJson(Map json)
      : id = json['id'],
        date = json['date'],
        workDuration = json['workDuration'];
}

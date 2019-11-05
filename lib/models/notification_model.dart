import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationModel {
  int id;
  Time time;
  Day day;
  String displayDay;
  bool status;

  NotificationModel(
      {this.id, this.displayDay, this.time, this.day, this.status});

  factory NotificationModel.fromDb(Map<String, dynamic> db) {
    Day _day;
    String _displayDay;

    switch (db['day']) {
      case "Monday":
        {
          _day = Day.Monday;
          _displayDay = "Monday";
          break;
        }

      case "Tuesday":
        {
          _day = Day.Tuesday;
          _displayDay = "Tuesday";
          break;
        }

      case "Wednesday":
        {
          _day = Day.Wednesday;
          _displayDay = "Wednesday";
          break;
        }

      case "Thursday":
        {
          _day = Day.Thursday;
          _displayDay = "Thursday";
          break;
        }

      case "Friday":
        {
          _day = Day.Friday;
          _displayDay = "Friday";
          break;
        }

      case "Saturday":
        {
          _day = Day.Saturday;
          _displayDay = "Saturday";
          break;
        }

      default:
        {
          _day = Day.Sunday;
          _displayDay = "Sunday";
          break;
        }
    }

    return NotificationModel(
        id: db['id'] ?? 0,
        time: Time(
            DateTime.parse(db['time']).hour, DateTime.parse(db['time']).minute),
        day: _day,
        displayDay: _displayDay,
        status: db['status'] == 1 ? true : false);

  }
}

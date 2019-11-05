import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:goodvibes/models/notification_model.dart';
import 'package:goodvibes/providers.dart/notification_provider.dart';
import 'package:goodvibes/providers.dart/reminder_db_provider.dart';
import 'package:provider/provider.dart';

class AddNewReminder extends StatefulWidget {
  @override
  _AddNewReminderState createState() => _AddNewReminderState();
}

class _AddNewReminderState extends State<AddNewReminder> {
  TextEditingController controllerHr = new TextEditingController();
  TextEditingController controllerMin = new TextEditingController();

  bool ampm = true;
  Time _time = Time();
  String timeForDb;
  String hh = '--', mm = '--', pm = 'AM/PM';

  List selectedDays = [];

  List<String> weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final notify = Provider.of<NotificationProvider>(context);
    final reminder = Provider.of<ReminderDbProvider>(context);

    setNotification() async {
      Day day;
      selectedDays.forEach((val) {
        int id = Random().nextInt(100) + Random().nextInt(1000);
        switch (val) {
          case 1:
             {
              day = Day.Monday;
              print('Case monday $timeForDb');
              notify.showNotificationWithSound(id, _time, day);
              reminder.addReminder(
                  id: id, time: timeForDb, day: 'Monday', status: 1);
              break;
            }

          case 2:
            {
              day = Day.Tuesday;
              notify.showNotificationWithSound(id, _time, day);
              reminder.addReminder(
                  id: id, time: timeForDb, day: 'Tuesday', status: 1);
              break;
            }

          case 3:
            {
              day = Day.Wednesday;
              notify.showNotificationWithSound(id, _time, day);
              reminder.addReminder(
                  id: id, time: timeForDb, day: 'Wednesday', status: 1);
              break;
            }

          case 4:
            {
              day = Day.Thursday;
              notify.showNotificationWithSound(id, _time, day);
              reminder.addReminder(
                  id: id, time: timeForDb, day: 'Thursday', status: 1);
              break;
            }

          case 5:
            {
              day = Day.Friday;
              notify.showNotificationWithSound(id, _time, day);
              reminder.addReminder(
                  id: id, time: timeForDb, day: 'Friday', status: 1);
              break;
            }

          case 6:
            {
              day = Day.Saturday;
              notify.showNotificationWithSound(id, _time, day);
              reminder.addReminder(
                  id: id, time: timeForDb, day: 'Saturday', status: 1);
              break;
            }

          default:
            {
              day = Day.Sunday;
              notify.showNotificationWithSound(id, _time, day);
              reminder.addReminder(
                  id: id, time: timeForDb, day: 'Sunday', status: 1);
              break;
            }
        }
      });
      Navigator.pop(context);
    }

 void _confirmReminder() {
      if (selectedDays.isEmpty || timeForDb == null) {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => CupertinoAlertDialog(
                  title: Text('Day & Time not Selected ?'),
                  actions: <Widget>[
                    OutlineButton.icon(
                      borderSide: BorderSide.none,
                      icon: Icon(Icons.close),
                      label: Text('Close'),
                      onPressed: () => Navigator.pop(context),
                    )
                  ],
                  content: Text(
                      'Please selet the day and time you would like to be reminded.'),
                ));
      } else {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => CupertinoAlertDialog(
                  title: Text('Confirm ?'),
                  actions: <Widget>[
                    OutlineButton.icon(
                      borderSide: BorderSide.none,
                      icon: Icon(Icons.close),
                      label: Text('Close'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    OutlineButton.icon(
                        borderSide: BorderSide.none,
                        icon: Icon(Icons.check),
                        label: Text('Confirm'),
                        onPressed: () {
                          
                          setNotification();
                          Navigator.pop(context);
                        }),
                  ],
                  content: Text(
                      'You will be reminded by notification on the selected day(s) at $hh:$mm $pm'),
                ));
      }
    }
   
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/onboarding3.png'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Set Reminder',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.1,
                )
              ],
            ),
            Spacer(),
            Center(
              child: Container(
                  width: 100.0,
                  height: 100.0,
                  child: Image.asset(
                    'assets/images/alarm-clock.png',
                    fit: BoxFit.contain,
                  )),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Going to bed at the same time each night is key to healthy sleep. What time do you want toget ready for bed',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ),
            Spacer(),
            Center(
              child: GestureDetector(
                onTap: () {
                  showTimePicker(context);
                },
                child: Text(
                  '$hh:$mm $pm',
                  style: TextStyle(color: Colors.white, fontSize: 45.0),
                ),
              ),
            ),
            Spacer(),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Repeat',
                    style: TextStyle(color: Color(0xFFEEAEFF), fontSize: 16.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Container(
                height: 50.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (selectedDays.contains(index)) {
                              selectedDays.remove(index);
                              print('contains');
                              print(selectedDays);
                            } else if (!(selectedDays.contains(index))) {
                              selectedDays.add(index);
                              print('not contains');
                              print(selectedDays);
                            }
                          });
                        },
                        child: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: selectedDays.contains(index)
                              ? BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(50.0))
                              : BoxDecoration(
                                  border: Border.all(
                                      width: 1.0, color: Colors.white),
                                  borderRadius: BorderRadius.circular(50.0)),
                          child: Center(
                            child: Text(weekdays[index],
                                style: selectedDays.contains(index)
                                    ? TextStyle(color: Colors.black)
                                    : TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Spacer(),
            Row(
              children: <Widget>[
                Expanded(
                                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        // setNotification();
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.1, 0.6],
                            colors: [
                              Color(0xFF3741AE),
                              Color(0xFF6719A5),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            child: Text(
                              'CANCEL',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        _confirmReminder();
                        // Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: [0.1, 0.6],
                            colors: [
                              Color(0xFF3741AE),
                              Color(0xFF6719A5),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 10.0),
                            child: Text(
                              'OK',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  showTimePicker(BuildContext context) {
    new Picker(
        adapter: new DateTimePickerAdapter(
          type: PickerDateTimeType.kHM_AP,
        ),
        title: new Text("Select Time"),
        onConfirm: (Picker picker, List value) {
          timeForDb = picker.adapter.toString();
          print('Time from picker $timeForDb');
          var time = DateTime.parse(timeForDb);
          _time = Time(time.hour, time.minute);
          if (time.hour > 12) {
            hh = (time.hour - 12).toString();
            pm = 'PM';
          } else {
            hh = time.hour.toString();
            pm = 'AM';
          }
          mm = time.minute.toString();
          setState(() {});
        },
        onSelect: (Picker picker, int index, List<int> selecteds) {
          timeForDb = picker.adapter.toString();
          print('Time from picker $timeForDb');
          var time = DateTime.parse(timeForDb);
          _time = Time(time.hour, time.minute);
          if (time.hour > 12) {
            hh =  (time.hour - 12).toString();
            pm = 'PM';
          } else {
            hh = time.hour.toString();
            pm = 'AM';
          }
          mm = time.minute.toString();
          setState(() {});
        }).show(_scaffoldKey.currentState);
  }
}

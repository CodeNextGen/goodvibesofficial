
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/models/notification_model.dart';
import 'package:goodvibes/providers.dart/notification_provider.dart';
import 'package:goodvibes/providers.dart/reminder_db_provider.dart';
import 'package:provider/provider.dart';

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {

  @override
  Widget build(BuildContext context) {
    final notify = Provider.of<NotificationProvider>(context);
    final reminder = Provider.of<ReminderDbProvider>(context);
    reminder.initDB();
    reminder.getReminder();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/onboarding3.png'),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Spacer(),
                  Text(
                    'My Reminders',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      CupertinoIcons.delete,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () => Navigator.pushNamed(context, 'deleteReminders'),
                  ),
                ],
              ),
              Expanded(
                child: reminder.notifications.length > 0
                    ? Container(
                        padding: EdgeInsets.all(12),
                        child: ListView.builder(
                            itemCount: reminder.notifications.length,
                            itemBuilder: (context, int i) {
                              NotificationModel notification =
                                  reminder.notifications[i];

                              String hh = '', mm = '', ampm = '';
                              int a;
                              if (notification.time.hour > 12) {
                                a = notification.time.hour - 12;
                                ampm = 'PM';
                              } else {
                                ampm = 'AM';
                                a = notification.time.hour;
                              }
                              if (a < 10)
                                hh = '0' + a.toString();
                              else
                                hh = a.toString();
                              if (notification.time.minute < 10)
                                mm = '0' + notification.time.minute.toString();
                              else
                                mm = notification.time.minute.toString();

                              return Container(
                                padding: EdgeInsets.only(bottom: 8),
                                color: Colors.transparent,
                                child: ListTile(
                                  trailing: CupertinoSwitch(
                                    activeColor: Color(0xFF0E0778),
                                    value: notification.status,
                                    onChanged: (val) {
                                      reminder.updateStatus(
                                          id: notification.id, status: val);
                                      notification.status = val;
                                      if(val==false)
                                      notify.cancelAllNotiFicationById(notification.id);
                                      else
                                      notify.showNotificationWithSound(notification.id, notification.time, notification.day);
                                    },
                                  ),
                                  title: Text(
                                    ' $hh:$mm $ampm',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 34),
                                  ),
                                  subtitle: Text(
                                    '    ${notification.displayDay}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }),
                      )
                    : Center(
                        child: Text('No Reminders Found',style: TextStyle(color: Colors.white),),
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, 'addNewReminder'),
        // onPressed: ()=>reminder.deleteAllTable(),
        backgroundColor: Colors.white,
        child: Icon(
          Icons.add,
          color: Color(0xFF0E0778),
          size: 44,
        ),
      ),
    );
  }
}

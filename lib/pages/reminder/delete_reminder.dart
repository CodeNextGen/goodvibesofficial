import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/models/notification_model.dart';
import 'package:goodvibes/providers.dart/notification_provider.dart';
import 'package:goodvibes/providers.dart/reminder_db_provider.dart';
import 'package:provider/provider.dart';

class DeleteReminders extends StatefulWidget {
  @override
  _DeleteRemindersState createState() => _DeleteRemindersState();
}

class _DeleteRemindersState extends State<DeleteReminders> {
  List<int> todelete = [];

  @override
  Widget build(BuildContext context) {
    final notify = Provider.of<NotificationProvider>(context);
    final reminder = Provider.of<ReminderDbProvider>(context);
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
                    '${todelete.length} item Selected',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Spacer(),
                  SizedBox(
                    width: 30,
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
                                  key: Key(notification.id.toString()),
                                  trailing: todelete.contains(notification.id)
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.check_circle,
                                            size: 32,
                                            color: Colors.white,
                                          ),
                                          onPressed: () => setState(() {
                                            todelete.remove(notification.id);
                                          }),
                                        )
                                      : IconButton(
                                          onPressed: () => setState(() {
                                            todelete.add(notification.id);
                                          }),
                                          icon: Icon(
                                            Icons.radio_button_unchecked,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                        ),
                                  // trailing: Checkbox(
                                  //   checkColor: Color(0xFF0E0778),
                                  //   // activeColor: Color(0xFF0E0778),

                                  //   value: notification.status,
                                  //   onChanged: (val) {
                                  //     reminder.updateStatus(
                                  //         id: notification.id, status: val);
                                  //     notification.status = val;
                                  //     if(val==false)
                                  //     notify.cancelAllNotiFicationById(notification.id);
                                  //     else
                                  //     notify.showNotificationWithSound(notification.id, notification.time, notification.day);
                                  //   },
                                  // ),
                                  title: Text(
                                    ' $hh:$mm $ampm',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 34),
                                  ),
                                  subtitle: Text(
                                    ' Every ${notification.displayDay}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }),
                      )
                    : Center(
                        child: Text(
                          'No Reminders Found',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      notify.cancelAllNotiFication();
                      reminder.deleteMultipleRecors(todelete);
                      Navigator.pop(context);
                    },
                    child: Column(
                      children: <Widget>[
                        Icon(
                          CupertinoIcons.delete,
                          size: 43,
                          color: Colors.white,
                        ),
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     notify.cancelAllNotiFication();
      //     reminder.deleteAllTable();
      //     Navigator.pop(context);
      //   },
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   child: Column(
      //     children: <Widget>[
      //       Icon(
      //         Icons.delete,
      //         color: Colors.white,
      //         semanticLabel: 'Delete',
      //         size: 33,
      //       ),
      //       Text(
      //         'Delete',
      //         style: TextStyle(color: Colors.white),
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}

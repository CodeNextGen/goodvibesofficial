import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/models/notification_model.dart';

import '../config.dart';

class NotificationPageProvider extends ChangeNotifier{
  Dio dio = Dio();
  List<NotificationRequest> notificationRequestList = [];

  NotificationPageProvider(){
    initNotificationRequests();
  }

  getNotificationRequestTrack({int page = 1, int perpage = 10}) async {
//    if (page == 1) notificationRequestList.clear();

    try{
      var respons = await dio.get(
        '$baseUrl/v1/push_notifications',
        queryParameters: {'page': page, 'per_page': perpage},
        options: Options(
          headers: {'Authorization': authorization},
        ),
      );
      List<dynamic> rsp = respons.data as List;
      print('notificationsList : $rsp');
      var a = rsp.map<NotificationRequest>((json) => NotificationRequest.fromJson(json));
      notificationRequestList.addAll(a);
      print('notifications : $notificationRequestList');
      // tracks = albumTracks;
      notifyListeners();
    }on DioError catch (error) {
      if (error.response.statusCode == 404) {
        print("error message ? : " + error.toString());
      }
    }
  }

  void initNotificationRequests() {
    getNotificationRequestTrack();
  }
}
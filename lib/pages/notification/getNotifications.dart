import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/models/notification_model.dart';
import 'package:goodvibes/providers.dart/notification_page_provider.dart';
import 'package:provider/provider.dart';

class GetNotifications extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
//    final settings = Provider.of<StartupProvider>(context);

    return Consumer<NotificationPageProvider>(builder: (context, data, _) {
      return Container(
//        margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        height: 160.0,
        child: data.notificationRequestList.isNotEmpty
            ? ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.notificationRequestList.length,
          itemBuilder: (BuildContext context, int index) {
            NotificationRequest _notificationRequest = data.notificationRequestList[index];
            return Card(
              color: Colors.white,
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding:
                          const EdgeInsets.only(top: 16.0, left: 16.0),
                          child: Text(
                            _notificationRequest.content,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding:
                          const EdgeInsets.only(top: 16.0, right: 10.0),
                          child: CircleAvatar(
                            child: Image.asset(
                              "assets/images/logo1.png",
                              height: 30,
                              width: 20,
                            ),
                            backgroundColor: Colors.brown,
                          ),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 16.0, bottom: 16.0),
                    child: Text("16 mins ago",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black12,
                        )),
                  )
                ],
              ),
            );
//              return Padding(
//                padding: const EdgeInsets.only(right: 15.0),
//                child: InkWell(
//                  onTap: () {
//                    data.getAlbumsTracks(id: _album.id);
//                    Navigator.pushNamed(context, 'albumsongs',
//                        arguments: _album);
//                  },
//                  child: Container(
//                    width: 300.0,
//                    height: 200,
//                    decoration: BoxDecoration(
//                      borderRadius: BorderRadius.circular(10.0),
//                      image: DecorationImage(
//                          image: NetworkImage(_album.image),
//                          fit: BoxFit.cover),
//                      // color: Colors.blue
//                    ),
//
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Align(
//                        alignment: Alignment.centerLeft,
//                        child: Container(
//                          width: 150,
//                          child: Text(
//                            _album.title.toUpperCase(),
//                            style: TextStyle(
//                              color: Colors.white,
//                              fontSize: 18.0,
//                            ),
//                            maxLines: 2,
//                            overflow: TextOverflow.fade,
//                            softWrap: true,
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
//                ),
//              );
          },
        )
            : Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 108.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: Icon(Icons.notifications_off,color: Colors.black12)),
                  Expanded(child: Text("No notifications at the moment", style: TextStyle(
                    fontSize: 14,
                    color: Colors.black12,
                  )))
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

}
import 'package:flutter/material.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 30.0),
      child: Container(
        child: Consumer<StartupProvider>(
          builder: (context, state, _) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () async {
                  bool islogin = await state.loggedIn() ?? false;

                  if (islogin == true)
                    Navigator.pushNamed(context, 'profile');
                  else {
                    Navigator.pushNamed(context, 'login');
                  }
                },
                child: CircleAvatar(
                  radius: 22.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: state.userdata.image != null
                      ? NetworkImage(state.userdata.image)
                      : AssetImage('assets/images/avatar.png'),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Hello, ${state.userdata.name == null ? 'Guest' : state.userdata.name.split(' ')[0]}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      (DateFormat.yMEd().format(DateTime.now())),
                      style: TextStyle(color: Colors.white, fontSize: 9.0),
                    ),
                  )
                ],
              ),
              Spacer(),
              // Column(
              //   children: <Widget>[
              //     Padding(
              //       padding: const EdgeInsets.only(top: 8.0),
              //       child: Text('Todays Activities',style: TextStyle(fontSize: 13,color: Colors.white),),
              //     ),
              //     Text('Time Spent : 90 min',style: TextStyle(fontSize: 9,color: Colors.white),),
              //   ],
              // ),
              // Spacer(),
              SizedBox(
                height: 45,
                width: 45,
                child: Stack(
                  children: <Widget>[
                    IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  size: 30,
                ),
                onPressed: (){
                  Navigator.pushNamed(context, 'notification');
                },
                color: Colors.white,
                
              ),
              //visible when there is unread notification
//              Positioned(
//                // alignment: Alignment.centerRight,
//                top: 5,
//                bottom: 5,
//                right: 11,
//
//                child: SizedBox(
//                  width: 10,
//                  height: 10,
//                  child: CircleAvatar(backgroundColor: Color(0xFFFF7D00), ))
//                )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

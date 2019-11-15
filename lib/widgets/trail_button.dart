
import 'package:flutter/material.dart';
import 'package:goodvibes/pages/payments/subscription.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:provider/provider.dart';

class TrailButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<StartupProvider>(context);
    state.getUserData();
    if (state.userdata.paid != true) 
    {
      return InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute<Null>(
              builder: (BuildContext context) {
                return SubscriptionPage();
              },
              fullscreenDialog: true));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10.0),
          child: Container(
            height: 60.0,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
            decoration: BoxDecoration(boxShadow: <BoxShadow>[
              BoxShadow(
                spreadRadius: 1,
                color: Color(0xff581DAA).withOpacity(0.3),
                // offset: Offset(15.0, 15.0),
                blurRadius: 8.0,
              ),
            ], borderRadius: BorderRadius.circular(5.0), color: Colors.white),
            child: Center(
              child: Row(
                children: <Widget>[
                  Container(
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5)),
                      border: Border.fromBorderSide(BorderSide.none),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 0.9],
                        colors: [
                          Color(0xFF4025B2),
                          Color(0xFF6619A5),
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Free Trial for 7 days',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else
      return Container();
  }
}

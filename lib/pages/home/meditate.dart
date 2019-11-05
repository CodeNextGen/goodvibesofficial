import 'package:flutter/material.dart';

class Meditate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/onboarding3.png'),
              fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(
              flex: 2,
            ),
            Text(
              'Coming Soon',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            Spacer(
              flex: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Fill your body with deep breaths and it will fill your with peace.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFEEAEFF)),
              ),
            ),
            Spacer(
              flex: 1,
            ),
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: Text('Subscribe and Be the first to know it.',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(
            //         color: Colors.white,
            //       )),
            // ),
            // Spacer(
            //   flex: 1,
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(5.0),
            //       color: Colors.white),
            //   width: width * 0.9,
            //   height: 50.0,
            //   child: Center(
            //     child: Text('Full Name',
            //         style: TextStyle(color: Colors.black, fontSize: 17.0)),
            //   ),
            // ),
            // SizedBox(
            //   height: 10.0,
            // ),
            // Container(
            //   decoration: BoxDecoration(
            //       borderRadius: BorderRadius.circular(5.0),
            //       color: Colors.white),
            //   width: width * 0.9,
            //   height: 50.0,
            //   child: Center(
            //     child: Text('Email Address',
            //         style: TextStyle(color: Colors.black, fontSize: 17.0)),
            //   ),
            // ),
            // Spacer(
            //   flex: 3,
            // ),
          ],
        ),
      ),
    );
  }
}

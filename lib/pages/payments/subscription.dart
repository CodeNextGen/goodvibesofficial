import 'package:flutter/material.dart';
import 'package:goodvibes/providers.dart/payment_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/widgets/rectange_clipper.dart';
import 'package:provider/provider.dart';
import '../privacy/privacy_policy.dart';

class SubscriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('sub page is loaded');
    final paymentstate = Provider.of<PaymentProvider>(context);
    // paymentstate.getProducts();
    void _restorePurchase() {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // Align(
                  //   alignment: Alignment.topRight,
                  //   child: Icon(Icons.cancel),
                  // ),
                  Text(
                      'If you have previously upgraded to the pro version using an in-app purchase you are entitled to a free upgrade.\n\nApple does not charge twice for the same upgrade, as long as the iTunes. App Store account is the same as when it was originally purchased.\n\nWould you like to initiate this process now?',
                      style:
                          TextStyle(fontSize: 14.0, color: Color(0xFF707070))),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 70.0,
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                    stops: [0.1, 0.9],
                                    colors: [
                                      Color(0xFF4025B2),
                                      Color(0xFF6619A5),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Center(
                                  child: Text('No',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //handle restiore subscription logic
                            Navigator.pushNamedAndRemoveUntil(context, 'home',
                                (Route<dynamic> route) => false);
                          },
                          child: Container(
                            width: 70.0,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                  stops: [0.1, 0.9],
                                  colors: [
                                    Color(0xFF4025B2),
                                    Color(0xFF6619A5),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 4.0),
                              child: Center(
                                child: Text('Yes',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    }

// paymentstate.productForPurchase(0);
    if (paymentstate.storeAvailable != true &&
        paymentstate.storeAvailable != null) Navigator.pop(context);
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Container(
                        height: 250.0,
                        child: ClipPath(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  width: double.infinity,
                                  height: 250.0,
                                  color: Colors.purpleAccent,
                                  child: Image.asset(
                                    'assets/images/freeTrial.png',
                                    fit: BoxFit.cover,
                                  )),
                              Container(
                                width: double.infinity,
                                height: 250.0,
                                color: Color(0x773F3FB6),
                              ),
                            ],
                          ),
                          clipper: RectangleClipper(),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Try free for 7 days',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFF3C27B4),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: Text(
                                '100+ Guided Meditation Covering Anxiety, Tinnitus Focus, Stress, Gratitude, Binaural Beats And Much More.',
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFF3C27B4),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: Text(
                                'Remove ads and listen full length track.',
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFF3C27B4),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: Text(
                                'Download track and listen when you’re on the go',
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFF3C27B4),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Flexible(
                              child: Text(
                                'Customizable meditation timer and download without limits',
                                style: TextStyle(
                                    fontSize: 13.0, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Stack(children: [
                            GestureDetector(
                              onTap: () {
                                paymentstate.productForPurchase(0);
                              },
                              child: Container(
                                height: 150.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  boxShadow: paymentstate.selected == 0
                                      ? <BoxShadow>[
                                          BoxShadow(
                                            color:
                                                Colors.purple.withOpacity(0.6),
                                            offset: Offset(1.0, 1.0),
                                            blurRadius: 6.0,
                                          ),
                                        ]
                                      : null,
                                ),
                                width: double.infinity,
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      height: 40.0,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5.0),
                                            topRight: Radius.circular(5.0)),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: [0.1, 0.9],
                                          colors: [
                                            Color(0xFF4424B1),
                                            Color(0xFF631AA6),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Text(
                                            'MONTHLY',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      'MONTHLY',
                                      style: TextStyle(
                                          fontSize: 12.0, fontFamily: 'Roboto'),
                                    ),
                                    Text(
                                      'US 4.99',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0,
                                          fontFamily: 'Roboto'),
                                    ),
                                    Text('Per Month',
                                        style: TextStyle(
                                            fontSize: 12.0,
                                            fontFamily: 'Roboto'))
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              // alignment: Alignment.bottomRight,
                              bottom: 1,
                              right: 1,
                              child: paymentstate.selected == 0
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 32,
                                    )
                                  : Container(),
                            )
                          ]),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Expanded(
                          flex: 1,
                          child: Stack(children: [
                            GestureDetector(
                              onTap: () {
                                paymentstate.productForPurchase(1);
                              },
                              child: Container(
                                height: 150.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white,
                                  boxShadow: paymentstate.selected == 1
                                      ? <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.purple
                                                  .withOpacity(0.6),
                                              offset: Offset(1.0, 1.0),
                                              blurRadius: 6.0),
                                        ]
                                      : null,
                                ),
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      height: 40.0,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(5.0),
                                            topRight: Radius.circular(5.0)),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          stops: [0.1, 0.9],
                                          colors: [
                                            Color(0xFF4424B1),
                                            Color(0xFF631AA6),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0),
                                          child: Text(
                                            'Most Popular',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 100.0,
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'Yearly'.toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'Roboto'),
                                          ),
                                          Text(
                                            'USD 2.99',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22.0,
                                                fontFamily: 'Roboto'),
                                          ),
                                          Text(
                                            'Per Month',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'Roboto'),
                                          ),
                                          Divider(),
                                          Text(
                                            '35.88/yr',
                                            style: TextStyle(
                                                color: Color(0xFFA3A7B2),
                                                fontSize: 14.0,
                                                fontFamily: 'Roboto'),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              // alignment: Alignment.bottomRight,
                              bottom: 1,
                              right: 1,
                              child: paymentstate.selected == 1
                                  ? Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 32,
                                    )
                                  : Container(),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  Consumer<StartupProvider>(
                    builder: (context, state, _) => InkWell(
                      onTap: () {
                        print(state.userdata.uid);
                        //  paymentstate.makePurchase();
                        paymentstate.makePurchase(state.userdata);
                        //  paymentstate.testPurchase();
                        // if(paymentstate.paymentStatus)
                        // Navigator.pushNamedAndRemoveUntil(context, 'home', (Route<dynamic> route)=>false);
                        // print(paymentstate.purchasedItem);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 15.0),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Color(0xFFDBE7F5),
                                offset: Offset(1.0, 10.0),
                                blurRadius: 10.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(5.0),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.1, 0.9],
                              colors: [
                                Color(0xFF7E2BF5),
                                Color(0xFF3741AE),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 10.0),
                              child: Text(
                                'Start Free Trail',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Recurring billing. Cancel anytime, 7 Days Free Trail',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13.0, color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () {
                            _restorePurchase();
                          },
                          child: Text(
                            'Restore Purchase',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 18.00, color: Colors.blue),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Text(
                            'Your payment will be charged to your  Account after trail period.',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 14.00, color: Colors.black),
                          ),
                        ),
                        Text(
                          'Your account will be charged again when your subscription automatically renews at the end of your current subscription period unless auto-renew is turned off at least 24 hours prior to end of the current period.',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 14.00, color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Text(
                            'You can manage or turn off auto-renew in your  Account Settings any time.',
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(fontSize: 14.00, color: Colors.black),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              child: Text(
                                'Privacy Policy ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.00, color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PrivacyPolicy()));
                              },
                            ),
                            Text('|'),
                            FlatButton(
                              onPressed: () {},
                              child: Text(
                                'Terms of Use ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12.00, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 45,
              right: 5,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.cancel,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              top: 45,
              left: 5,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

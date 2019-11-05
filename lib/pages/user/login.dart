import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/models/user_model.dart';
import 'package:goodvibes/providers.dart/login_provider.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/widgets/popup_message.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final loginProvider = Provider.of<LoginProvider>(context);
    final startupProvider = Provider.of<StartupProvider>(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 22),
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(
              flex: 3,
            ),
            Container(
              width: 90.0,
              child: Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/images/logo1.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(
              height: 45,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'emaillogin');
                },
                child: Container(
                  width: width * 0.90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.mail_outline,
                          color: Colors.black,
                          size: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text('Sign in with Email',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            //google login button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: width * 0.90,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
                child: InkWell(
                  onTap: () async {
                   bool status=  await loginProvider.loginWithGoogle();
                    UserData user = await startupProvider.getUserData();
                    print(user.email);

                    if (status) {
                      if(user.email.isNotEmpty)
                      Navigator.pushNamedAndRemoveUntil(
                          context, 'home', (Route<dynamic> route) => false);
                    } else {
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return CupertinoAlertDialog(
                              content: MyShowDialog(),
                            );
                          });
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/googleLogo.png',
                          width: 30.0,
                          height: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text('Sign in with Gmail',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //facebook login button
            GestureDetector(
              onTap: () async {
                bool status = await loginProvider.loginWithFacebook();
                UserData user = await startupProvider.getUserData();

                print(user.email);
                print('User email is');
                // print(user.uid);

                if (status) {
                  if (user.uid.isNotEmpty)
                    Navigator.pushNamedAndRemoveUntil(
                        context, 'home', (Route<dynamic> route) => false);
                } else {
                  showDialog(
                      barrierDismissible: true,
                      context: context,
                      builder: (BuildContext context) {
                        return CupertinoAlertDialog(
                          content: MyShowDialog(),
                        );
                      });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: width * 0.90,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          'assets/images/facebookLogo.png',
                          width: 20.0,
                          height: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text('Sign in with Facebook',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
      
      

            Spacer(
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}

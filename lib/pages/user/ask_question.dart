import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AskQuestion extends StatefulWidget {
  @override
  _AskQuestionState createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {
  static GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  Map<String, dynamic> _formData = {};

  Future<bool> sendMail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');
    String email = prefs.getString('email');
    _formData['name'] = name;
    _formData['email'] = email;

    Dio dio = Dio();
    await dio.post(
      '$baseUrl/v1/users/user_id/send_mail',
      data: _formData,
      options: Options(
        headers: {'Authorization': authorization},
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/onboarding2.png'),
              fit: BoxFit.cover),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Ask a Question',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: Text(
                    'Use the form below to send us your feedback/request or any query, we will respond you on your registered email.', style: TextStyle(color: Colors.white, ),textAlign:TextAlign.justify),
              ),
              // SizedBox(
              //   height: 30.0,
              // ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
                width: width * 0.9,
                height: 50.0,
                child: TextFormField(
                  autocorrect: false,
                  autofocus: false,
                  onSaved: (val) => _formData['subject'] = val,
                  decoration: InputDecoration(
                      // hint:'Your e-mail'
                      hintText: 'Subject',
                      border: InputBorder.none),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Subject can not be empty';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
                width: width * 0.9,
                height: 200.0,
                child: TextFormField(
                  autocorrect: false,
                  maxLines: 10,
                  // controller: ,
                  autofocus: false,
                  onSaved: (val) => _formData['message'] = val,
                  decoration: InputDecoration(
                      // hint:'Your e-mail'
                      hintText: 'Message',
                      border: InputBorder.none),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Message can not be empty';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
                width: width * 0.9,
                height: 50.0,
                child: OutlineButton.icon(
                  icon: Icon(Icons.send),
                  label: Text('Send'),
                  color: Colors.white,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _formKey.currentState.save();

                      // bool message = await sendMail();
                      // print(message);
                      Fluttertoast.showToast(
                          msg: "Thank You, Your Message is sent",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIos: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);

                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:goodvibes/widgets/webview.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: AboutUs(),
        // ),
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            // leading: Container(),
            backgroundColor: Color.fromRGBO(23, 3, 40, 1),
            floating: false,
            pinned: true,
            forceElevated: false,
            flexibleSpace: Container(
              width: double.infinity,
              // height: 160.0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'ABOUT US',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: MyWebView(
        url: "https://goodvibesofficial.com/about-us/",
      ),
//      body:  body==''?Center(child:CupertinoActivityIndicator()): SingleChildScrollView(
//        child: Padding(
//          padding: const EdgeInsets.all(14.0),
//          child: Html(data:body),
//        ),
//      ),
    ));
  }
}

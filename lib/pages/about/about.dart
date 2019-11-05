import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../config.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  Dio dio = Dio();
  String  body ='';
  getPageData() async {
    Response response = await dio.get('$baseUrl/v1/pages/about_us',
        options: Options(
          headers: {'Authorization': authorization},
        ));
    setState(() {
      // title = response.data['title'];
      body = response.data['description']??'';
    });
  }

  @override
  void initState() {
    getPageData();
    super.initState();
  }

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
            backgroundColor: Colors.transparent,
            expandedHeight: 160.0,
            floating: false,
            pinned: true,
            flexibleSpace: Container(
              width: double.infinity,
              // height: 160.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg1.png'),
                    fit: BoxFit.cover),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'ABOUT US',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body:  body==''?Center(child:CupertinoActivityIndicator()): SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Html(data:body),
        ),
      ),
    ));
  }
}

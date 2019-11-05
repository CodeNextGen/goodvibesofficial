import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
// import '../../config.dart';

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  Dio dio = Dio();
  String title = '',
      body =
          '''Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.

The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.''';
  // getPageData() async {
  //   Response response = await dio.get('$base_url/v1/pages/about_us',
  //       options: Options(
  //         headers: {'Authorization': authorization},
  //       ));
  //   setState(() {
  //     title = response.data['title'];
  //     body = response.data['description']??'';
  //   });
  // }

  @override
  void initState() {
    // getPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: PrivacyPolicy(),
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
                    'Privacy Policy',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Text(
            body,
            style: TextStyle(fontSize: 16.0, color: Color(0xFF86878B)),
          ),
        ),
      ),
    ));
  }
}

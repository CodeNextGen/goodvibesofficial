import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:goodvibes/locator.dart';
import 'package:goodvibes/providers.dart/startup_provider.dart';
import 'package:goodvibes/widgets/webview.dart';
import 'package:goodvibes/models/faq_model.dart';

class FaqPage extends StatefulWidget {
  @override
  _FaqPageState createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        'FAQ',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
    body: MyWebView(url: "https://www.atlassian.com/licensing/purchase-licensing#trials",),
//          body: Container(
//            child: faqs.length > 1
//                ? ListView.builder(
//                    itemCount: faqs.length,
//                    itemBuilder: (BuildContext context, int index) {
//                      return Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: Container(
//                          color: Color(0xFFeaf2ff),
//                          child: ExpansionTile(
//                            trailing: Icon(
//                              Icons.arrow_drop_down,
//                              color: Color(0xFF3f3fb6),
//                            ),
//                            backgroundColor: Color(0xFFeaf2ff),
//                            title: Text(
//                              faqs[index].title,
//                              style: TextStyle(
//                                  fontWeight: FontWeight.bold,
//                                  color: Colors.black,
//                                  fontSize: 16.0),
//                            ),
//                            children: <Widget>[
//                              Html(
//                                data: faqs[index].content,
//                                onLinkTap: (url) async {
//                                  if (await canLaunch(url)) {
//                                    await launch(url);
//                                  } else {
//                                    throw 'Could not launch $url';
//                                  }
//                                },
//                              ),
//                            ],
//                          ),
//                        ),
//                      );
//                    },
//                  )
//                : Center(
//                    child: CupertinoActivityIndicator(),
//                  ),
//          )),
      ),
    );
  }

  Future<bool> checkConnection() async{
    await locator<StartupProvider>().checkConnectivity();
    bool network =  locator<StartupProvider>().networkStatus;
    return network;
  }
}

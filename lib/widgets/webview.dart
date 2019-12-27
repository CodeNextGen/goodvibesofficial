import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MyWebView extends StatelessWidget{
  final String url;

  MyWebView({
    this.url
});
  @override
  Widget build(BuildContext context) {
    return new WebviewScaffold(
      url: url,
      withJavascript: true,
      hidden: true,
      withLocalStorage: true,
      initialChild: Container(
        child: new Center(
          child: new Container(
            margin: const EdgeInsets.all(20),
            child: CupertinoActivityIndicator(),
          ),
        ),
      ),
    );
  }

}
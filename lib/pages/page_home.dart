import 'dart:async';

import 'package:flutter/material.dart';
import 'package:santri_app/progress_hud.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PageHome extends StatefulWidget {
  PageHome({
    Key key,
  }) : super(key: key);

  @override
  PageHomeState createState() => PageHomeState();
}

class PageHomeState extends State<PageHome> {
  bool _isLoading = true;
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Stack(
        children: <Widget>[
          WebView(
            initialUrl: "https://santriasyik.com/",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              controller.complete(webViewController);
            },
            onPageFinished: pageFinishedLoading,
          ),
        ],
      ),
      inAsyncCall: _isLoading,
      opacity: 0.0,
    );
  }

  void pageFinishedLoading(String url) {
    setState(() {
      _isLoading = false;
    });
  }
}

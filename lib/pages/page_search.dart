import 'dart:async';

import 'package:flutter/material.dart';
import 'package:santri_app/progress_hud.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PageSearch extends StatefulWidget {
  PageSearch({Key key}) : super(key: key);

  @override
  _PageSearchState createState() => _PageSearchState();
}

class _PageSearchState extends State<PageSearch> {
  bool _isLoading = true;
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Stack(
        children: <Widget>[
          WebView(
            initialUrl: "https://www.santriasyik.com/p/search.html",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              controller.complete(webViewController);
            },
            onPageFinished: pageFinishedLoading,
          )
        ],
      ),
      inAsyncCall: _isLoading,
      opacity: 0.0,
    );
  }

  void pageFinishedLoading(String url) {
    _isLoading = false;
  }
}

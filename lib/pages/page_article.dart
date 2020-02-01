import 'dart:async';

import 'package:flutter/material.dart';
import 'package:santri_app/progress_hud.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PageArticle extends StatefulWidget {
  PageArticle({Key key}) : super(key: key);

  @override
  _PageArticleState createState() => _PageArticleState();
}

class _PageArticleState extends State<PageArticle> {
  bool _isLoading = true;
  final Completer<WebViewController> controller =
      Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Stack(
        children: <Widget>[
          WebView(
            initialUrl: "https://www.santriasyik.com/p/article.html",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              controller.complete(webViewController);
            },
            onPageFinished: pageFinishLoading,
          )
        ],
      ),
      inAsyncCall: _isLoading,
      opacity: 0.0,
    );
  }

  void pageFinishLoading(String url) {
    setState(() {
      _isLoading = false;
    });
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'dart:async';

import 'package:workflow_manager/base/ui/loading_dialog.dart';
import 'package:workflow_manager/workflow/models/event/next_n_back_file_event.dart';
import 'package:workflow_manager/workflow/models/event/reload_web_event.dart';

import '../../../../main.dart';

class ViewItemFile extends StatefulWidget {
  String url;
  String viewUrl;
  String html;
  String title;
  bool isFirstPage = false;
  bool isEndPage = false;

  ViewItemFile(
      {this.url,
      this.title,
      this.isFirstPage,
      this.isEndPage,
      this.viewUrl,
      this.html});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ViewItemFile();
  }
}

class _ViewItemFile extends State<ViewItemFile> with AutomaticKeepAliveClientMixin{
  double webViewHeight;
  WebViewController _webViewController;
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    eventBus.on<ReloadWebEvent>().listen((event) {
      if (event.page == null || event.page == widget)
      this._webViewController.reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            child: WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: '${AppUrl.url_google_doc}${this.widget.url}',
              onWebViewCreated: (WebViewController webViewController) {
                _webViewController = webViewController;
                // _controller.complete(webViewController);
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) async {
                print('Page finished loading: $url');
                // if (_webViewController != null) {
                //   webViewHeight = double.tryParse(
                //     await _webViewController
                //         .evaluateJavascript("document.documentElement.scrollHeight;"),
                //   );
                //   setState(() {});
                // }
              },
              onWebResourceError: (error) {
                print("loading error: ${error}");
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

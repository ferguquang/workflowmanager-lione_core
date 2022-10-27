import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/ui/webview_screen.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/manager/widgets/profile_view.dart';
import 'package:workflow_manager/procedures/widgets/pdf/lazy_image_provider.dart';
import 'package:workflow_manager/procedures/widgets/photoview/photo_view_gallery.dart';
import 'package:workflow_manager/workflow/models/event/next_n_back_file_event.dart';
import 'package:workflow_manager/workflow/models/event/reload_web_event.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/file_response.dart';
import 'package:workflow_manager/workflow/screens/details/view_list_files/view_item_file.dart';

import '../../../../main.dart';

class ViewListFiles extends StatefulWidget {
  List<Widget> listFiles = [];
  List<FileModel> files = [];
  int index = 0;

  ViewListFiles({this.listFiles, this.index, this.files});

  @override
  State<StatefulWidget> createState() {
    return _ViewListFiles();
  }
}

class _ViewListFiles extends State<ViewListFiles> {
  PageController _pageController = PageController(keepPage: false);
  List<ViewItemFile> listFiles = [];
  int currentPage;
  double webViewHeight = 100;
  List<String> images = ["JPG", "JPEG", "PNG", "BMP"];
  PdfDocument _pdfDocument;

  void onLoadImageState(int index, bool isComplete) {}

  openPdf(ViewItemFile file) async {
    if (isNullOrEmpty(file.viewUrl) ||
        !file.viewUrl.toUpperCase().endsWith("PDF")) {
      return;
    }
    var status = await Permission.storage.status;
    if (status.isUndetermined) {
      await Permission.storage.request();
    }
    String fileName = "a.pdf";
    if (isNotNullOrEmpty(file.viewUrl)) {
      fileName = file.viewUrl.substring(file.viewUrl.lastIndexOf("/") + 1);
    }
    String localFile = await FileUtils.instance.downloadFileAndOpen(
        fileName, file.viewUrl, context,
        isOpenFile: false, isShowSuccess: false);

    if (localFile != null) {
      _pdfDocument?.close();
      _pdfDocument = await PdfDocument.openFile(localFile);
    } else {
      showErrorToast("Download ${file.viewUrl} error");
    }
    _pageController = PageController(keepPage: false);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    this.currentPage = this.widget.index;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    // this.controller = PageController(
    //     initialPage: this.widget.index, keepPage: true, viewportFraction: 1.0);
    _reloadPage();
  }

  _reloadPage() {
    setState(() {
      this.listFiles = this.widget.listFiles;
      openPdf(listFiles[currentPage]);
    });
  }

  void next_n_back_page(bool isNext) {
    if (isNext) {
      if (currentPage == this.listFiles.length - 1) {
        return;
      }
      currentPage = currentPage + 1;
      // this.controller.jumpToPage(currentPage);
    } else {
      if (currentPage == 0) {
        return;
      }
      currentPage = currentPage - 1;
      // this.controller.jumpToPage(currentPage);
    }
    ViewItemFile file = this.listFiles[currentPage];
    setState(() {
      if (isImage()) {
      } else if (isNullOrEmpty(file.viewUrl)) {
        if (!isImage())
          _webViewController.loadUrl('${AppUrl.url_google_doc}${file.url}');
      } else {
        openPdf(this.listFiles[currentPage]);
      }
    });
  }

  WebViewController _webViewController;

  bool isImage() {
    for (String ex in images) {
      if (listFiles[currentPage].title.toUpperCase().endsWith(ex)) {
        return true;
      }
    }
    return false;
  }

  int count = 0;

  Widget _getPhotoView() {
    if (isNullOrEmpty(listFiles[currentPage].viewUrl)) {
      return WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl:
            '${AppUrl.url_google_doc}${Uri.encodeFull(this.listFiles[currentPage].url)}',
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
          // _controller.complete(webViewController);
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
          ApiCaller.instance.showLoading();
        },
        onPageFinished: (String url) async {
          print('Page finished loading: $url');
          ApiCaller.instance.hideLoading();
        },
        onWebResourceError: (error) {
          print("loading error: ${error}");
        },
      );
    }
    if (!listFiles[currentPage].viewUrl.toUpperCase().endsWith("PDF")) {
      return Center(
        child: Text("Không thể hiển thị định dạng này, vui lòng tải về máy"),
      );
    }
    return new PhotoViewGallery.builder(
      key: Key("${count++}"),
      backgroundDecoration: BoxDecoration(color: Colors.white),
      pageController: _pageController,
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
          index: index,
          imageProvider: LazyImageProvider(
              index + 1, _pdfDocument, context, onLoadImageState),
        );
      },
      itemCount: _pdfDocument?.pagesCount ?? 0,
      loadingBuilder: (context, progress) => Center(
        child: Container(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Danh sách tài liệu đính kèm",
        ),
        actions: [
          InkWell(
            onTap: () async {
              if (_webViewController != null)
                _webViewController.reload();
              else if (isImage()) {
                setState(() {});
              } else {
                openPdf(listFiles[currentPage]);
              }
            },
            child: Container(
              margin: EdgeInsets.all(6),
              child: Icon(Icons.refresh),
            ),
          ),
          InkWell(
            onTap: () async {
              FileModel file = this.widget.files[this.currentPage];
              FileUtils.instance
                  .downloadFileAndOpen(file.name, file.path, context);
            },
            child: Container(
              margin: EdgeInsets.all(6),
              child: Icon(Icons.file_download),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Row(
                children: <Widget>[
                  Opacity(
                    opacity: (currentPage == 0) ? 0.0 : 1.0,
                    child: RaisedButton(
                      color: Colors.white,
                      highlightColor: Colors.white,
                      highlightElevation: 0,
                      elevation: 0,
                      child: Icon(
                        Icons.arrow_back,
                        size: 32,
                      ),
                      onPressed: () {
                        this.next_n_back_page(false);
                      },
                    ),
                  ),
                  Expanded(
                    child: Text(
                      this.widget.files[this.currentPage].name,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Opacity(
                    opacity: (currentPage == this.widget.files.length - 1)
                        ? 0.0
                        : 1.0,
                    child: RaisedButton(
                      highlightColor: Colors.white,
                      highlightElevation: 0,
                      color: Colors.white,
                      elevation: 0,
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 32,
                      ),
                      onPressed: () {
                        this.next_n_back_page(true);
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
              ),
              Expanded(
                  child: isImage()
                      ? Html(
                          data: """<!DOCTYPE html>
<html>
<head>
<title>Page Title</title>
</head>
<style> img { display: block; max-width: 100%; height: auto; } </style>
<body>

<img src="${isNullOrEmpty(this.listFiles[currentPage].viewUrl) ? this.listFiles[currentPage].url : this.listFiles[currentPage].viewUrl}"/>

</body>
</html>""",
                        )
                      : _getPhotoView()
                  // : WebView(
                  //     javascriptMode: JavascriptMode.unrestricted,
                  //     initialUrl:
                  //         '${AppUrl.url_google_doc}${Uri.encodeFull(this.listFiles[currentPage].url)}',
                  //     onWebViewCreated:
                  //         (WebViewController webViewController) {
                  //       _webViewController = webViewController;
                  //       // _controller.complete(webViewController);
                  //     },
                  //     onPageStarted: (String url) {
                  //       print('Page started loading: $url');
                  //       ApiCaller.instance.showLoading();
                  //     },
                  //     onPageFinished: (String url) async {
                  //       print('Page finished loading: $url');
                  //       ApiCaller.instance.hideLoading();
                  //     },
                  //     onWebResourceError: (error) {
                  //       print("loading error: ${error}");
                  //     },
                  //   ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}

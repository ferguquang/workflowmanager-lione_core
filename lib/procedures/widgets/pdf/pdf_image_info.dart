import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/procedures/widgets/photoview/src/controller/photo_view_controller.dart';

class PdfImageInfo {
  int index;
  GlobalKey key;
  PhotoViewControllerBase controller;

  PdfImageInfo({this.index, this.key, this.controller});
}

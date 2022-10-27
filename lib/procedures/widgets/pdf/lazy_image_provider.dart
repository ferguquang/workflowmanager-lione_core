import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:synchronized/synchronized.dart';
typedef OnLoadState=void Function(int index, bool isComplete) ;

@immutable
class LazyImageProvider extends ImageProvider<LazyImageProvider> {
  int pageNum;
  PdfDocument pdfDocument;
  BuildContext context;
  OnLoadState onLoadState;
  LazyImageProvider(this.pageNum, this.pdfDocument, this.context,this.onLoadState);

  @override
  Future<LazyImageProvider> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<LazyImageProvider>(this);
  }

  static var lock = new Lock();

  @override
  ImageStreamCompleter load(LazyImageProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: lock.synchronized(() async {
        return _loadAsync(key, decode, pdfDocument, pageNum,onLoadState);
      }),
      scale: 1,
      debugLabel: "Page $pageNum",
      informationCollector: () sync* {
        yield ErrorDescription('Page $pageNum');
      },
    );
  }

  static bool isRunning = false;
  static final Map<int, Uint8List> _pages = {};

  static Future<ui.Codec> _loadAsync(LazyImageProvider key,
      DecoderCallback decode, PdfDocument pdfDocument, int pageNum,OnLoadState onLoadState) async {
    PdfPage page = await pdfDocument.getPage(pageNum);
    PdfPageImage image = await page.render(
        width: page.width, height: page.height, format: PdfPageFormat.JPEG);
    await page.close();
    final Uint8List bytes = image.bytes;
    if (bytes.lengthInBytes == 0) {
      PaintingBinding.instance.imageCache.evict(key);
      throw StateError(
          'Page $pageNum is empty and cannot be loaded as an image.');
    }
    onLoadState(pageNum-1,true);
    var result = await decode(bytes);
    return result;
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is LazyImageProvider && other.pageNum == pageNum;
  }

  @override
  int get hashCode => hashValues(pdfDocument.id, pageNum);
}

// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:native_pdf_renderer/native_pdf_renderer.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:workflow_manager/base/ui/toast_view.dart';
// import 'package:workflow_manager/base/utils/base_sharepreference.dart';
// import 'package:workflow_manager/base/utils/common_function.dart';
// import 'package:workflow_manager/base/utils/file_utils.dart';
// import 'package:workflow_manager/procedures/models/response/data_signature_list_response.dart';
// import 'package:workflow_manager/procedures/models/response/file_template.dart';
// import 'package:workflow_manager/procedures/widgets/pdf/pdf_provider.dart';
// import 'package:workflow_manager/procedures/widgets/photoview/photo_view_gallery.dart';
// import 'package:workflow_manager/procedures/widgets/photoview/src/controller/photo_view_controller.dart';
// import 'package:workflow_manager/procedures/widgets/photoview/src/photo_view_computed_scale.dart';
// import 'package:workflow_manager/procedures/widgets/photoview/src/utils/photo_view_hero_attributes.dart';
// import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
// import 'package:workflow_manager/procedures/widgets/pick_signal/pick_signal_screen.dart';
//
// import 'lazy_image_provider.dart';
//
// class SignalScreen extends StatefulWidget {
//   FileTemplate signalFile;
//   int idHoso;
//
//   void setKey(GlobalKey photoKey, PhotoViewController controller) {
//     ((key as GlobalKey).currentState as _PageState)
//         .onChangingPage(photoKey, controller);
//     log(["setkey"]);
//   }
//
//   SignalScreen(this.signalFile, this.idHoso) : super(key: GlobalKey());
//
//   @override
//   _PageState createState() => _PageState();
// }
//
// class _PageState extends State<SignalScreen> {
//   FileTemplate signalFile;
//   PdfDocument _pdfDocument;
//   var defaultProvider = AssetImage("assets/images/test.png");
//   PdfRepository _pdfRepository = PdfRepository();
//   double startX, startY;
//   double top, left, bottom, right;
//   double topPdf, leftPdf, bottomPdf, rightPdf;
//   double width, height;
//   double squareSize = 15;
//   double _touchSquareSize = 45;
//   double wrapperWidth = 30;
//   double wrapperHeight = 30;
//   IconData squareIcon = Icons.crop_square;
//
//   static const int FLAG_NONE = -1;
//   static const int FLAG_MOVE = 0;
//   static const int FLAG_TOP_LEFT = 1;
//   static const int FLAG_TOP_RIGHT = 2;
//   static const int FLAG_BOTTOM_LEFT = 3;
//   static const int FLAG_BOTTOM_RIGHT = 4;
//   int flag = 0;
//   GlobalKey _signalKey = GlobalKey();
//   GlobalKey _photoKey;
//   GlobalKey _changingPhotoKey;
//   GlobalKey _keyWrapper = GlobalKey();
//   bool _isPageChanging;
//   Image image;
//   double ratioWidthHeight = 0;
//   double maxSize = 100.0;
//   PageController _pageController = PageController();
//   PhotoViewController _photoViewController;
//   PhotoViewController _changingPhotoViewController;
//   double previewPage = -1;
//   bool isDefaultSignal;
//   Signatures _signatures;
//   DataSignatureList _dataSignatureList;
//   double _pickImageX;
//   double _pickImageY;
//
//   @override
//   void initState() {
//     super.initState();
//     signalFile = widget.signalFile;
//     openPdf();
//
//     _pageController.addListener(() {
//       if (_pageController.offset % _keyWrapper.currentContext.size.width <= 1) {
//         // _isPageChanging = false;
//         if (_changingPhotoKey != null &&
//             previewPage.toInt() != _pageController.page.toInt()) {
//           _photoViewController = _changingPhotoViewController;
//           _photoKey = _changingPhotoKey;
//         }
//         previewPage = _pageController.page;
//       }
//     });
//   }
//
//   bool isFirst = true;
//
//   onChangingPage(GlobalKey photoKey, PhotoViewController controller) {
//     log([_photoKey, _photoKey]);
//     if (_photoKey == null) {
//       _photoKey = photoKey;
//       _photoViewController = controller;
//     } else {
//       _changingPhotoKey = photoKey;
//       _changingPhotoViewController = controller;
//       if (isFirst) {
//         _photoKey = photoKey;
//         _photoViewController = controller;
//       }
//     }
//   }
//
//   loadImage(String url) {
//     image = Image.network(url);
//     image.image
//         .resolve(new ImageConfiguration())
//         .addListener(ImageStreamListener((ImageInfo info, bool isSuccess) {
//       ratioWidthHeight = info.image.width.toDouble() / info.image.height;
//       double width, height;
//       if (ratioWidthHeight > 1) {
//         width = maxSize;
//         height = maxSize / ratioWidthHeight;
//       } else {
//         height = maxSize;
//         width = maxSize * ratioWidthHeight;
//       }
//       _pdfRepository.changeSize(width, height);
//       _pdfRepository.showSignal();
//     }));
//   }
//
//   bool isLoadCompleted = false;
//
//   void onLoadImageState(int index, bool isComplete) {
//     if (index == _pageController.page) {
//       isLoadCompleted = isComplete;
//     }
//   }
//
//   openPdf() async {
//     var status = await Permission.storage.status;
//     if (status.isUndetermined) {
//       await Permission.storage.request();
//     }
//     String path =
//         await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY) +
//             signalFile.signPath;
//     var file = await FileUtils.instance.downloadFile(path, signalFile.name);
//     if (file != null)
//       _pdfDocument = await PdfDocument.openFile(file);
//     else {
//       showErrorToast("Download file error");
//     }
//     setState(() {});
//   }
//
//   goToPage(int page) {
//     if (_pdfDocument != null) _pageController.jumpToPage(page);
//   }
//
//   pickSignal(bool isDefaultSignal) async {
//     if (_pdfRepository.signalVisible) {
//       showErrorToast("Chỉ được chọn một chữ ký.");
//       return;
//     }
//     this.isDefaultSignal = isDefaultSignal;
//     if (_pdfDocument?.pagesCount == null) {
//       showErrorToast("Chưa mở xong file!");
//       return;
//     }
//     _dataSignatureList = await pushPage(
//         context,
//         PickSignalScreen(
//             widget.idHoso,
//             signalFile.iD,
//             _pdfDocument?.pagesCount ?? 0,
//             _pageController.page.toInt() + 1,
//             goToPage));
//     if (_dataSignatureList.pickIndex != null) {
//       _signatures = _dataSignatureList.signatures[_dataSignatureList.pickIndex];
//       await loadImage(
//           await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY) +
//               _signatures.filePath);
//       if (isDefaultSignal) {
//         // _pdfRepository
//       } else {
//         _pdfRepository.changePosistion(
//             _pickImageX - _touchSquareSize - _pdfRepository.width / 2,
//             _pickImageY - _touchSquareSize - _pdfRepository.height / 2);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Chữ ký"),
//           actions: [
//             InkWell(
//                 onTap: () {
//                   pickSignal(true);
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Icon(Icons.edit),
//                 ))
//           ],
//         ),
//         body: MultiProvider(
//           key: _keyWrapper,
//           providers: [ChangeNotifierProvider.value(value: _pdfRepository)],
//           child: Stack(children: [
//             _pdfDocument == null
//                 ? Text("Loading")
//                 : InkWell(
//                     onTap: () {
//                       pickSignal(false);
//                     },
//                     onTapDown: (details) {
//                       _pickImageX = details.localPosition.dx;
//                       _pickImageY = details.localPosition.dy;
//                     },
//                     child: PhotoViewGallery.builder(
//                       pageController: _pageController,
//                       scrollPhysics: const BouncingScrollPhysics(),
//                       backgroundDecoration: BoxDecoration(color: Colors.white),
//                       builder: (BuildContext context, int index) {
//                         if (_isPageChanging == null)
//                           _isPageChanging = false;
//                         else
//                           _isPageChanging = true;
//                         return PhotoViewGalleryPageOptions(
//                           index: index,
//                           imageProvider: LazyImageProvider(index + 1,
//                               _pdfDocument, context, onLoadImageState),
//                           initialScale: PhotoViewComputedScale.contained,
//                           minScale: PhotoViewComputedScale.contained,
//                           maxScale: PhotoViewComputedScale.covered * 5.0,
//                           heroAttributes: PhotoViewHeroAttributes(tag: index),
//                         );
//                       },
//                       itemCount: _pdfDocument.pagesCount,
//                       loadingBuilder: (context, progress) => Center(
//                         child: Container(
//                           width: 20.0,
//                           height: 20.0,
//                           child: CircularProgressIndicator(),
//                         ),
//                       ),
//                     ),
//                   ),
//             Consumer(
//               builder: (context, PdfRepository pdfProvider, child) {
//                 return Visibility(
//                   visible: pdfProvider.signalVisible,
//                   child: Positioned(
//                     top: _pdfRepository.top,
//                     left: _pdfRepository.left,
//                     child: GestureDetector(
//                       onPanDown: onPanDown,
//                       onPanUpdate: onPanUpdate,
//                       onPanEnd: (details) {
//                         flag = FLAG_NONE;
//                       },
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               _buildSquare(Alignment.bottomRight),
//                               Container(
//                                 width: _pdfRepository.width,
//                               ),
//                               _buildSquare(Alignment.bottomLeft),
//                             ],
//                           ),
//                           Stack(
//                             alignment: Alignment.topRight,
//                             children: [
//                               image == null
//                                   ? Container()
//                                   : Image(
//                                       image: image?.image,
//                                       height: _pdfRepository.height,
//                                       key: _signalKey,
//                                       width: _pdfRepository.width,
//                                       fit: BoxFit.fill,
//                                     ),
//                               InkWell(
//                                 child: Icon(Icons.close),
//                                 onTap: () {
//                                   ConfirmDialogFunction dialog =
//                                       ConfirmDialogFunction(
//                                           context: context,
//                                           onAccept: () {
//                                             pdfProvider.hideSignal();
//                                           },
//                                           content:
//                                               "Bạn có muốn xóa chữ ký này?");
//                                   dialog.showConfirmDialog();
//                                 },
//                               )
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               _buildSquare(Alignment.topRight),
//                               Container(
//                                 width: _pdfRepository.width,
//                               ),
//                               _buildSquare(Alignment.topLeft)
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             )
//           ]),
//         ));
//   }
//
//   void onPanDown(DragDownDetails details) {
//     if (isLoadCompleted == false) return;
//     startX = details.globalPosition.dx;
//     startY = details.globalPosition.dy;
//     top = _pdfRepository.top;
//     left = _pdfRepository.left;
//     height = _pdfRepository.height;
//     width = _pdfRepository.width;
//     if (_photoKey == null) {
//       topPdf = 0;
//       leftPdf = 0;
//       rightPdf = MediaQuery.of(context).size.width;
//       bottomPdf = MediaQuery.of(context).size.height;
//     } else {
//       RenderBox renderBox = _photoKey.currentContext.findRenderObject();
//       RenderBox renderBoxWrapper =
//           _keyWrapper.currentContext.findRenderObject();
//       Offset topLeft = renderBox.localToGlobal(Offset.zero);
//       Offset topLeftWrapper = renderBoxWrapper.localToGlobal(Offset.zero);
//       log(["ngon lanh ", topLeftWrapper.dy, topLeft.dy]);
//       topPdf = topLeft.dy - topLeftWrapper.dy;
//       leftPdf = topLeft.dx - topLeftWrapper.dx;
//       bottomPdf = topPdf + renderBox.size.height * _photoViewController.scale;
//       rightPdf = leftPdf + renderBox.size.width * _photoViewController.scale;
//       log([
//         leftPdf,
//         topPdf,
//         rightPdf,
//         bottomPdf,
//         topPdf + bottomPdf,
//         leftPdf + rightPdf
//       ]);
//       log([
//         "ffff",
//         MediaQuery.of(context).padding.top,
//         kToolbarHeight,
//         renderBox.size.width * _photoViewController.scale,
//         renderBox.size.height * _photoViewController.scale,
//         MediaQuery.of(context).size.width,
//         MediaQuery.of(context).size.height
//       ]);
//     }
//
//     wrapperHeight = _keyWrapper.currentContext.size.height;
//     wrapperWidth = _keyWrapper.currentContext.size.width;
//     RenderBox renderBox = _signalKey.currentContext.findRenderObject();
//     right = left + renderBox.size.width;
//     bottom = top + renderBox.size.height;
//     flag = FLAG_MOVE;
//     if (isTopLeft(startX, startY)) {
//       flag = FLAG_TOP_LEFT;
//     } else if (isTopRight(startX, startY)) {
//       flag = FLAG_TOP_RIGHT;
//     } else if (isBottomLeft(startX, startY)) {
//       flag = FLAG_BOTTOM_LEFT;
//     } else if (isBottomRight(startX, startY)) {
//       flag = FLAG_BOTTOM_RIGHT;
//     }
//   }
//
//   void onPanUpdate(DragUpdateDetails details) {
//     if (!isLoadCompleted) return;
//     double dx = details.globalPosition.dx - startX;
//     double dy = details.globalPosition.dy - startY;
//     double topSignal, leftSignal, heightSignal, widthSignal;
//     double ratio = 1;
//     switch (flag) {
//       case FLAG_MOVE:
//         {
//           topSignal = top + dy;
//           leftSignal = left + dx;
//           if (topSignal + _touchSquareSize < 0) topSignal = -_touchSquareSize;
//           if (topSignal + (bottom - top) + _touchSquareSize > wrapperHeight)
//             topSignal = wrapperHeight - (bottom - top) - _touchSquareSize;
//           if (topSignal + _touchSquareSize < topPdf)
//             topSignal = topPdf - _touchSquareSize;
//           if (topSignal + (bottom - top) + _touchSquareSize > bottomPdf)
//             topSignal = bottomPdf - (bottom - top) - _touchSquareSize;
//
//           if (leftSignal + _touchSquareSize < 0) leftSignal = -_touchSquareSize;
//           if (leftSignal + (right - left) + _touchSquareSize > wrapperWidth)
//             leftSignal = wrapperWidth - (right - left) - _touchSquareSize;
//           if (leftSignal + _touchSquareSize < leftPdf)
//             leftSignal = leftPdf - _touchSquareSize;
//           if (leftSignal + (right - left) + _touchSquareSize > rightPdf)
//             leftSignal = rightPdf - (right - left) - _touchSquareSize;
//
//           _pdfRepository.changePosistion(leftSignal, topSignal);
//           break;
//         }
//       case FLAG_TOP_LEFT:
//         {
//           widthSignal = width - dx;
//           heightSignal = height - dy;
//           if (widthSignal < 1) widthSignal = 1;
//           if (heightSignal < 1) heightSignal = 1;
//           ratio = widthSignal / heightSignal;
//           if (ratio > ratioWidthHeight) {
//             widthSignal = heightSignal * ratioWidthHeight;
//           } else {
//             heightSignal = widthSignal / ratioWidthHeight;
//           }
//           topSignal = bottom - heightSignal;
//           leftSignal = right - widthSignal;
//           break;
//         }
//       case FLAG_TOP_RIGHT:
//         {
//           widthSignal = width + dx;
//           heightSignal = height - dy;
//           if (widthSignal < 1) widthSignal = 1;
//           if (heightSignal < 1) heightSignal = 1;
//           ratio = widthSignal / heightSignal;
//           if (ratio > ratioWidthHeight) {
//             widthSignal = heightSignal * ratioWidthHeight;
//           } else {
//             heightSignal = widthSignal / ratioWidthHeight;
//           }
//           topSignal = bottom - heightSignal;
//           leftSignal = left;
//           break;
//         }
//       case FLAG_BOTTOM_LEFT:
//         {
//           widthSignal = width - dx;
//           heightSignal = height + dy;
//           if (widthSignal < 1) widthSignal = 1;
//           if (heightSignal < 1) heightSignal = 1;
//           ratio = widthSignal / heightSignal;
//           if (ratio > ratioWidthHeight) {
//             widthSignal = heightSignal * ratioWidthHeight;
//           } else {
//             heightSignal = widthSignal / ratioWidthHeight;
//           }
//           topSignal = top;
//           leftSignal = right - widthSignal;
//           break;
//         }
//       case FLAG_BOTTOM_RIGHT:
//         {
//           widthSignal = width + dx;
//           heightSignal = height + dy;
//           if (widthSignal < 1) widthSignal = 1;
//           if (heightSignal < 1) heightSignal = 1;
//           ratio = widthSignal / heightSignal;
//           if (ratio > ratioWidthHeight) {
//             widthSignal = heightSignal * ratioWidthHeight;
//           } else {
//             heightSignal = widthSignal / ratioWidthHeight;
//           }
//           topSignal = top;
//           leftSignal = left;
//           break;
//         }
//     }
//     if (flag != FLAG_MOVE) {
//       _pdfRepository.changeSizeAndPosition(
//           leftSignal, topSignal, widthSignal, heightSignal);
//     }
//   }
//
//   bool isTopLeft(double x, double y) {
//     RenderBox renderBox = _signalKey.currentContext.findRenderObject();
//     Offset position = renderBox.localToGlobal(Offset.zero);
//     double topSignal = position.dy;
//     double leftSignal = position.dx;
//     return x < leftSignal && y < topSignal;
//   }
//
//   bool isTopRight(double x, double y) {
//     RenderBox renderBox = _signalKey.currentContext.findRenderObject();
//     Offset position = renderBox.localToGlobal(Offset.zero);
//     double topSignal = position.dy;
//     double rightSignal = position.dx + renderBox.size.width;
//     return x > rightSignal && y < topSignal;
//   }
//
//   bool isBottomRight(double x, double y) {
//     RenderBox renderBox = _signalKey.currentContext.findRenderObject();
//     Offset position = renderBox.localToGlobal(Offset.zero);
//     double bottomSignal = position.dy + renderBox.size.height;
//     double rightSignal = position.dx + renderBox.size.width;
//     return x > rightSignal && y > bottomSignal;
//   }
//
//   bool isBottomLeft(double x, double y) {
//     RenderBox renderBox = _signalKey.currentContext.findRenderObject();
//     Offset position = renderBox.localToGlobal(Offset.zero);
//     double bottomSignal = position.dy + renderBox.size.height;
//     double leftSignal = position.dx;
//     return x < leftSignal && y > bottomSignal;
//   }
//
//   Widget _buildSquare(Alignment alignment) {
//     return GestureDetector(
//       child: Stack(alignment: alignment, children: [
//         Container(
//           width: _touchSquareSize,
//           height: _touchSquareSize,
//         ),
//         Align(
//           child: Container(
//             decoration: BoxDecoration(border: Border.all(color: Colors.black)),
//             width: squareSize,
//             height: squareSize,
//           ),
//         ),
//       ]),
//     );
//   }
// }
//
// log(List<dynamic> params) {
//   StringBuffer sb = StringBuffer();
//   for (dynamic obj in params) {
//     sb.write(obj?.toString());
//     sb.write(", ");
//   }
//   print("signal  ${sb.toString()}");
// }

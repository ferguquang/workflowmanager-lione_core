import 'dart:math';

import 'package:flutter/material.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/procedures/widgets/pdf/signal_widget/signal_info.dart';
import 'package:workflow_manager/procedures/widgets/pdf/signal_widget/signal_repository.dart';

import '../../../../base/ui/confirm_dialog_widget.dart';
import '../../../../base/utils/base_sharepreference.dart';
import '../../../models/response/data_signature_list_response.dart';
import '../../photoview/photo_view.dart';
import '../signal_screen.dart';

class SignalWidget extends StatefulWidget {
  Signatures signatures;
  GlobalKey keyWrapper;
  double ratioWidthHeight;
  double pickImageX;
  double pickImageY;
  SignatureLocation location;
  bool isDefaultSignal;
  Size pdfSize;
  int pageNum;
  bool isVisible = false;
  double scale;
  PhotoViewController photoViewController;
  GlobalKey photoKey;
  void Function(SignalWidget) deleteSignal;
  void Function(SignalWidget) onTap;
  int signPageFixPos;
  PdfDocument pdfDocument;
  PageController pageController;

  SignalWidget(
      {this.signatures,
      this.keyWrapper,
      this.location,
      this.isDefaultSignal,
      this.pdfSize,
      this.pickImageX = 0,
      this.pickImageY = 0,
      this.pageNum,
      this.scale,
      this.photoViewController,
      this.photoKey,
      this.signPageFixPos,
      this.deleteSignal,
      this.onTap,
      this.pdfDocument,
      this.pageController,
      GlobalKey key})
      : assert(deleteSignal != null),
        super(key: key ?? GlobalKey()) {}

  @override
  State<StatefulWidget> createState() {
    return SignalWidgetState();
  }
}

class SignalWidgetState extends State<SignalWidget> {
  int flag;
  Image image;
  GlobalKey _signalKey = GlobalKey();
  double _squareSize = 10;
  double _touchSquareSize = 45;
  double _paddingSquare = 20;
  double _maxSize = 70.0;
  bool _isLoadCompleted = false;
  SignalRepository _signalRepository;

  double _top;
  double _left;
  double _width;
  double _height;
  double _startX;
  double _startY;
  double _topPdf = 0;
  double _leftPdf = 0;
  double _topInPdf = 0;
  double _leftInPdf = 0;
  double _rightPdf;
  double _right;
  double _bottom;
  double _ratioWidthHeight;
  double _bottomPdf;
  double _wrapperHeight;
  double _wrapperWidth;
  double _pickImageX;
  double _pickImageY;

  double backupX;
  double backupY;

  double _pdfRatio;

  double _currentPdfWIdth;
  double _currentPdfHeight;

  GlobalKey _topRightSquareKey = GlobalKey();
  GlobalKey _topLeftSquareKey = GlobalKey();
  GlobalKey _bottomLeftSquareKey = GlobalKey();
  GlobalKey _bottomRightSquareKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _touchSquareSize = _paddingSquare + _squareSize;
    _pickImageX = widget.pickImageX;
    _pickImageY = widget.pickImageY;
    _signalRepository = SignalRepository(
        pageNum: widget.pageNum,
        touchSquareSize: _touchSquareSize,
        signPageFixPos: widget.signPageFixPos,
        signatures: widget.signatures);
    setSignalPath();
  }

  GlobalKey _getPhotoKey() {
    return widget.photoKey ??
        context.findAncestorStateOfType<SignalScreenState>().photoKey;
  }

  PhotoViewController _getPhotoViewController() {
    return widget.photoViewController ??
        context
            .findAncestorStateOfType<SignalScreenState>()
            .photoViewController;
  }

  double lastScale = 0;

  hide() {
    _signalRepository.hideSignal();
  }

  show() {
    _signalRepository.showSignal();
  }

  SignalInfo getSignalInfo() {
    return _signalRepository.signalInfo;
  }

  setSignalPath() async {
    // _signalRepository.changeSizeAndPosition(10, 10, 70, 70);
    // _signalRepository.showSignal();
    // _isLoadCompleted = true;
    // return;
    String signalPath =
        await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY) +
            widget.signatures.filePath;
    ApiCaller.instance.showLoading();
    image = Image.network(
      signalPath,
    );
    ImageStreamListener listener = ImageStreamListener(
      (ImageInfo info, bool isSuccess) {
        // RenderBox renderBox = _getPhotoKey().currentContext.findRenderObject();
        ApiCaller.instance.hideLoading();
        RenderBox renderBoxWrapper =
            widget.keyWrapper.currentContext.findRenderObject();
        if (widget.isDefaultSignal) {
          widget.pdfSize = _getLocalPdfSize();
          _ratioWidthHeight = widget.location.width / widget.location.height;
          _top = widget.location.pageHeight -
              widget.location.y -
              widget.location.height;
          _left = widget.location.x + widget.location.width / 2;
          double scale = widget.pdfSize.height / widget.location.pageHeight;
          _top = _top * scale;
          _left = _left * scale;
          _width = scale * widget.location.width;
          _height = scale * widget.location.height;
          _left -= _width / 2 + _touchSquareSize;
          _top += -_touchSquareSize +
              (renderBoxWrapper.size.height - widget.pdfSize.height) / 2;
        } else {
          _ratioWidthHeight = info.image.width.toDouble() / info.image.height;
          if (_ratioWidthHeight > 1) {
            _width = _maxSize;
            _height = _maxSize / _ratioWidthHeight;
          } else {
            _height = _maxSize;
            _width = _maxSize * _ratioWidthHeight;
          }
          _top = _pickImageY - _touchSquareSize - _height / 2;
          // _top = renderBox.localToGlobal(Offset.zero).dy-renderBoxWrapper.localToGlobal(Offset.zero).dy- _touchSquareSize;
          _left = _pickImageX - _touchSquareSize - _width / 2;
        }
        _pdfRatio = _getLocalPdfSize().width / _getLocalPdfSize().height;
        changeSizeAndPosition(_left, _top, _width, _height,
            scale: _getPhotoViewController().scale);
        Size pdfSize = _getLocalPdfSize();
        _signalRepository.pdfNotScaleHeight =
            pdfSize.height / _getPhotoViewController().scale;
        _signalRepository.pdfNotScaleWidth =
            pdfSize.width / _getPhotoViewController().scale;
        _signalRepository.showSignal();
        _isLoadCompleted = true;
      },
      onError: (exception, stackTrace) {
        ApiCaller.instance.hideLoading();
        showErrorToast('Tải chữ ký "${widget.signatures.name}" thất bại');
        if (widget.deleteSignal != null) {
          widget.deleteSignal(widget);
        }
      },
    );

    image.image.resolve(new ImageConfiguration()).addListener(listener);
  }

  fitScreen() {
    _getPhotoViewController().scale =
        widget.keyWrapper.currentContext.size.width / _currentPdfWIdth;
  }

  scale(double newScale) {
    Future.delayed(Duration(seconds: 0)).then((value) {
      if (!_isLoadCompleted || _getPhotoKey().currentContext == null) return;
      RenderBox renderBox = _getPhotoKey().currentContext.findRenderObject();
      RenderBox renderBoxWrapper =
          widget.keyWrapper.currentContext.findRenderObject();
      _currentPdfHeight = renderBox.size.height;
      _currentPdfWIdth = renderBox.size.width;
      double top, left, width, height;
      top = _topInPdf * newScale +
          renderBox.localToGlobal(Offset.zero).dy -
          renderBoxWrapper.localToGlobal(Offset.zero).dy -
          _touchSquareSize;
      left = _leftInPdf * newScale +
          renderBox.localToGlobal(Offset.zero).dx -
          renderBoxWrapper.localToGlobal(Offset.zero).dx -
          _touchSquareSize;
      width = newScale * _signalRepository.signalNotScaleWidth;
      height = newScale * _signalRepository.signalNotScaleHeight;
      changeSizeAndPosition(left, top, width, height);
      lastScale = newScale;
      setFitPositionAndSize();
    });
    _pdfRatio = newScale;
  }

  setFitPositionAndSize() {
    RenderBox renderBoxWrapper =
        widget.keyWrapper.currentContext.findRenderObject();
    double newScale =
        renderBoxWrapper.size.width / _signalRepository.pdfNotScaleWidth;
    double top, left, width, height;
    Size pdfSize = _getLocalPdfSize();
    double pdfWidth = renderBoxWrapper.size.width;
    double pdfHeight =
        renderBoxWrapper.size.width * pdfSize.height / pdfSize.width;
    top = _topInPdf * newScale +
        (renderBoxWrapper.size.height - pdfHeight) / 2 -
        _touchSquareSize;
    left = _leftInPdf * newScale +
        (renderBoxWrapper.size.width - pdfWidth) / 2 -
        _touchSquareSize;
    width = newScale * _signalRepository.signalNotScaleWidth;
    height = newScale * _signalRepository.signalNotScaleHeight;
    _signalRepository.saveSizeAndPosition(left, top, width, height);
  }

  void _calcSaveXY() {
    if (_getPhotoKey().currentContext == null) return;
    RenderBox renderBox = _getPhotoKey().currentContext.findRenderObject();
    RenderBox renderBoxWrapper =
        widget.keyWrapper.currentContext.findRenderObject();
    _topInPdf = renderBoxWrapper
            .localToGlobal(Offset(0, _signalRepository.top + _touchSquareSize))
            .dy -
        renderBox.localToGlobal(Offset.zero).dy;
    _leftInPdf = renderBoxWrapper
            .localToGlobal(Offset(_signalRepository.left + _touchSquareSize, 0))
            .dx -
        renderBox.localToGlobal(Offset.zero).dx;
    _topInPdf /= _getPhotoViewController().scale;
    _leftInPdf /= _getPhotoViewController().scale;
  }

  void changeSizeAndPosition(
      double left, double top, double width, double height,
      {double scale}) {
    _signalRepository.changeSizeAndPosition(
      left,
      top,
      width,
      height,
      _getLocalPdfSize(),
      _getLocalPdfPosition(),
      scale: scale,
    );
    if (scale != null) _calcSaveXY();
  }

  void changePosistion(double left, double top,
      {double scale, bool isDontSetSignalInfo = false}) {
    _signalRepository.changePosistion(
        left, top, _getLocalPdfSize(), _getLocalPdfPosition(),
        isDontSetSignalInfo: isDontSetSignalInfo);
    if (scale != null) _calcSaveXY();
  }

  addPosition(double x, double y) {
    print("___________backup X  $backupX              $backupY");
    if (backupX == null) {
      backupX = _signalRepository.left;
      backupY = _signalRepository.top;
    }
    print(" X  $x             $y");

    if (x == null || y == null) {
      _signalRepository.restoreSizeAndPosition(
          _getLocalPdfSize(), _getLocalPdfPosition());
      backupX = null;
      backupY = null;
    } else {
      changePosistion(backupX + x, backupY + y, isDontSetSignalInfo: true);
    }
  }

  clearBackUpXY() {
    print("clear position");
    backupX = null;
    backupY = null;
  }
  Size _getLocalPdfSize() {
    if (_getPhotoKey()?.currentContext == null) {
      RenderBox wrapperRenderBox = widget.keyWrapper.currentContext.findRenderObject();
      return Size(wrapperRenderBox.size.width,
          wrapperRenderBox.size.height);
    }
    RenderBox renderBoxPdf = _getPhotoKey().currentContext.findRenderObject();
    return Size(renderBoxPdf.size.width * _getPhotoViewController().scale,
        renderBoxPdf.size.height * _getPhotoViewController().scale);
  }

  Offset _getLocalPdfPosition() {
    if (_getPhotoKey()?.currentContext == null) return Offset.zero;
    RenderBox renderBoxPdf = _getPhotoKey().currentContext.findRenderObject();
    RenderBox renderBoxWrapper =
        widget.keyWrapper.currentContext.findRenderObject();
    Offset topLeftWrapper = renderBoxWrapper.localToGlobal(Offset.zero);
    Offset topLeftPdf = renderBoxPdf.localToGlobal(Offset.zero);
    return Offset(
        topLeftPdf.dx - topLeftWrapper.dx, topLeftPdf.dy - topLeftWrapper.dy);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _signalRepository,
      child: Consumer(
        builder: (context, SignalRepository signalRepository, child) {
          widget.isVisible = _signalRepository.signalVisible;
          return Visibility(
            visible: signalRepository.signalVisible,
            child: Positioned(
              top: signalRepository.top,
              left: signalRepository.left,
              child: GestureDetector(
                onTap: () {
                  if (widget.onTap != null) widget.onTap(widget);
                },
                onPanDown: (details) {
                  return onPanDown(details);
                },
                onPanUpdate: (details) {
                  return onPanUpdate(details);
                },
                onPanEnd: (details) {
                  flag = SignalScreenState.FLAG_NONE;
                },
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildSquare(Alignment.bottomRight),
                          Container(
                            width: signalRepository.width,
                          ),
                          _buildSquare(Alignment.bottomLeft),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          image == null
                              ? Container()
                              : Image(
                                  image: image?.image,
                                  height: signalRepository.height,
                                  key: _signalKey,
                                  width: signalRepository.width,
                                  fit: BoxFit.fill,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(
                                    Icons.no_photography_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                          InkWell(
                            child: Icon(Icons.close),
                            onTap: () {
                              ConfirmDialogFunction dialog =
                                  ConfirmDialogFunction(
                                      context: context,
                                      onAccept: () {
                                        if (widget.deleteSignal != null) {
                                          widget.deleteSignal(widget);
                                        }
                                      },
                                      content: "Bạn có muốn xóa chữ ký này?");
                              dialog.showConfirmDialog();
                            },
                          )
                        ],
                      ),
                      Row(
                        children: [
                          _buildSquare(Alignment.topRight),
                          Container(
                            width: signalRepository.width,
                          ),
                          _buildSquare(Alignment.topLeft)
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSquare(Alignment alignment) {
    return Stack(alignment: alignment, children: [
      Container(
        width: _touchSquareSize,
        height: _touchSquareSize,
        color: Colors.transparent,
      ),
      Align(
        child: Container(
          key: _getSquareKey(alignment),
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          width: _squareSize,
          height: _squareSize,
        ),
      ),
    ]);
  }

  GlobalKey _getSquareKey(Alignment alignment) {
    if (alignment == Alignment.bottomLeft) {
      return _topRightSquareKey;
    }
    if (alignment == Alignment.bottomRight) {
      return _topLeftSquareKey;
    }
    if (alignment == Alignment.topRight) {
      return _bottomLeftSquareKey;
    }
    return _bottomRightSquareKey;
  }

  void onPanDown(DragDownDetails details) {
    if (_isLoadCompleted == false) return;
    _startX = details.globalPosition.dx;
    _startY = details.globalPosition.dy;
    _top = _signalRepository.top;
    _left = _signalRepository.left;
    _height = _signalRepository.height;
    _width = _signalRepository.width;
    RenderBox wrapperRenderBox=widget.keyWrapper.currentContext.findRenderObject() as RenderBox;
    _topPdf = wrapperRenderBox.localToGlobal(Offset.zero).dx;
    _leftPdf = wrapperRenderBox.localToGlobal(Offset.zero).dx;
    _rightPdf = _leftPdf+wrapperRenderBox.size.width;
    _bottomPdf = _topPdf+wrapperRenderBox.size.height;

    _wrapperHeight = widget.keyWrapper.currentContext.size.height;
    _wrapperWidth = widget.keyWrapper.currentContext.size.width;
    RenderBox renderBox = _signalKey.currentContext.findRenderObject();
    _right = _left + renderBox.size.width;
    _bottom = _top + renderBox.size.height;
    double minDistance = _getDistance(_startX, _startY, _topLeftSquareKey);
    flag = SignalScreenState.FLAG_TOP_LEFT;
    double nextDistance = _getDistance(_startX, _startY, _topRightSquareKey);
    if (minDistance > nextDistance) {
      flag = SignalScreenState.FLAG_TOP_RIGHT;
      minDistance = nextDistance;
    }
    nextDistance = _getDistance(_startX, _startY, _bottomRightSquareKey);
    if (minDistance > nextDistance) {
      flag = SignalScreenState.FLAG_BOTTOM_RIGHT;
      minDistance = nextDistance;
    }
    nextDistance = _getDistance(_startX, _startY, _bottomLeftSquareKey);
    if (minDistance > nextDistance) {
      flag = SignalScreenState.FLAG_BOTTOM_LEFT;
      minDistance = nextDistance;
    }
    if (minDistance > _touchSquareSize / 2) {
      flag = SignalScreenState.FLAG_MOVE;
    }
  }

  _getDistance(double startX, double startY, GlobalKey key) {
    RenderBox renderBox = key.currentContext.findRenderObject() as RenderBox;
    Offset position = renderBox.localToGlobal(Offset(renderBox.size.width/2,renderBox.size.height/2,));
    return sqrt(pow(position.dx - startX, 2) + pow(position.dy - startY, 2));
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (!_isLoadCompleted) return;
    double dx = details.globalPosition.dx - _startX;
    double dy = details.globalPosition.dy - _startY;
    double topSignal, leftSignal, heightSignal, widthSignal;
    double ratio = 1;
    switch (flag) {
      case SignalScreenState.FLAG_MOVE:
        {
          topSignal = _top + dy;
          leftSignal = _left + dx;
          if (topSignal + _touchSquareSize < 0) topSignal = -_touchSquareSize;
          if (topSignal + (_bottom - _top) + _touchSquareSize > _wrapperHeight)
            topSignal = _wrapperHeight - (_bottom - _top) - _touchSquareSize;
          if (topSignal + _touchSquareSize < _topPdf)
            topSignal = _topPdf - _touchSquareSize;
          if (topSignal + (_bottom - _top) + _touchSquareSize > _bottomPdf)
            topSignal = _bottomPdf - (_bottom - _top) - _touchSquareSize;

          if (leftSignal + _touchSquareSize < 0) leftSignal = -_touchSquareSize;
          if (leftSignal + (_right - _left) + _touchSquareSize > _wrapperWidth)
            leftSignal = _wrapperWidth - (_right - _left) - _touchSquareSize;
          if (leftSignal + _touchSquareSize < _leftPdf)
            leftSignal = _leftPdf - _touchSquareSize;
          if (leftSignal + (_right - _left) + _touchSquareSize > _rightPdf)
            leftSignal = _rightPdf - (_right - _left) - _touchSquareSize;

          changePosistion(leftSignal, topSignal,
              scale: _getPhotoViewController().scale);
          break;
        }
      case SignalScreenState.FLAG_TOP_LEFT:
        {
          widthSignal = _width - dx;
          heightSignal = _height - dy;
          if (widthSignal < 1) widthSignal = 1;
          if (heightSignal < 1) heightSignal = 1;
          ratio = widthSignal / heightSignal;
          if (ratio > _ratioWidthHeight) {
            widthSignal = heightSignal * _ratioWidthHeight;
          } else {
            heightSignal = widthSignal / _ratioWidthHeight;
          }
          topSignal = _bottom - heightSignal;
          leftSignal = _right - widthSignal;
          break;
        }
      case SignalScreenState.FLAG_TOP_RIGHT:
        {
          widthSignal = _width + dx;
          heightSignal = _height - dy;
          if (widthSignal < 1) widthSignal = 1;
          if (heightSignal < 1) heightSignal = 1;
          ratio = widthSignal / heightSignal;
          if (ratio > _ratioWidthHeight) {
            widthSignal = heightSignal * _ratioWidthHeight;
          } else {
            heightSignal = widthSignal / _ratioWidthHeight;
          }
          topSignal = _bottom - heightSignal;
          leftSignal = _left;
          break;
        }
      case SignalScreenState.FLAG_BOTTOM_LEFT:
        {
          widthSignal = _width - dx;
          heightSignal = _height + dy;
          if (widthSignal < 1) widthSignal = 1;
          if (heightSignal < 1) heightSignal = 1;
          ratio = widthSignal / heightSignal;
          if (ratio > _ratioWidthHeight) {
            widthSignal = heightSignal * _ratioWidthHeight;
          } else {
            heightSignal = widthSignal / _ratioWidthHeight;
          }
          topSignal = _top;
          leftSignal = _right - widthSignal;
          break;
        }
      case SignalScreenState.FLAG_BOTTOM_RIGHT:
        {
          widthSignal = _width + dx;
          heightSignal = _height + dy;
          if (widthSignal < 1) widthSignal = 1;
          if (heightSignal < 1) heightSignal = 1;
          ratio = widthSignal / heightSignal;
          if (ratio > _ratioWidthHeight) {
            widthSignal = heightSignal * _ratioWidthHeight;
          } else {
            heightSignal = widthSignal / _ratioWidthHeight;
          }
          topSignal = _top;
          leftSignal = _left;
          break;
        }
    }
    if (flag != SignalScreenState.FLAG_MOVE) {
      changeSizeAndPosition(leftSignal, topSignal, widthSignal, heightSignal,
          scale: _getPhotoViewController().scale);
    }
  }

  bool isTopLeft(double x, double y) {
    RenderBox renderBox = _signalKey.currentContext.findRenderObject();
    Offset position = renderBox.localToGlobal(Offset.zero);
    double topSignal = position.dy + _paddingSquare;
    double leftSignal = position.dx + _paddingSquare;
    return x < leftSignal && y < topSignal;
  }

  bool isTopRight(double x, double y) {
    RenderBox renderBox = _signalKey.currentContext.findRenderObject();
    Offset position = renderBox.localToGlobal(Offset.zero);
    double topSignal = position.dy + _paddingSquare;
    double rightSignal = position.dx + renderBox.size.width - _paddingSquare;
    return x > rightSignal && y < topSignal;
  }

  bool isBottomRight(double x, double y) {
    RenderBox renderBox = _signalKey.currentContext.findRenderObject();
    Offset position = renderBox.localToGlobal(Offset.zero);
    double bottomSignal = position.dy + renderBox.size.height - _paddingSquare;
    double rightSignal = position.dx + renderBox.size.width - _paddingSquare;
    return x > rightSignal && y > bottomSignal;
  }

  bool isBottomLeft(double x, double y) {
    RenderBox renderBox = _signalKey.currentContext.findRenderObject();
    Offset position = renderBox.localToGlobal(Offset.zero);
    double bottomSignal = position.dy + renderBox.size.height - _paddingSquare;
    double leftSignal = position.dx + _paddingSquare;
    return x < leftSignal && y > bottomSignal;
  }
}

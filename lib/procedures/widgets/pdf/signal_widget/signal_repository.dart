import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/procedures/models/response/data_signature_list_response.dart';
import 'package:workflow_manager/procedures/models/response/position.dart';
import 'package:workflow_manager/procedures/widgets/pdf/signal_widget/signal_info.dart';
import 'package:workflow_manager/procedures/widgets/pdf/signal_widget/signal_widget.dart';

class SignalRepository extends ChangeNotifier {
  bool signalVisible = false;
  double touchSquareSize;
  Signatures signatures;
  int pageNum;
  double top;
  double left;
  double width;
  double height;
  double fitTop;
  double fitLeft;
  double fitWidth;
  double fitHeight;
  double signalNotScaleWidth; //height của chữ ký khi k scale
  double signalNotScaleHeight; //width của chữ ký
  double pdfNotScaleWidth; //height của chữ ký khi k scale
  double pdfNotScaleHeight; //width của chữ ký khi k scale
  SignalInfo signalInfo = SignalInfo();
  int signPageFixPos;

  SignalRepository(
      {this.touchSquareSize,
      this.pageNum,
      this.signatures,
      this.signPageFixPos}) {
    signalInfo.signPageFixPos = signPageFixPos;
  }

  void showSignal() {
    if (signalVisible) return;
    signalVisible = true;
    // print("visible $hashCode   $signalVisible   ");
    notifyListeners();
  }

  void hideSignal() {
    if (!signalVisible) return;
    signalVisible = false;
    // print("visible $hashCode   $signalVisible   ");
    notifyListeners();
  }

  void changePosistion(double left, double top, Size pdfSize, Offset position,
      {bool isDontSetSignalInfo = false}) {
    if (left == null || top == null) return;
    this.left = left;
    this.top = top;
    if (isDontSetSignalInfo != true) {
      _setSignalInfo(pdfSize, position);
    }
    notifyListeners();
  }

  _setSignalInfo(
    Size pdfSize,
    Offset position,
  ) {
    signalInfo.signalWidth = width;
    signalInfo.signalHeight = height;
    signalInfo.pdfWidth = pdfSize.width.toInt();
    signalInfo.pdfHeight = pdfSize.height.toInt();
    signalInfo.left = ((left - position.dx) + touchSquareSize);
    signalInfo.bottom =
        (pdfSize.height - (top - position.dy) - height - touchSquareSize);
    signalInfo.pageNum = pageNum;
    signalInfo.id = signatures.iD;
  }

  void changeSize(
    double width,
    double height,
    Size pdfSize,
    Offset position,
  ) {
    if (width == null || height == null) return;
    this.width = width;
    this.height = height;
    _setSignalInfo(pdfSize, position);
    notifyListeners();
  }

  void saveSizeAndPosition(
      double left, double top, double width, double height) {
    fitWidth = width;
    fitHeight = height;
    fitTop = top;
    fitLeft = left;
  }

  void restoreSizeAndPosition(Size pdfSize, Offset position) {
    this.width = fitWidth;
    this.height = fitHeight;
    this.top = fitTop;
    this.left = fitLeft;
    notifyListeners();
  }

  void changeSizeAndPosition(double left, double top, double width,
      double height, Size pdfSize, Offset position,
      {double scale}) {
    if (left == null || top == null || width == null || height == null) {
      return;
    }
    if (scale != null) {
      signalNotScaleHeight = height / scale;
      signalNotScaleWidth = width / scale;
    }
    this.width = width;
    this.height = height;
    this.left = left;
    this.top = top;
    _setSignalInfo(pdfSize, position);
    // print("changeSizeAndPosition    $hashCode  $left     $top     $width    $height");
    notifyListeners();
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

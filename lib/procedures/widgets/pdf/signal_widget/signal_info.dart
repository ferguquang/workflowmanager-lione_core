import 'package:flutter/material.dart';

class SignalInfo {
  int pageNum;
  int pdfWidth;
  int pdfHeight;
  double bottom;
  double left;
  int id;
  double signalWidth;
  double signalHeight;
  int signPageFixPos;

  SignalInfo(
      {this.pageNum,
      this.pdfWidth,
      this.pdfHeight,
      this.bottom,
      this.left,
      this.id,
      this.signalWidth,
      this.signPageFixPos,
      this.signalHeight});
}

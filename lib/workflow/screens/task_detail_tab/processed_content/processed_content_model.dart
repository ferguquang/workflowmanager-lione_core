import 'package:flutter/material.dart';

class CollectionProcessedContent with ChangeNotifier {
  List<ProcessedContentModel> procressedList = [
    ProcessedContentModel(content: 'đây là content 1', date: '11/11/2000'),
    ProcessedContentModel(content: 'đây là content 2', date: '11/11/2000'),
    ProcessedContentModel(content: 'đây là content 3', date: '11/11/2000'),
    ProcessedContentModel(content: 'đây là content 4', date: '11/11/2000'),
    ProcessedContentModel(content: 'đây là content 5', date: '11/11/2000'),
  ];

  Future<void> getListProcessedContend() async {

  }

  Future<void> insertItem() async {

  }
}

class ProcessedContentModel {
  String date;
  String content;

  ProcessedContentModel({this.date, this.content});
}
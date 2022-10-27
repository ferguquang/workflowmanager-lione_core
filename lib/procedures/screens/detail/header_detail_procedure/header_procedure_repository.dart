import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';

class HeaderProcedureRepository with ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;


  void loadData() {
    notifyListeners();
  }
}
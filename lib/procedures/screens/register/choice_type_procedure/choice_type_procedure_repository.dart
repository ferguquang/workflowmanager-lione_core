import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/procedures/models/response/register_type_response.dart';

import '../step_widget.dart';

class ChoiceTypeProcedureRepository extends ChangeNotifier {
  List<RegisterTypes> listRegisterType = [];

  void loadData() async {
    final response = await ApiCaller.instance
        .postFormData(AppUrl.getQTTTRegisterTypes, Map());
    RegisterTypeResponse registerTypeResponse =
        RegisterTypeResponse.fromJson(response);
    if (registerTypeResponse.status == 1) {
      listRegisterType = registerTypeResponse.data.types;
      notifyListeners();
    } else {
      showErrorToast(registerTypeResponse.messages);
    }
  }
}

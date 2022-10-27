import 'package:workflow_manager/base/extension/string.dart';

class ChangePasswordRequest {
  String currentPass;

  String newPass;

  String newPassConfirm;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (currentPass.isNotNullOrEmpty) {
      params["PasswordOld"] = currentPass;
    }
    if (newPass.isNotNullOrEmpty) {
      params["PasswordChange"] = newPass;
    }
    return params;
  }
}

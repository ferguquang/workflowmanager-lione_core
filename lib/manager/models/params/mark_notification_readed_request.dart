import 'package:workflow_manager/base/extension/string.dart';

class MarkNotificationRequest {

  String arrayId;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(arrayId.isNotNullOrEmpty) {
      params["IDNotification"] = arrayId;
    }
    return params;
  }
}

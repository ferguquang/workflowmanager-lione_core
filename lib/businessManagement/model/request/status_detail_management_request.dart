import 'package:workflow_manager/base/utils/common_function.dart';

class StatusDetailManagementRequest {
  int id;
  int iDTarget;
  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(id)) params["ID"] = id;
    if (isNotNullOrEmpty(iDTarget)) params["IDTarget"] = iDTarget;
    return params;
  }
}

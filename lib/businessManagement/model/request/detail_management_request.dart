import 'package:workflow_manager/base/utils/common_function.dart';

class DetailManagementRequest {
  int id;
  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(id)) params["ID"] = id;

    return params;
  }
}

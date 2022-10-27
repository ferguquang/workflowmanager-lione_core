import 'package:workflow_manager/base/utils/common_function.dart';

class ForTranferUserRequest {
  String idJob;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(isNotNullOrEmpty(idJob)) {
      params["IDJob"] = idJob;
    }
    return params;
  }
}

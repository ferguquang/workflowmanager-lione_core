import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/extension/string.dart';

class RejectTaskRequest {

  int idExtension;

  int idJob;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(isNotNullOrEmpty(idExtension)) {
      params["IDExtension"] = idExtension;
    }
    if(isNotNullOrEmpty(idJob)) {
      params["IDJob"] = idJob;
    }
    return params;
  }
}

import 'package:workflow_manager/base/utils/common_function.dart';

class GetDataGroupJobPersonalRequest {
  int idJobGroup;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(isNotNullOrEmpty(idJobGroup)) {
      params["IDJobGroup"] = idJobGroup;
    }
    return params;
  }
}

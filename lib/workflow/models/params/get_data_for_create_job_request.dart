import 'package:workflow_manager/base/utils/common_function.dart';

class GetDataForCreateJobRequest {
  String sIDJobGroup;
  String sIDJobGroupCol;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();

    if(isNotNullOrEmpty(sIDJobGroup)) {
      params["IDJobGroup"] = sIDJobGroup;
    }

    if(isNotNullOrEmpty(sIDJobGroupCol)) {
      params["IDJobGroupCol"] = sIDJobGroupCol;
    }

    return params;
  }
}

import 'package:workflow_manager/base/utils/common_function.dart';

class GetDataForEditRequest {
  String sIDJob;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();

    if(isNotNullOrEmpty(sIDJob)) {
      params["IDJob"] = sIDJob;
    }

    return params;
  }
}

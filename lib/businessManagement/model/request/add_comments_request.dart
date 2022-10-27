import 'package:workflow_manager/base/utils/common_function.dart';

class AddCommentsRequest {
  String body;
  int iDContent;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(body)) params["Body"] = body;
    if (isNotNullOrEmpty(iDContent)) params["IDContent"] = iDContent;

    return params;
  }
}

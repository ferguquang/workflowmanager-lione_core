import 'package:workflow_manager/base/utils/common_function.dart';

class SelectedUserSearchRequest {
  String term;
  int iDNotIn;
  int iDModule;
  String positionCode;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["IDNotIn"] = this.iDNotIn;
    if (isNotNullOrEmpty(term)) params["Term"] = this.term;

    if (isNotNullOrEmpty(iDModule)) params["IDModule"] = this.iDModule;

    if (isNotNullOrEmpty(positionCode))
      params["PositionCode"] = this.positionCode;

    return params;
  }
}

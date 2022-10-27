
import 'package:workflow_manager/base/utils/common_function.dart';

class GetListStatusRequest {
  String token;
  int status;
  int viewType;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["Status"] = this.status;
    params["ViewType"] = this.viewType;
    return params;
  }
}

class ChangeStatusRequest {
  String token;
  int status;
  int idJob;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(isNotNullOrEmpty(this.status)) {
      params["Status"] = this.status;
    }
    if(isNotNullOrEmpty(this.idJob)) {
      params["IDJob"] = this.idJob;
    }
    return params;
  }
}
import 'package:workflow_manager/base/utils/common_function.dart';

class GetListTabGroupRequest {

  int idGroupJob;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(isNotNullOrEmpty(this.idGroupJob)) {
      params["IDGroupJob"] = this.idGroupJob;
    }
    return params;
  }

}
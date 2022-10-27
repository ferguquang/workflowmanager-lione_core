import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class GetInfoNotifyRequest {

  int idNotify;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(isNotNullOrEmpty(idNotify)) {
      params["IDNtf"] = idNotify;
    }
    return params;
  }
}

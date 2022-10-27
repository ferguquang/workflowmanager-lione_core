import 'package:workflow_manager/base/utils/common_function.dart';

class CheckDownloadFileRequest {
  
  int idDoc;
  String accessSafePassword;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();

    if(isNotNullOrEmpty(idDoc)) {
      params["IDDoc"] = this.idDoc;
    }

    if (isNotNullOrEmpty(accessSafePassword)) {
      params["AccessSafePassword"] = accessSafePassword;
    }
    
    params["r"] = "0";
    
    return params;
  }
}


import 'package:workflow_manager/base/utils/common_function.dart';

class GetListProcessedRequest {
  String idJob;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(isNotNullOrEmpty(this.idJob)) {
      params['IDJob'] = this.idJob;
    }
    return params;
  }
}
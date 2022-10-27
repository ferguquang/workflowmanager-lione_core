import 'package:workflow_manager/base/utils/common_function.dart';

class JobRecipientRequest {
  String idJob;
  String sSearchName = '';
  String pageIndex;
  String pageSize;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(isNotNullOrEmpty(this.idJob)) {
      params['IDJob'] = this.idJob;
    }
    if(isNotNullOrEmpty(this.sSearchName)) {
      params['SearchName'] = this.sSearchName;
    }
    params['PageIndex'] = this.pageIndex;
    params['PageSize'] = this.pageSize;
    return params;
  }
}

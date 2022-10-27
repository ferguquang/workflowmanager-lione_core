import 'package:workflow_manager/base/utils/common_function.dart';

class NotificationRequest {
  String pageIndex;
  String pageSize;
  String term;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['PageIndex'] = this.pageIndex;
    params['PageSize'] = this.pageSize;
    if(isNotNullOrEmpty(term)) {
      params['Term'] = this.term;
    }
    // params['Type'] = '-9999';
    return params;
  }
}

class NotificationStatusRequest {
  int id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['IDNotification'] = this.id;
    return params;
  }
}

import 'package:workflow_manager/base/utils/common_function.dart';

class SharedSearchRequest {
  String token;
  int pageIndex;
  int pageSize;
  String search_name;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["PageIndex"] = this.pageIndex;
    params["PageSize"] = this.pageSize;
    if (isNotNullOrEmpty(search_name)) {
      params["SearchName"] = this.search_name;
    }

    return params;
  }
}

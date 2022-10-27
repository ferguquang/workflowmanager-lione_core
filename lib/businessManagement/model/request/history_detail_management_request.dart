import 'package:workflow_manager/base/utils/common_function.dart';

class HistoryDetailManagementRequest {
  int id;
  int sort;
  int pageSize = 10;
  int pageIndex = 1;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(id)) params["ID"] = id;
    if (isNotNullOrEmpty(sort)) params["SortType"] = sort;
    params["PageSize"] = this.pageSize;
    params["PageIndex"] = this.pageIndex;
    return params;
  }
}

import 'package:workflow_manager/base/utils/common_function.dart';

class SearchGroupUserRequest {
  String token;
  int pageIndex;
  int pageSize;
  String search_name;
  int iDDept;
  List<int> userList;

  Map<String, dynamic> getParamsNoneNull() {
    Map<String, dynamic> params = getParams();
    params.removeWhere((key, value) => value == null);
    return params;
  }

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["PageIndex"] = this.pageIndex;
    params["PageSize"] = this.pageSize;
    params["SearchName"] = this.search_name;
    params["IDDept"] = this.iDDept;
    StringBuffer sb = StringBuffer();
    if (isNotNullOrEmpty(userList))
      userList.forEach((element) {
        sb.write("$element,");
      });
    String idList = "";
    if (sb.length > 0) idList = sb.toString().substring(0, sb.length - 1);
    params["ListIDEmpExist"] = idList;
    return params;
  }
}

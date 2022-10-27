import '../../base/utils/common_function.dart';

class GeneralReportParams {
  int deptID, projectID, year, quarter, suggestType, shoppingType;
  int take, skip;
  List<int> cateIds;
  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["DeptID"] = deptID;
    params["ProjectID"] = projectID;
    params["Year"] = year;
    if (quarter != 0) params["Quarter"] = quarter;
    params["SuggestType"] = suggestType;
    params["ShoppingType"] = shoppingType;
    params["CateID"] = isNotNullOrEmpty(cateIds)?"[${cateIds.join(",")}]":null;
    params.removeWhere((key, value) => value == null);
    return params;
  }
}

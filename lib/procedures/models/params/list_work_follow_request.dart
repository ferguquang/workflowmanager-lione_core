import 'package:workflow_manager/base/utils/common_function.dart';

class ListWorkFollowRequest {
  int idType;
  int idService = -1;
  String startDate;
  String endDate;
  String term;
  int pageSize = 10;
  int pageIndex = 1;
  int featureType = -1;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["IDType"] = idType;
    params["PageIndex"] = pageIndex;
    params["PageSize"] = pageSize;
    if (featureType != -1) params["FeatureType"] = featureType;
    if (isNotNullOrEmpty(startDate)) params["StartDate"] = startDate;
    if (isNotNullOrEmpty(endDate)) params["EndDate"] = endDate;
    if (isNotNullOrEmpty(term)) params["Term"] = term;
    return params;
  }

  Map<String, dynamic> getChangeFeatureParams() {
    Map<String, dynamic> params = Map();
    if (idService != -1) params["IDService"] = idService;
    return params;
  }
}

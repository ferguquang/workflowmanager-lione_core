import 'package:workflow_manager/base/utils/common_function.dart';

class ManufacturReportParams {
  int iDManufactur;
  String startDate, endDate;
  int take, skip;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["IDManufactur"] = iDManufactur;
    params["StartDate"] = startDate?.replaceAll("/", "-");
    params["EndDate"] = endDate?.replaceAll("/", "-");
    params["Take"] = take;
    params["Skip"] = skip;
    params.removeWhere((key, value) => value == null);
    return params;
  }
}

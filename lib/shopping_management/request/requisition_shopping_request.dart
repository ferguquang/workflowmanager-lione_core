import 'package:workflow_manager/base/utils/common_function.dart';

class RequisitionShoppingIndexRequest {
  dynamic take, skip, idDept, statuisProcess, requisitionNumber, requestBy;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["Take"] = take;
    params["Skip"] = skip;
    params["IDDept"] = idDept;
    params["StatusProcess"] = statuisProcess;
    params["RequisitionNumber"] = requisitionNumber;
    params["RequestBy"] = requestBy;
    params.removeWhere((key, value) => isNullOrEmpty(value));
    return params;
  }
}
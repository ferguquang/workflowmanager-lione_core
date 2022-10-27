import 'package:workflow_manager/base/utils/common_function.dart';

/**
    TẠO MỚI HỢP ĐỒNG
 */
class CreateContractRequest {
  int iDProjectPlan;
  int iDContract;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(iDProjectPlan))
      params["IDProjectPlan"] = iDProjectPlan;
    if (isNotNullOrEmpty(iDContract)) params["ID"] = iDContract;

    return params;
  }
}

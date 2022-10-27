import 'package:workflow_manager/base/utils/common_function.dart';

class SelectedGroupCustomersRequest {
  int id;
  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(id)) params["IDCustomer"] = id;

    return params;
  }
}

import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';

class DeliveryListRequest {
  dynamic skip, take, projectID, requisitionNumber, pONumber, status;
  int isSearch;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["Skip"] = skip;
    params["Take"] = take;
    params["ProjectID"] = projectID;
    params["RequisitionNumber"] = requisitionNumber;
    params["PONumber"] = pONumber;
    params["Status"] = status;
    params["IsSearch"] = isSearch;
    params.removeWhere((key, value) => value == null);
    return params;
  }
}

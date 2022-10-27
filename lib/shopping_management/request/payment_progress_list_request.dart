import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';

class PaymentProgressListRequest {
  dynamic skip, take, project, prCodes, pOCodes, status, providerTerm;
  int isSearch;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["Skip"] = skip;
    params["Take"] = take;
    params["IDProject"] = project;
    params["PRCode"] = prCodes;
    params["POCode"] = pOCodes;
    params["PaymentStatus"] = status;
    params["ProviderTerm"] = providerTerm;
    params["IsSearch"] = isSearch;
    params.removeWhere((key, value) => value == null);
    return params;
  }
}

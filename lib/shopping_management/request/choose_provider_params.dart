class ChooseProviderParams {
  int pageIndex;
  int take = 10;
  String requisitionNumber;
  int status;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    if (pageIndex != null) {
      params["Skip"] = pageIndex;
    } else {
      params["Skip"] = 0;
    }
    if (take != null) {
      params["Take"] = take;
    }
    if (requisitionNumber != null) {
      params["RequisitionNumber"] = requisitionNumber;
    }
    if (status != null) {
      params["Status"] = status;
    }
    return params;
  }
}

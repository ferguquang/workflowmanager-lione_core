class ContractListParams {
  int pageIndex;
  int take = 10;
  int iDProject;
  String iDPR;
  int iDPO;
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
    if (iDProject != null) {
      params["ProjectID"] = iDProject;
    }
    if (iDPR != null) {
      params["RequisitionNumber"] = iDPR;
    }
    if (iDPO != null) {
      params["PONumber"] = iDPO;
    }
    if (status != null) {
      params["Status"] = status;
    }
    return params;
  }
}

class ProgressReportParams {
  int iDProject, iDRequisition, iDContract;
  String requestBy;
  int take, skip;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["IDProject"] = iDProject;
    params["IDRequisition"] = iDRequisition;
    params["IDContract"] = iDContract;
    params["RequestBy"] = requestBy;
    params["Take"] = take;
    params["Skip"] = skip;
    params.removeWhere((key, value) => value == null);
    return params;
  }
}

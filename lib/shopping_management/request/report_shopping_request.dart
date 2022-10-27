class ImportReportRequest {
  dynamic take, skip, nameProvider, nameCommodity, startDate, endDate;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["Take"] = take;
    params["Skip"] = skip;
    params["NameProvider"] = nameProvider;
    params["NameCommodity"] = nameCommodity;
    params["StartDate"] = startDate;
    params["EndDate"] = endDate;
    params.removeWhere((key, value) => value == null);
    return params;
  }
}
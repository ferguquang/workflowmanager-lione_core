class GetDataForListGroupJobRequest {
  String startDate, endDate;
  int pageIndex, pageSize, idJobGroup;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (this.startDate != null) {
      params["StartDate"] = this.startDate;
    }
    if (this.endDate != null) {
      params["EndDate"] = this.endDate;
    }
    if (this.idJobGroup != null) {
      params["IDJobGroup"] = this.idJobGroup;
    }
    params["PageIndex"] = this.pageIndex;
    params["PageSize"] = this.pageSize;

    return params;
  }
}

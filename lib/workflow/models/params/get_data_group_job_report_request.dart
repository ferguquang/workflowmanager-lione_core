class GetDataForListGroupJobReportRequest {
  String startDate, endDate, jobGroupName;
  int idJobGroup;

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

    return params;
  }
}

class GetListUserPerformanceReportRequest {
  int idEmp;
  String endDate;
  String startDate;
  int idJobGroup;
  int idDept;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (this.idEmp != null) {
      params['IDEmp'] = this.idEmp;
    }
    if (this.startDate != null) {
      params['StartDate'] = this.startDate;
    }
    if (this.endDate != null) {
      params['EndDate'] = this.endDate;
    }
    if (this.idJobGroup != null) {
      params['IDJobGroup'] = this.idJobGroup;
    }
    if (this.idDept != null) {
      params['IDDept'] = this.idDept;
    }
    return params;
  }
}



class ProcessedRequest {
  String time, describe;
  int idJob, idJobHistory;

  ProcessedRequest({this.time, this.describe, this.idJob, this.idJobHistory});

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (this.time != null) {
      params["TimeProcess"] = this.time;
    }
    if (this.describe != null) {
      params["Describe"] = this.describe;
    }
    if (this.idJob != null) {
      params["IDJob"] = this.idJob;
    }
    if (this.idJobHistory != null) {
      params["IDJobHistory"] = this.idJobHistory;
    }

    return params;
  }
}
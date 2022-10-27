class GetGroupJobStatusRequest {
  String token;
  int statusId;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["Token"] = this.token;
    params["Status"] = this.statusId;
    return params;
  }
}

class ChangeGroupJobStatusRequest {
  String token;
  int statusId;
  int idGroupJob;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["Token"] = this.token;
    params["Status"] = this.statusId;
    params["IDGroupJob"] = this.idGroupJob;
    return params;
  }
}

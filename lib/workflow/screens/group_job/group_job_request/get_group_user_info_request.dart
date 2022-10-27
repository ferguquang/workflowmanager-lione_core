class GetGroupUserInfoRequest {
  String token;
  int idEmp;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["Token"] = this.token;
    params["IDEmp"] = this.idEmp;
    return params;
  }
}

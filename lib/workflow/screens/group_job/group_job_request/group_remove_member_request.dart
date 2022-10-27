class GroupRemoveMemberRequest {
  String token;
  int memberId;
  int groupJobId;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["Token"] = this.token;
    params["IDGroupJob"] = this.groupJobId;
    params["IDMember"] = this.memberId;
    return params;
  }
}

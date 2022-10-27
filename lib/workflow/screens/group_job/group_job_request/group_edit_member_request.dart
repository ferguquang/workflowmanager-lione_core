class GroupEditMemberRequest {
  String token;
  int memberId;
  int groupJobId;
  int role;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["Token"] = this.token;
    params["IDGroupJob"] = this.groupJobId;
    params["IDMember"] = this.memberId;
    params["Role"] = this.role;
    return params;
  }
}

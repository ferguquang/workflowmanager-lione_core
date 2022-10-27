class GroupJobMemberRequest {
  int groupId;

  GroupJobMemberRequest(this.groupId);

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["IDGroupJob"] = groupId;
    return params;
  }
}

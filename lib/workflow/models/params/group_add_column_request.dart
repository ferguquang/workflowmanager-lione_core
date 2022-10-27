class GroupAddColumnRequest {
  int token;
  String title;
  int iDGroupJob;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (this.token != null) {
      params['Token'] = this.token;
    }
    if (this.title != null) {
      params['Title'] = this.title;
    }
    if (this.iDGroupJob != null) {
      params['IDGroupJob'] = this.iDGroupJob;
    }
    return params;
  }
}

class GroupDeleteColumnRequest {
  int token;
  int iDColumn;
  int iDGroupJob;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (this.token != null) {
      params['Token'] = this.token;
    }
    if (this.iDColumn != null) {
      params['IDColumn'] = this.iDColumn;
    }
    if (this.iDGroupJob != null) {
      params['IDGroupJob'] = this.iDGroupJob;
    }
    return params;
  }
}

class GroupEditColumnRequest {
  String title;
  int iDGroupJob;
  int iDColumn;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (this.title != null) {
      params['Title'] = this.title;
    }
    if (this.iDGroupJob != null) {
      params['IDGroupJob'] = this.iDGroupJob;
    }
    if (this.iDColumn != null) {
      params['IDColumn'] = this.iDColumn;
    }
    return params;
  }
}

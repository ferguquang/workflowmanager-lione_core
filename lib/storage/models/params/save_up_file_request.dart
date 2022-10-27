class SaveUpFileRequest {
  String path;
  String name;
  int parent;
  int docTypes;
  String accessSafePassword;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();

    params["FilePaths"] = this.path;
    params["FileNames"] = this.name;
    params["Parent"] = this.parent;
    params["Doctypes"] = this.docTypes;
    if (accessSafePassword != null) {
      params["AccessSafePassword"] = accessSafePassword;
    }

    return params;
  }
}

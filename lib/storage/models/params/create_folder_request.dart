class CreateFolderRequest {
  int parent;
  String name;
  String accessSafePassword;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();

    params["Parent"] = this.parent;
    params["Name"] = this.name;
    if (accessSafePassword != null) {
      params["AccessSafePassword"] = accessSafePassword;
    }

    return params;
  }
}

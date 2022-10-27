class FilterTaskRequest {

  int viewType;
  int isDeadLine;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["ViewType"] = viewType;
    params["IsDeadLine"] = isDeadLine;
    return params;
  }

}
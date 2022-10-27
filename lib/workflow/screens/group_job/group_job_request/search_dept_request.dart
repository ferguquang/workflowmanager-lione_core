class SearchDeptRequest {
  String token;
  int pageIndex;
  int pageSize;
  String search_name;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["PageIndex"] = this.pageIndex;
    params["PageSize"] = this.pageSize;
    params["SearchName"] = this.search_name;
    return params;
  }
}

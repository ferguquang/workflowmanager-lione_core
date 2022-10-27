class BorrowIndexRequest {
  int status;
  int skip = 1;
  int take = 10;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["Status"] = status;
    params["Skip"] = skip;
    params["Take"] = take;
    return params;
  }
}

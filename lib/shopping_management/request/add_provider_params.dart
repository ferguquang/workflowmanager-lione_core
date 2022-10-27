class AddProviderParams {
  int pageIndex;
  int take = 10;
  String codeName;
  int status;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    if (pageIndex != null) {
      params["Skip"] = pageIndex;
    } else {
      params["Skip"] = 1;
    }
    if (take != null) {
      params["Take"] = take;
    }
    if (codeName != null) {
      params["CodeName"] = codeName;
    }
    return params;
  }
}

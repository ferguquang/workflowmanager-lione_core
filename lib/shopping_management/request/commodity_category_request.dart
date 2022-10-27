class CommodityCategoryRequest {
  dynamic code, term, skip, take;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["Code"] = code;
    params["Term"] = term;
    params["Take"] = take;
    params["Skip"] = skip;
    return params;
  }
}
class ManagerSerialParams {
  int skip;
  int take = 10;
  String serialNo;
  String nameCommodity;
  String codeCommodity;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    if (skip != null) {
      params["Skip"] = skip;
    } else {
      params["Skip"] = 0;
    }
    if (take != null) {
      params["Take"] = take;
    }
    if (nameCommodity != null) {
      params["NameCommodity"] = nameCommodity;
    }
    if (codeCommodity != null) {
      params["CodeCommodity"] = codeCommodity;
    }
    if (serialNo != null) {
      params["SerialNo"] = serialNo;
    }
    return params;
  }
}

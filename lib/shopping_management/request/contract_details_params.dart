class ContractDetailsParams {
  int id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    if (id != null) {
      params["ID"] = id;
    }
    return params;
  }
}

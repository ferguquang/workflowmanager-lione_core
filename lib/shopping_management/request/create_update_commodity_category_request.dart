
class CommodityCategorySaveRequest {
  dynamic code, name;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["Code"] = code;
    params["Name"] = name;
    return params;
  }
}

class CommodityCategoryChangeRequest {
  dynamic id, code, name;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    params["Code"] = code;
    params["Name"] = name;
    return params;
  }
}
// class này dùng chung 3 api
class BorrowRemovesRequest {
  String iD;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["ID"] = iD;
    return params;
  }
}

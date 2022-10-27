class BorrowSearchRequest {
  String startDate;
  String endDate;
  String term;
  int skip = 1;
  int take = 10;
  String sortname = 'Created';
  int sortType = 0;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["StartDate"] = startDate;
    params["EndDate"] = endDate;
    params["Term"] = term;
    params["Skip"] = skip;
    params["Take"] = take;
    params["Sortname"] = sortname;
    params["Sorttype"] = sortType;
    return params;
  }
}

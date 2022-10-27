import 'package:workflow_manager/base/utils/common_function.dart';

class OverViewRequest {
  String iDSellers;
  String iDSeller;
  String year;
  String years;
  String dateType;
  String type; // doanh thu - theo thời gian
  String quarters;
  String months;
  String provinces;
  String startSignDate;
  String endSignDate;
  String isSearch;
  String iDCenter;
  String iDCustomers;

  // dành cho hợp đồng - danh sách hợp đồng
  int pageIndex;
  int pageSize;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(pageIndex)) params["PageIndex"] = pageIndex;
    if (isNotNullOrEmpty(pageSize)) params["PageSize"] = pageSize;

    if (isNotNullOrEmpty(iDSellers)) params["IDSellers"] = iDSellers;
    if (isNotNullOrEmpty(iDSeller)) params["IDSeller"] = iDSeller;
    if (isNotNullOrEmpty(year)) params["Year"] = year;
    if (isNotNullOrEmpty(years)) params["Years"] = years;
    if (isNotNullOrEmpty(dateType)) params["DateType"] = dateType;
    if (isNotNullOrEmpty(type)) params["Type"] = type;
    if (isNotNullOrEmpty(quarters)) params["Quarters"] = quarters;
    if (isNotNullOrEmpty(months)) params["Months"] = months;
    if (isNotNullOrEmpty(provinces))
      params["Provinces"] = provinces; // vùng, tình - thành phố
    if (isNotNullOrEmpty(startSignDate))
      params["StartSignDate"] = startSignDate;
    if (isNotNullOrEmpty(endSignDate)) params["EndSignDate"] = endSignDate;
    if (isNotNullOrEmpty(isSearch)) params["IsSearch"] = isSearch;
    if (isNotNullOrEmpty(iDCenter)) params["IDCenter"] = iDCenter; // phòng ban
    if (isNotNullOrEmpty(iDCustomers))
      params["IDCustomers"] = iDCustomers; // khách hàng
    return params;
  }
}

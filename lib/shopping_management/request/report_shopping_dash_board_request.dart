import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/response/shopping_dashboard_response.dart';

class ReportShoppingDashBoardRequest {
  Dept dept = Dept();
  Years year = Years();
  Quarters quarter = Quarters();
  int iDCategory;
  bool isDashboard = false;

  ReportShoppingDashBoardRequest();

  ReportShoppingDashBoardRequest.fromJson(Map<String, dynamic> json) {
    dept = Dept.fromJson(json["Dept"]);
    year = Years.fromJson(json["Years"]);
    quarter = Quarters.fromJson(json["Quarters"]);
    iDCategory = json["IDCategory"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Dept'] = this.dept?.toJson();
    data['Years'] = this.year?.toJson();
    data['Quarters'] = this.quarter?.toJson();
    data['IDCategory'] = this.iDCategory;
    return data;
  }

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    if(isNotNullOrEmpty(dept.iD)) {
      params["IDDept"] = dept.iD;
    }
    if(isNotNullOrEmpty(year.iD)) {
      params["Year"] = year.iD;
    }
    if(isNotNullOrEmpty(quarter.iD)) {
      params["Quater"] = quarter.iD;
    }
    if (!isDashboard) {
      if(isNotNullOrEmpty(iDCategory)) {
        params["IDCategory"] = iDCategory;
      }
    }

    return params;
  }
}

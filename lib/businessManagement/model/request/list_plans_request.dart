import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/response/project_plan_index_response.dart';

class ListPlansRequest {
  List<Sellers> idSellers;
  List<TypeProjects> idCenter = [];
  List<TypeProjects> idTypeProject = [];
  List<TypeProjects> idTypeBusiness = [];
  List<TypeProjects> idPhases = [];
  List<TypeProjects> statuss = [];
  String startDate;
  String endDate;
  List<TypeProjects> quaters;
  int year = int.parse(getCurrentDate(Constant.yyyy));
  List<TypeProjects> sources;
  List<TypeProjects> provinces;
  List<TypeProjects> potentialTypes;
  List<TypeProjects> campaignTypes;
  String startDateUpdated;
  String endDateUpdated;
  int pageSize = 10;
  int pageIndex = 1;

  bool issFirst = true;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["PageSize"] = this.pageSize;
    params["PageIndex"] = this.pageIndex;
    if (isNotNullOrEmpty(idSellers)) {
      List<int> ids = [];
      idSellers.forEach((element) {
        ids.add(element.iD);
      });
      params["IDSellers"] = "[${ids.join(",")}]";
    }
    if (isNotNullOrEmpty(startDate)) {
      params["StartDate"] = startDate;
    }
    if (isNotNullOrEmpty(endDate)) {
      params["EndDate"] = endDate;
    }
    params["Year"] = year;
    if (isNotNullOrEmpty(startDateUpdated)) {
      params["StartDateUpdated"] = startDateUpdated;
    }
    if (isNotNullOrEmpty(endDateUpdated)) {
      params["EndDateUpdated"] = endDateUpdated;
    }
    if (isNotNullOrEmpty(idCenter)) {
      List<int> ids = [];
      idCenter.forEach((element) {
        ids.add(element.iD);
      });
      params["IDCenter"] = "[${ids.join(",")}]";
    }
    if (isNotNullOrEmpty(idTypeProject)) {
      List<int> ids = [];
      idTypeProject.forEach((element) {
        ids.add(element.iD);
      });
      params["IDTypeProject"] = "[${ids.join(",")}]";
    }
    if (isNotNullOrEmpty(idTypeBusiness)) {
      List<int> ids = [];
      idTypeBusiness.forEach((element) {
        ids.add(element.iD);
      });
      params["IDTypeBusiness"] = "[${ids.join(",")}]";
    }
    if (isNotNullOrEmpty(idPhases)) {
      List<int> ids = [];
      idPhases.forEach((element) {
        ids.add(element.iD);
      });
      params["IDPhases"] = "[${ids.join(",")}]";
    }
    if (isNotNullOrEmpty(statuss)) {
      List<int> ids = [];
      statuss.forEach((element) {
        ids.add(element.iD);
      });
      params["Statuss"] = "[${ids.join(",")}]";
    }
    if (isNotNullOrEmpty(quaters)) {
      List<int> ids = [];
      quaters.forEach((element) {
        ids.add(element.iD);
      });
      params["Quarters"] = "[${ids.join(",")}]";
    }
    if (isNotNullOrEmpty(sources)) {
      List<int> ids = [];
      sources.forEach((element) {
        ids.add(element.iD);
      });
      params["Sources"] = "[${ids.join(",")}]";
    }
    if (isNotNullOrEmpty(provinces)) {
      List<int> ids = [];
      provinces.forEach((element) {
        ids.add(element.iD);
      });
      params["Provinces"] = "[${ids.join(",")}]";
    }
    if (isNotNullOrEmpty(potentialTypes)) {
      List<int> ids = [];
      potentialTypes.forEach((element) {
        ids.add(element.iD);
      });
      params["PotentialTypes"] = "[${ids.join(",")}]";
    }
    if (isNotNullOrEmpty(campaignTypes)) {
      List<int> ids = [];
      campaignTypes.forEach((element) {
        ids.add(element.iD);
      });
      params["CampaignTypes"] = "[${ids.join(",")}]";
    }

    return params;
  }
}

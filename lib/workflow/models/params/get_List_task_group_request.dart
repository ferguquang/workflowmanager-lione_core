import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';

class GetListColumnGroupRequest {
  String token;
  int pageIndex;
  int pageSize;
  String jobName;
  String title;
  String startDate;
  String endDate;
  UserItem priority;
  int idJobGroup;
  int idGroupJobCol;
  UserItem idCoExecute;
  UserItem idSupervisor;
  UserItem idStatus;
  UserItem type;
  UserItem idExecute;
  UserItem idCreatedBy;

  GetListColumnGroupRequest();

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["PageIndex"] = this.pageIndex;
    params["PageSize"] = this.pageSize;
    if(isNotNullOrEmpty(this.jobName)) {
      params["JobName"] = this.jobName;
    }
    if(isNotNullOrEmpty(this.startDate)) {
      params["StartDate"] = this.startDate;
    }
    if(isNotNullOrEmpty(this.endDate)) {
      params["EndDate"] = this.endDate;
    }
    if (isNotNullOrEmpty(this.idStatus)) {
      params["Status"] = this.idStatus.iD;
    }
    if (isNotNullOrEmpty(this.priority)) {
      params["Priority"] = this.priority.iD;
    }
    if (isNotNullOrEmpty(this.idJobGroup)) {
      params["IDGroupJob"] = this.idJobGroup;
    }
    if (isNotNullOrEmpty(this.idGroupJobCol)) {
      params["IDGroupJobCol"] = this.idGroupJobCol;
    }
    if (isNotNullOrEmpty(this.idCoExecute)) {
      params["CoExecute"] = this.idCoExecute.iD;
    }
    if (isNotNullOrEmpty(this.idSupervisor)) {
      params["Supervisor"] = this.idSupervisor.iD;
    }
    if (isNotNullOrEmpty(this.type)) {
      params["Type"] = this.type.iD;
    }
    if (isNotNullOrEmpty(this.idExecute)) {
      params["Execute"] = this.idExecute.iD;
    }
    if (isNotNullOrEmpty(this.idCreatedBy)) {
      params["CreatedBy"] = this.idCreatedBy.iD;
    }
    return params;
  }

  GetListColumnGroupRequest.fromJson(Map<String, dynamic> json) {
    pageIndex = json['PageIndex'];
    jobName = json["JobName"];
    startDate = json["StartDate"];
    endDate = json["EndDate"];
    if(json["Priority"] != null) {
      priority = UserItem.fromJson(json["Priority"]);
    }
    if(json["Status"] != null) {
      idStatus = UserItem.fromJson(json["Status"]);
    }
    if(json["IDGroupJob"] != null) {
      idJobGroup = json["IDJobGroup"];
    }
    if(json["IDGroupJobCol"] != null) {
      idGroupJobCol = json["IDGroupJobCol"];
    }
    if(json["CoExecute"] != null) {
      idCoExecute = UserItem.fromJson(json["CoExecute"]);
    }
    if(json["Supervisor"] != null) {
      idSupervisor = UserItem.fromJson(json["Supervisor"]);
    }
    if(json["Type"] != null) {
      type = UserItem.fromJson(json["Type"]);
    }
    if(json["Execute"] != null) {
      idExecute = UserItem.fromJson(json["Execute"]);
    }
    if(json["CreatedBy"] != null) {
      idCreatedBy = UserItem.fromJson(json["CreatedBy"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PageIndex'] = this.pageIndex;
    data["JobName"] = this.jobName;
    data["StartDate"] = this.startDate;
    data["EndDate"] = this.endDate;
    data["Status"] = this.idStatus?.toJson();
    data["Priority"] = this.priority?.toJson();
    data["IDGroupJob"] = this.idJobGroup;
    data["IDGroupJobCol"] = this.idGroupJobCol;
    data["CoExecute"] = this.idCoExecute?.toJson();
    data["Supervisor"] = this.idSupervisor?.toJson();
    data["Type"] = this.type?.toJson();
    data["Execute"] = this.idExecute?.toJson();
    data["CreatedBy"] = this.idCreatedBy?.toJson();
    return data;
  }
}

import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';

class ListColumnGroupRequest {
  int pageIndex;
  int pageSize;
  String jobName;
  String startDate;
  String endDate;
  int idStatus;
  //mức độ ưu tiên
  UserItem priority;

  //Người phối hợp
  UserItem idCoExecute;

  //ngừoi giám sát
  UserItem idSupervisor;

  //loại công việc
  UserItem type;

  //ngừoi nhận việc
  UserItem idExecute;

  //người giao việc
  UserItem idCreatedBy;

  ListColumnGroupRequest();

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
    if(isNotNullOrEmpty(this.idStatus)) {
      params["IDStatus"] = this.idStatus;
    }
    if (isNotNullOrEmpty(this.priority)) {
      params["Priority"] = this.priority.iD;
    }
    if (isNotNullOrEmpty(this.idCoExecute)) {
      params["IDCoExecute"] = this.idCoExecute.iD;
    }
    if (isNotNullOrEmpty(this.idSupervisor)) {
      params["IDSupervisor"] = this.idSupervisor.iD;
    }
    if (isNotNullOrEmpty(this.type)) {
      params["Type"] = this.type.iD;
    }
    if (isNotNullOrEmpty(this.idExecute)) {
      params["IDExecute"] = this.idExecute.iD;
    }
    if (isNotNullOrEmpty(this.idCreatedBy)) {
      params["IDCreatedBy"] = this.idCreatedBy.iD;
    }
    return params;
  }

  ListColumnGroupRequest.fromJson(Map<String, dynamic> json) {
    pageIndex = json['PageIndex'];
    jobName = json["JobName"];
    startDate = json["StartDate"];
    endDate = json["EndDate"];
    idStatus = json["IDStatus"];
    if(json["Priority"] != null) {
      priority = UserItem.fromJson(json["Priority"]);
    }
    if(json["IDCoExecute"] != null) {
      idCoExecute = UserItem.fromJson(json["IDCoExecute"]);
    }
    if(json["IDSupervisor"] != null) {
      idSupervisor = UserItem.fromJson(json["IDSupervisor"]);
    }
    if(json["Type"] != null) {
      type = UserItem.fromJson(json["Type"]);
    }
    if(json["IDExecute"] != null) {
      idExecute = UserItem.fromJson(json["IDExecute"]);
    }
    if(json["IDCreatedBy"] != null) {
      idCreatedBy = UserItem.fromJson(json["IDCreatedBy"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PageIndex'] = this.pageIndex;
    data["JobName"] = this.jobName;
    data["StartDate"] = this.startDate;
    data["EndDate"] = this.endDate;
    data["IDStatus"] = this.idStatus;
    data["Priority"] = this.priority?.toJson();
    data["IDCoExecute"] = this.idCoExecute?.toJson();
    data["IDSupervisor"] = this.idSupervisor?.toJson();
    data["Type"] = this.type?.toJson();
    data["IDExecute"] = this.idExecute?.toJson();
    data["IDCreatedBy"] = this.idCreatedBy?.toJson();
    return data;
  }
}

class FilterItem {
  int id;
  String name;

  FilterItem({this.id, this.name});
}

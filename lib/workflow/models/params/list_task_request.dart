import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';

class GetListTaskRequest {
  int pageIndex;
  int pageSize;
  int viewType;
  int isDeadLine;
  int typeDeadLine;
  String jobName;
  String startDate;
  String endDate;
  int idStatus; // status cho trạng thái dạng Kanban
  UserItem status; // status cho trạng thái theo dõi ngày kết thúc
  UserItem priority;
  UserItem idJobGroup;
  UserItem idCoExecute;
  UserItem idSupervisor;
  UserItem type;
  UserItem idExecute;
  UserItem idCreatedBy;

  GetListTaskRequest();

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["PageIndex"] = this.pageIndex;
    params["PageSize"] = this.pageSize;
    params["ViewType"] = this.viewType;
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
    if (isNotNullOrEmpty(this.status)) {
      params["IDStatus"] = this.status.iD;
    }
    if(isNotNullOrEmpty(this.isDeadLine)) {
      params["IsDeadLine"] = this.isDeadLine;
    }
    if(isNotNullOrEmpty(this.typeDeadLine)) {
      params["TypeDeadLine"] = this.typeDeadLine;
    }
    if (isNotNullOrEmpty(this.priority)) {
      params["Priority"] = this.priority.iD;
    }
    if (isNotNullOrEmpty(this.idJobGroup)) {
      params["IDJobGroup"] = this.idJobGroup.iD;
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

  GetListTaskRequest.fromJson(Map<String, dynamic> json) {
    pageIndex = json['PageIndex'];
    pageSize = json['PageSize'];
    viewType = json["ViewType"];
    jobName = json["JobName"];
    startDate = json["StartDate"];
    endDate = json["EndDate"];
    idStatus = json["IDStatus"];
    if(json["IDStatus"] != null) {
      status = UserItem.fromJson(json["IDStatus"]);
    }
    isDeadLine = json["IsDeadLine"];
    typeDeadLine = json["TypeDeadLine"];
    if(json["Priority"] != null) {
      priority = UserItem.fromJson(json["Priority"]);
    }
    if(json["IDJobGroup"] != null) {
      idJobGroup = UserItem.fromJson(json["IDJobGroup"]);
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
    data['PageSize'] = this.pageSize;
    data["ViewType"] = this.viewType;
    data["JobName"] = this.jobName;
    data["StartDate"] = this.startDate;
    data["EndDate"] = this.endDate;
    data["IsDeadLine"] = this.isDeadLine;
    data["TypeDeadLine"] = this.typeDeadLine;
    data["IDStatus"] = this.idStatus;
    data["IDStatus"] = this.status?.toJson();
    data["Priority"] = this.priority?.toJson();
    data["IDJobGroup"] = this.idJobGroup?.toJson();
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

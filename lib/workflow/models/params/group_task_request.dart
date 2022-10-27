
import 'package:workflow_manager/base/utils/common_function.dart';

class GroupTaskRequest {
  int status;
  String jobGroupName;
  String startDate;
  String endDate;
  int idJobGroup;
  int pageIndex;
  int pageSize;

  GroupTaskRequest(
      {this.status,
      this.jobGroupName,
      this.startDate,
      this.endDate,
      this.pageIndex,
      this.pageSize});

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(isNotNullOrEmpty(this.status)) {
      params["Status"] = this.status;
    }
    if(isNotNullOrEmpty(this.jobGroupName)) {
      params["JobGroupName"] = this.jobGroupName;
    }
    if(isNotNullOrEmpty(this.startDate)) {
      params["StartDate"] = this.startDate;
    }
    if(isNotNullOrEmpty(this.endDate)) {
      params["EndDate"] = this.endDate;
    }
    if(isNotNullOrEmpty(this.idJobGroup)) {
      params["IDJobGroup"] = this.idJobGroup;
    }
    params["PageIndex"] = this.pageIndex;
    params["PageSize"] = this.pageSize;
    return params;
  }
}

class DeleteGroupTaskRequest {
  String idGroupJobs;

  DeleteGroupTaskRequest({this.idGroupJobs});

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['IDGroupJobs'] = idGroupJobs;
    return params;
  }
}

class ChangeStatusRequest {
  int status;
  String idGroupJobs;

  ChangeStatusRequest({this.status, this.idGroupJobs});

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['Status'] = status;
    params['IDGroupJobs'] = idGroupJobs;
    return params;
  }
}
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';

class TaskIndexModelResponse extends BaseResponse {

  TaskIndexData data;

  TaskIndexModelResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new TaskIndexData.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class TaskIndexData {
  List<TaskIndexItem> result;
  int jobCount;

  TaskIndexData({this.result, this.jobCount});

  TaskIndexData.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<TaskIndexItem>();
      json['result'].forEach((v) {
        result.add(new TaskIndexItem.fromJson(v));
      });
    }
    jobCount = json['JobCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    data['JobCount'] = this.jobCount;
    return data;
  }
}

class TaskIndexItem {
  int type;
  int jobID;
  String jobName;
  String createdByName;
  String createdByAvatar;
  String executeAvatar;
  String executeName;
  String coexecutorName;
  StatusItem jobStatus;
  String endDate;
  double percentCompleted;
  String colorPercentCompleted;
  int jobCount;
  PriorityData priority;

  TaskIndexItem(
      {this.type,
      this.jobID,
      this.jobName,
      this.createdByName,
      this.createdByAvatar,
      this.executeAvatar,
      this.executeName,
      this.coexecutorName,
      this.jobStatus,
      this.endDate,
      this.percentCompleted,
      this.colorPercentCompleted,
      this.jobCount,
      this.priority});

  TaskIndexItem.fromJson(Map<String, dynamic> json) {
    type = json['Type'];
    jobID = json['JobID'];
    jobName = json['JobName'];
    createdByName = json['CreatedByName'];
    createdByAvatar = json['CreatedByAvatar'];
    executeAvatar = json['ExecuteAvatar'];
    executeName = json['ExecuteName'];
    coexecutorName = json['CoexecutorName'];
    jobStatus = json['JobStatus'] != null
        ? new StatusItem.fromJson(json['JobStatus'])
        : null;
    endDate = json['EndDate'];
    percentCompleted = json['PercentCompleted'];
    colorPercentCompleted = json['ColorPercentCompleted'];
    jobCount = json['JobCount'];
    priority = json['Priority'] != null
        ? new PriorityData.fromJson(json['Priority'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Type'] = this.type;
    data['JobID'] = this.jobID;
    data['JobName'] = this.jobName;
    data['CreatedByName'] = this.createdByName;
    data['CreatedByAvatar'] = this.createdByAvatar;
    data['ExecuteAvatar'] = this.executeAvatar;
    data['ExecuteName'] = this.executeName;
    data['CoexecutorName'] = this.coexecutorName;
    if (this.jobStatus != null) {
      data['JobStatus'] = this.jobStatus.toJson();
    }
    data['EndDate'] = this.endDate;
    data['PercentCompleted'] = this.percentCompleted;
    data['ColorPercentCompleted'] = this.colorPercentCompleted;
    data['JobCount'] = this.jobCount;
    data['Priority'] = this.priority;
    return data;
  }
}
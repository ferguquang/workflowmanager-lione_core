import 'package:workflow_manager/base/models/base_response.dart';

class SubTaskResponse extends BaseResponse {
  // int status;
  List<SubTaskModel> data;
  // List<String> messages;

  // SubTaskResponse({this.status, this.data, this.messages});

  SubTaskResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    // status = json['Status'];
    if (json['Data'] != null) {
      data = new List<SubTaskModel>();
      json['Data'].forEach((v) {
        data.add(new SubTaskModel.fromJson(v));
      });
    }
    // messages = json['Messages'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    // data['Messages'] = this.messages;
    return data;
  }
}

class SubTaskModel {
  PriorityAPI priorityAPI;
  String assigner;
  String executer;
  String supervisor;
  String coExecuter;
  Job job;
  String jobType;

  SubTaskModel(
      {this.priorityAPI,
      this.assigner,
      this.executer,
      this.supervisor,
      this.coExecuter,
      this.job,
      this.jobType});

  SubTaskModel.fromJson(Map<String, dynamic> json) {
    priorityAPI = json['PriorityAPI'] != null
        ? new PriorityAPI.fromJson(json['PriorityAPI'])
        : null;
    assigner = json['Assigner'];
    executer = json['Executer'];
    supervisor = json['Supervisor'];
    coExecuter = json['CoExecuter'];
    job = json['Job'] != null ? new Job.fromJson(json['Job']) : null;
    jobType = json['JobType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.priorityAPI != null) {
      data['PriorityAPI'] = this.priorityAPI.toJson();
    }
    data['Assigner'] = this.assigner;
    data['Executer'] = this.executer;
    data['Supervisor'] = this.supervisor;
    data['CoExecuter'] = this.coExecuter;
    if (this.job != null) {
      data['Job'] = this.job.toJson();
    }
    data['JobType'] = this.jobType;
    return data;
  }
}

class PriorityAPI {
  int key;
  String value;

  PriorityAPI({this.key, this.value});

  PriorityAPI.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['Value'] = this.value;
    return data;
  }
}

class Job {
  int iD;
  int iDChannel;
  int iDGroupJob;
  int iDExecutor;
  int iDOrk;
  int type;
  String name;
  String describe;
  int priority;
  String created;
  int createdBy;
  String startDate;
  String endDate;
  int status;

  Job(
      {this.iD,
      this.iDChannel,
      this.iDGroupJob,
      this.iDExecutor,
      this.iDOrk,
      this.type,
      this.name,
      this.describe,
      this.priority,
      this.created,
      this.createdBy,
      this.startDate,
      this.endDate,
      this.status});

  Job.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDGroupJob = json['IDGroupJob'];
    iDExecutor = json['IDExecutor'];
    iDOrk = json['IDOrk'];
    type = json['Type'];
    name = json['Name'];
    describe = json['Describe'];
    priority = json['Priority'];
    created = json['Created'];
    createdBy = json['CreatedBy'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['IDGroupJob'] = this.iDGroupJob;
    data['IDExecutor'] = this.iDExecutor;
    data['IDOrk'] = this.iDOrk;
    data['Type'] = this.type;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['Priority'] = this.priority;
    data['Created'] = this.created;
    data['CreatedBy'] = this.createdBy;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['Status'] = this.status;
    return data;
  }
}

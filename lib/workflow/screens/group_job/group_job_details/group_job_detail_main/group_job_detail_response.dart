import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/response/filter_task_response.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_edit_respone.dart';

class GroupJobDetailReponse extends BaseResponse {
  GroupJobDetailModel data;

  GroupJobDetailReponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new GroupJobDetailModel.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    data['Messages'] = this.messages;
    return data;
  }
}

class GroupJobDetailModel {
  int iD;
  String name;
  String describe;
  String startDate;
  String endDate;
  List<Priorities> listPriority;
  Priorities currentPriority;
  int totalMember;
  int totalFile;
  CurrentStatus currentStatus;
  List<ListStatus> listStatus;
  int role;

  GroupJobDetailModel(
      {this.iD,
      this.name,
      this.describe,
      this.startDate,
      this.endDate,
      this.listPriority,
      this.currentPriority,
      this.totalMember,
      this.totalFile,
      this.currentStatus,
      this.listStatus,
      this.role});

  GroupJobDetailModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    describe = json['Describe'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    if (json['ListPriority'] != null) {
      listPriority = new List<Priorities>();
      json['ListPriority'].forEach((v) {
        listPriority.add(new Priorities.fromJson(v));
      });
    }
    currentPriority = json['CurrentPriority'] != null
        ? new Priorities.fromJson(json['CurrentPriority'])
        : null;
    totalMember = json['TotalMember'];
    totalFile = json['TotalFile'];
    currentStatus = json['CurrentStatus'] != null
        ? new CurrentStatus.fromJson(json['CurrentStatus'])
        : null;
    if (json['ListStatus'] != null) {
      listStatus = new List<ListStatus>();
      json['ListStatus'].forEach((v) {
        listStatus.add(new ListStatus.fromJson(v));
      });
    }
    role = json['Role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    if (this.listPriority != null) {
      data['ListPriority'] = this.listPriority.map((v) => v.toJson()).toList();
    }
    if (this.currentPriority != null) {
      data['CurrentPriority'] = this.currentPriority.toJson();
    }
    data['TotalMember'] = this.totalMember;
    data['TotalFile'] = this.totalFile;
    if (this.currentStatus != null) {
      data['CurrentStatus'] = this.currentStatus.toJson();
    }
    if (this.listStatus != null) {
      data['ListStatus'] = this.listStatus.map((v) => v.toJson()).toList();
    }
    data['Role'] = this.role;
    return data;
  }
}

class CurrentStatus {
  int key;
  String value;
  String color;

  CurrentStatus({this.key, this.value, this.color});

  CurrentStatus.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    value = json['Value'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['Value'] = this.value;
    data['Color'] = this.color;
    return data;
  }
}

import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/response/filter_task_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';

class GetDataForCreateJobResponse extends BaseResponse {
  GetDataForCreateJobModel data;

  GetDataForCreateJobResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new GetDataForCreateJobModel.fromJson(json['Data'])
        : null;
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

class GetDataForCreateJobModel {
  List<Priorities> priorities;
  SharedSearchModel jobGroups;
  SharedSearchModel groupJobCol;

  GetDataForCreateJobModel({this.priorities, this.jobGroups, this.groupJobCol});

  GetDataForCreateJobModel.fromJson(Map<String, dynamic> json) {
    if (json['Priorities'] != null) {
      priorities = new List<Priorities>();
      json['Priorities'].forEach((v) {
        priorities.add(new Priorities.fromJson(v));
      });
    }
    jobGroups = json['JobGroups'] != null
        ? new SharedSearchModel.fromJson(json['JobGroups'])
        : null;
    groupJobCol = json['GroupJobCol'] != null
        ? new SharedSearchModel.fromJson(json['GroupJobCol'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.priorities != null) {
      data['Priorities'] = this.priorities.map((v) => v.toJson()).toList();
    }
    if (this.jobGroups != null) {
      data['JobGroups'] = this.jobGroups.toJson();
    }
    if (this.groupJobCol != null) {
      data['GroupJobCol'] = this.groupJobCol.toJson();
    }
    return data;
  }
}

// class GroupJobCol {
//   int iD;
//   String colTitle;
//
//   GroupJobCol({this.iD, this.colTitle});
//
//   GroupJobCol.fromJson(Map<String, dynamic> json) {
//     iD = json['ID'];
//     colTitle = json['Name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ID'] = this.iD;
//     data['Name'] = this.colTitle;
//     return data;
//   }
// }

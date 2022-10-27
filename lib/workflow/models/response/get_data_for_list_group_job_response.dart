import 'package:workflow_manager/base/models/base_response.dart';

class GetDataForListGroupJobResponse extends BaseResponse {
  // int status;
  List<DataGroupJobItem> data;
  // List<Message> messages;

  // GetDataForListGroupJobResponse({this.status, this.data, this.messages});

  GetDataForListGroupJobResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    // status = json['Status'];
    if (json['Data'] != null) {
      data = new List<DataGroupJobItem>();
      json['Data'].forEach((v) {
        data.add(new DataGroupJobItem.fromJson(v));
      });
    }
    // if (json['Messages'] != null) {
    //   messages = new List<Message>();
    //   json['Messages'].forEach((v) {
    //     messages.add(new Message.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    // if (this.messages != null) {
    //   data['Messages'] = this.messages.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class DataGroupJobItem {
  int id;
  String jobGroupName;
  int totalMember;
  int performance;
  int totalJob;
  bool isManager;
  int rate;

  DataGroupJobItem(
      {this.id,
      this.jobGroupName,
      this.totalMember,
      this.performance,
      this.totalJob,
      this.isManager,
      this.rate});

  DataGroupJobItem.fromJson(Map<String, dynamic> json) {
    id = json["ID"];
    jobGroupName = json['JobGroupName'];
    totalMember = json['TotalMember'];
    performance = json['Performance'];
    totalJob = json['TotalJob'];
    isManager = json['IsManager'];
    rate = json['Rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobGroupName'] = this.jobGroupName;
    data['TotalMember'] = this.totalMember;
    data['Performance'] = this.performance;
    data['TotalJob'] = this.totalJob;
    data['IsManager'] = this.isManager;
    data["ID"] = this.id;
    data["Rate"] = this.rate;
    return data;
  }
}

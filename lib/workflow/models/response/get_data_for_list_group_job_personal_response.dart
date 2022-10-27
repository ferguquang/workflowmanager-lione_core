import 'package:workflow_manager/base/models/base_response.dart';

class GetDataForListGroupJobPesonalResponse extends BaseResponse {
  // int status;
  List<DataGroupJobPersonal> data;
  // List<Message> messages;

  // GetDataForListGroupJobPesonalResponse(
  //     {this.status, this.data, this.messages});

  GetDataForListGroupJobPesonalResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    // status = json['Status'];
    if (json['Data'] != null) {
      data = new List<DataGroupJobPersonal>();
      json['Data'].forEach((v) {
        data.add(new DataGroupJobPersonal.fromJson(v));
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

class DataGroupJobPersonal {
  String jobName;
  int percentComplete;
  int rate;

  DataGroupJobPersonal({this.jobName, this.percentComplete, this.rate});

  DataGroupJobPersonal.fromJson(Map<String, dynamic> json) {
    jobName = json['JobName'];
    percentComplete = json['PercentComplete'];
    rate = json['Rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobName'] = this.jobName;
    data['PercentComplete'] = this.percentComplete;
    data['Rate'] = this.rate;
    return data;
  }
}

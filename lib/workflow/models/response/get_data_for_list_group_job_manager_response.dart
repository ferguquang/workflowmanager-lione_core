import 'package:workflow_manager/base/models/base_response.dart';

class GetDataForListGroupJobManagerResponse extends BaseResponse {
  // int status;
  List<DataMemberItem> data;
  // List<Message> messages;

  // GetDataForListGroupJobManagerResponse(
  //     {this.status, this.data, this.messages});

  GetDataForListGroupJobManagerResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    // status = json['Status'];
    if (json['Data'] != null) {
      data = new List<DataMemberItem>();
      json['Data'].forEach((v) {
        data.add(new DataMemberItem.fromJson(v));
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

class DataMemberItem {
  int iD;
  String name;
  int totalJob;

  DataMemberItem({this.iD, this.name, this.totalJob});

  DataMemberItem.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    totalJob = json['TotalJob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['TotalJob'] = this.totalJob;
    return data;
  }
}

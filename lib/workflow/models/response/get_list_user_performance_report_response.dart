import 'package:workflow_manager/base/models/base_response.dart';

class GetListUserPerformanceReportResponse extends BaseResponse {
  // int status;
  List<DataUserReportItem> data;
  // List<Message> messages;

  // GetListUserPerformanceReportResponse({this.status, this.data, this.messages});

  GetListUserPerformanceReportResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    // status = json['Status'];
    if (json['Data'] != null) {
      data = new List<DataUserReportItem>();
      json['Data'].forEach((v) {
        data.add(new DataUserReportItem.fromJson(v));
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

class DataUserReportItem {
  String userName;
  int rate;
  int performance;

  DataUserReportItem({this.userName, this.rate, this.performance});

  DataUserReportItem.fromJson(Map<String, dynamic> json) {
    userName = json['UserName'];
    rate = json['Rate'];
    performance = json['Performance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserName'] = this.userName;
    data['Rate'] = this.rate;
    data['Performance'] = this.performance;
    return data;
  }
}

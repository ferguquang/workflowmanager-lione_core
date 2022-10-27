import 'package:workflow_manager/base/models/base_response.dart';

class ResponseReportIndex extends BaseResponse {
  DataReportIndex data;

  ResponseReportIndex.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null ? new DataReportIndex.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }

    return data;
  }
}

class DataReportIndex {
  int iD;
  String userName;
  String deptName;
  String position;
  String userCode;
  String phoneNumber;
  String email;
  String imgSrc;
  int performance;
  int rate;

  DataReportIndex(
      {this.iD,
        this.userName,
        this.deptName,
        this.position,
        this.userCode,
        this.phoneNumber,
        this.email,
        this.imgSrc,
        this.performance,
        this.rate});

  DataReportIndex.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    userName = json['UserName'];
    deptName = json['DeptName'];
    position = json['Position'];
    userCode = json['UserCode'];
    phoneNumber = json['PhoneNumber'];
    email = json['Email'];
    imgSrc = json['ImgSrc'];
    performance = json['Performance'];
    rate = json['Rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['UserName'] = this.userName;
    data['DeptName'] = this.deptName;
    data['Position'] = this.position;
    data['UserCode'] = this.userCode;
    data['PhoneNumber'] = this.phoneNumber;
    data['Email'] = this.email;
    data['ImgSrc'] = this.imgSrc;
    data['Performance'] = this.performance;
    data['Rate'] = this.rate;
    return data;
  }
}

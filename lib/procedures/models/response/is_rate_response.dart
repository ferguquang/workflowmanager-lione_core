import 'package:workflow_manager/base/models/base_response.dart';

class IsRateServiceRecordResponse extends BaseResponse {
  DataIsRateService data;

  IsRateServiceRecordResponse.fromJson(Map<String, dynamic> json)  : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null ? new DataIsRateService.fromJson(json['Data']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }

    return data;
  }
}

class DataIsRateService {
  int iDServiceRecord;
  String name;
  int iDService;
  int iDServiceRecordRate;
  String content;
  int star;
  List<RateLevels> rateLevels;
  int redirectType;

  DataIsRateService(
      {this.iDServiceRecord,
        this.name,
        this.iDService,
        this.iDServiceRecordRate,
        this.content,
        this.star,
        this.rateLevels,
        this.redirectType});

  DataIsRateService.fromJson(Map<String, dynamic> json) {
    iDServiceRecord = json['IDServiceRecord'];
    name = json['Name'];
    iDService = json['IDService'];
    iDServiceRecordRate = json['IDServiceRecordRate'];
    content = json['Content'];
    star = json['Star'];
    if (json['RateLevels'] != null) {
      rateLevels = new List<RateLevels>();
      json['RateLevels'].forEach((v) {
        rateLevels.add(new RateLevels.fromJson(v));
      });
    }
    redirectType = json['RedirectType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDServiceRecord'] = this.iDServiceRecord;
    data['Name'] = this.name;
    data['IDService'] = this.iDService;
    data['IDServiceRecordRate'] = this.iDServiceRecordRate;
    data['Content'] = this.content;
    data['Star'] = this.star;
    if (this.rateLevels != null) {
      data['RateLevels'] = this.rateLevels.map((v) => v.toJson()).toList();
    }
    data['RedirectType'] = this.redirectType;
    return data;
  }
}

class RateLevels {
  String action;
  String color;

  bool isSelected = false;

  RateLevels({this.action, this.color, this.isSelected});

  RateLevels.fromJson(Map<String, dynamic> json) {
    action = json['Action'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Action'] = this.action;
    data['Color'] = this.color;
    return data;
  }
}

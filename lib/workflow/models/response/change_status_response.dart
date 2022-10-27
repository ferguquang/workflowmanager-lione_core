import 'package:workflow_manager/base/models/base_response.dart';

import 'list_status_response.dart';

class ChangeStatusResponse extends BaseResponse {

  StatusItem data;

  ChangeStatusResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null ? new StatusItem.fromJson(json['Data']) : null;
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

class ChangeStatusData {
  int key;
  String describe;
  String color;
  bool isPopup;
  bool isRate;
  bool isCanChange;

  ChangeStatusData({this.key,
    this.describe,
    this.color,
    this.isPopup,
    this.isRate,
    this.isCanChange});

  ChangeStatusData.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    describe = json['Describe'];
    color = json['Color'];
    isPopup = json['IsPopup'];
    isRate = json['IsRate'];
    isCanChange = json['IsCanChange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['Describe'] = this.describe;
    data['Color'] = this.color;
    data['IsPopup'] = this.isPopup;
    data['IsRate'] = this.isRate;
    data['IsCanChange'] = this.isCanChange;
    return data;
  }
}

class Messages {
  int code;
  String text;

  Messages({this.code, this.text});

  Messages.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['text'] = this.text;
    return data;
  }
}

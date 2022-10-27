import 'package:workflow_manager/base/models/base_response.dart';

class ListStatusResponse extends BaseResponse {

  StatusData data;

  ListStatusResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new StatusData.fromJson(json['Data']) : null;
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

class StatusData {
  List<StatusItem> result;
  bool isRate;

  StatusData({this.result, this.isRate});

  StatusData.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<StatusItem>();
      json['result'].forEach((v) {
        result.add(new StatusItem.fromJson(v));
      });
    }
    isRate = json['IsRate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    data['IsRate'] = this.isRate;
    return data;
  }
}

class StatusItem {
  int key;
  int total;
  String value;
  String describe;
  String color;
  bool isPopup;
  bool isRate;
  bool isCanChange;
  bool isSelected = false;

  StatusItem(
      {this.key,
        this.total,
      this.describe,
      this.color,
      this.value,
      this.isPopup,
      this.isRate,
      this.isCanChange,
      this.isSelected = false});

  StatusItem.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    total = json['Total'];
    describe = json['Describe'];
    value = json['Value'];
    color = json['Color'];
    isPopup = json['IsPopup'];
    isRate = json['IsRate'];
    isCanChange = json['IsCanChange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['Total'] = this.total;
    data['Value'] = this.value;
    data['Describe'] = this.describe;
    data['Color'] = this.color;
    data['IsPopup'] = this.isPopup;
    data['IsRate'] = this.isRate;
    data['IsCanChange'] = this.isCanChange;
    return data;
  }
}

class PriorityData {
  String priorityName;
  String color;

  PriorityData({
    this.priorityName,
    this.color,
  });

  PriorityData.fromJson(Map<String, dynamic> json) {
    priorityName = json['PriorityName'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PriorityName'] = this.priorityName;
    data['Color'] = this.color;
    return data;
  }
}

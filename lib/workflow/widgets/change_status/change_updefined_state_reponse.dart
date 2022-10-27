import 'package:workflow_manager/base/models/base_response.dart';

class ChangeUndefinedStatusResponse extends BaseResponse {
  int status;
  ChangeUndefinedStatusModel data;

  ChangeUndefinedStatusResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new ChangeUndefinedStatusModel.fromJson(json['Data'])
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

class ChangeUndefinedStatusModel {
  int key;
  String value;
  String color;
  bool isPopup;
  bool isRate;
  bool isCanChange;

  ChangeUndefinedStatusModel(
      {this.key,
      this.value,
      this.color,
      this.isPopup,
      this.isRate,
      this.isCanChange});

  ChangeUndefinedStatusModel.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    value = json['Value'];
    color = json['Color'];
    isPopup = json['IsPopup'];
    isRate = json['IsRate'];
    isCanChange = json['IsCanChange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['Value'] = this.value;
    data['Color'] = this.color;
    data['IsPopup'] = this.isPopup;
    data['IsRate'] = this.isRate;
    data['IsCanChange'] = this.isCanChange;
    return data;
  }
}

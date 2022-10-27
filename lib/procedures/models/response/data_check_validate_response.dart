import 'package:workflow_manager/base/models/base_response.dart';

class DataCheckValidateResponse extends BaseResponse {
  int status;
  DataCheckValidate data;

  DataCheckValidateResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new DataCheckValidate.fromJson(json['Data'])
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



class DataCheckValidate {
  int code;
  String text;
  String value;
  bool isPass = true;

  DataCheckValidate.fromJson(Map<String, dynamic> json) {
    code = json['Code'];
    text = json['Text'];
    value = json['Value'];
    isPass = json['IsPass'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['Code'] = code;
    json['Text'] = text;
    json['Value'] = value;
    json['IsPass'] = isPass;
    return json;
  }
}

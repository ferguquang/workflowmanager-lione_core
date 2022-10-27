import 'package:workflow_manager/base/models/base_response.dart';

class SharedSearchReponse extends BaseResponse {
  List<SharedSearchModel> data;

  SharedSearchReponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = new List<SharedSearchModel>();
      json['Data'].forEach((v) {
        data.add(new SharedSearchModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['Messages'] = this.messages;
    return data;
  }
}

class SharedSearchModel {
  int iD;
  String name;
  bool isCheck = false;

  SharedSearchModel({this.iD, this.name});

  SharedSearchModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    return data;
  }
}

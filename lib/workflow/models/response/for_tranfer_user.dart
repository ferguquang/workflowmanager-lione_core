import 'package:workflow_manager/base/models/base_response.dart';

class ForTransferUserResponse extends BaseResponse {
  List<DataForTranferUserModel> data;

  ForTransferUserResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['Data'] != null) {
      data = new List<DataForTranferUserModel>();
      json['Data'].forEach((v) {
        data.add(new DataForTranferUserModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DataForTranferUserModel {
  int iD;
  String describe;
  String created;

  DataForTranferUserModel({this.iD, this.describe, this.created});

  DataForTranferUserModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    describe = json['Describe'];
    created = json['Created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Describe'] = this.describe;
    data['Created'] = this.created;
    return data;
  }
}

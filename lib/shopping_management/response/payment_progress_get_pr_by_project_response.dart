import 'package:workflow_manager/base/models/base_response.dart';

import 'payment_progress_response.dart';

class PaymentProgressGetPrByProjectResponse extends BaseResponse {
  int status;
  PaymentProgressGetPrByProjectModel data;

  PaymentProgressGetPrByProjectResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new PaymentProgressGetPrByProjectModel.fromJson(json['Data'])
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

class PaymentProgressGetPrByProjectModel {
  List<PRCodes> pRCodes;
  List<POCodes> pOCodes;

  PaymentProgressGetPrByProjectModel({this.pRCodes, this.pOCodes});

  PaymentProgressGetPrByProjectModel.fromJson(Map<String, dynamic> json) {
    if (json['PRCodes'] != null) {
      pRCodes = new List<PRCodes>();
      json['PRCodes'].forEach((v) {
        pRCodes.add(new PRCodes.fromJson(v));
      });
    }
    if (json['POCodes'] != null) {
      pOCodes = new List<POCodes>();
      json['POCodes'].forEach((v) {
        pOCodes.add(new POCodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pRCodes != null) {
      data['PRCodes'] = this.pRCodes.map((v) => v.toJson()).toList();
    }
    if (this.pOCodes != null) {
      data['POCodes'] = this.pOCodes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

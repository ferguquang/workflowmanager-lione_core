import 'package:workflow_manager/base/models/base_response.dart';

import 'payment_progress_response.dart';

class PaymentProgressGetPoByPrResponse extends BaseResponse {
  int status;
  PaymentProgressGetPoByPrModel data;

  PaymentProgressGetPoByPrResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new PaymentProgressGetPoByPrModel.fromJson(json['Data'])
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

class PaymentProgressGetPoByPrModel {
  List<POCodes> pOCodes;

  PaymentProgressGetPoByPrModel({this.pOCodes});

  PaymentProgressGetPoByPrModel.fromJson(Map<String, dynamic> json) {
    if (json['POCodes'] != null) {
      pOCodes = new List<POCodes>();
      json['POCodes'].forEach((v) {
        pOCodes.add(new POCodes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pOCodes != null) {
      data['POCodes'] = this.pOCodes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

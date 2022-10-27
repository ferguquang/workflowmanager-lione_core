import 'package:workflow_manager/base/models/base_response.dart';

import 'delivery_list_response.dart';

class DeliveryPRResponse extends BaseResponse {
  int status;
  DeliveryPRModel data;

  DeliveryPRResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new DeliveryPRModel.fromJson(json['Data'])
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

class DeliveryPRModel {
  List<Requisitions> requisitions;

  DeliveryPRModel({this.requisitions});

  DeliveryPRModel.fromJson(Map<String, dynamic> json) {
    if (json['Requisitions'] != null) {
      requisitions = new List<Requisitions>();
      json['Requisitions'].forEach((v) {
        requisitions.add(new Requisitions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.requisitions != null) {
      data['Requisitions'] = this.requisitions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

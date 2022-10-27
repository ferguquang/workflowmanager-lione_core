import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/shopping_management/response/progress_report_response.dart';

class ProgressReportPRResponse extends BaseResponse {
  int status;
  DeliveryPRModel data;

  ProgressReportPRResponse.fromJson(Map<String, dynamic> json)
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
  List<SearchObject> requisitions;

  DeliveryPRModel({this.requisitions});

  DeliveryPRModel.fromJson(Map<String, dynamic> json) {
    if (json['Requisitions'] != null) {
      requisitions = new List<SearchObject>();
      json['Requisitions'].forEach((v) {
        requisitions.add(new SearchObject.fromJson(v));
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

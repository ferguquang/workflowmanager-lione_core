import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/shopping_management/response/serial_detail_update_response.dart';

class ContractsByRequisitionResponse extends BaseResponse {
  int status;
  Data data;

  ContractsByRequisitionResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
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

class Data {
  List<Requisitions> contracts;

  Data({this.contracts});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Contracts'] != null) {
      contracts = new List<Requisitions>();
      json['Contracts'].forEach((v) {
        contracts.add(new Requisitions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contracts != null) {
      data['Contracts'] = this.contracts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

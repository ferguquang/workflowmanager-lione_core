import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/shopping_management/response/delivery_list_response.dart';

class GetContractByRequisitionResponse extends BaseResponse {
  int status;
  GetContractByRequisitionModel data;

  GetContractByRequisitionResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new GetContractByRequisitionModel.fromJson(json['Data'])
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

class GetContractByRequisitionModel {
  List<SearchContract> contracts;

  GetContractByRequisitionModel({this.contracts});

  GetContractByRequisitionModel.fromJson(Map<String, dynamic> json) {
    if (json['Contracts'] != null) {
      contracts = [];
      json['Contracts'].forEach((v) {
        contracts.add(new SearchContract.fromJson(v));
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

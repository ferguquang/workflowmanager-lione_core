import 'package:workflow_manager/base/models/base_response.dart';

import 'detail_contract_response.dart';

class ContractStagePaymentResponse extends BaseResponse {
  DataContractStagePayment data;

  ContractStagePaymentResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataContractStagePayment.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    return data;
  }
}

class DataContractStagePayment {
  ContractPayments contractPaymentStatus;

  DataContractStagePayment({this.contractPaymentStatus});

  DataContractStagePayment.fromJson(Map<String, dynamic> json) {
    contractPaymentStatus = json['ContractPayment'] != null
        ? new ContractPayments.fromJson(json['ContractPayment'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contractPaymentStatus != null) {
      data['ContractPayment'] = this.contractPaymentStatus.toJson();
    }
    return data;
  }
}

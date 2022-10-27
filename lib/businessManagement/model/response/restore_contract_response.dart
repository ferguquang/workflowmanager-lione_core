import 'package:workflow_manager/base/models/base_response.dart';

import 'detail_management_response.dart';

class RestoreContractResponse extends BaseResponse {
  DataContractRestore data;

  RestoreContractResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataContractRestore.fromJson(json['Data'])
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

class DataContractRestore {
  Contracts contract;

  DataContractRestore({
    this.contract,
  });

  DataContractRestore.fromJson(Map<String, dynamic> json) {
    contract = Contracts.fromJson(json['Contract']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Contract'] = this.contract;
  }
}

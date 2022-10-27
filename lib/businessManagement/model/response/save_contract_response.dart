import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';

class SaveContractResponse extends BaseResponse {
  DataSaveContract data;

  SaveContractResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataSaveContract.fromJson(json['Data'])
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

class DataSaveContract {
  Contracts contract;

  DataSaveContract({this.contract});

  DataSaveContract.fromJson(Map<String, dynamic> json) {
    contract = json['Contract'] != null
        ? new Contracts.fromJson(json['Contract'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.contract != null) {
      data['Contract'] = this.contract.toJson();
    }
    return data;
  }
}

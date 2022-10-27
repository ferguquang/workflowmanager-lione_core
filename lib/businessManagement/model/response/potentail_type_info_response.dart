import 'package:workflow_manager/base/models/base_response.dart';

class PotentialTypeInfoResponse extends BaseResponse {
  DataPotentialTypeInfo data;

  PotentialTypeInfoResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataPotentialTypeInfo.fromJson(json['Data'])
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

class DataPotentialTypeInfo {
  PotentialType potentialType;

  DataPotentialTypeInfo({this.potentialType});

  DataPotentialTypeInfo.fromJson(Map<String, dynamic> json) {
    potentialType = json['PotentialType'] != null
        ? new PotentialType.fromJson(json['PotentialType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.potentialType != null) {
      data['PotentialType'] = this.potentialType.toJson();
    }
    return data;
  }
}

class PotentialType {
  int successPercent;
  String describe;

  PotentialType({this.successPercent, this.describe});

  PotentialType.fromJson(Map<String, dynamic> json) {
    successPercent = json['SuccessPercent'];
    describe = json['Describe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SuccessPercent'] = this.successPercent;
    data['Describe'] = this.describe;
    return data;
  }
}

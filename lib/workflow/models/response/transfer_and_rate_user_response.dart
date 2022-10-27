import 'package:workflow_manager/base/models/base_response.dart';

class TransferAndRateUserResponse extends BaseResponse {
  int data;

  TransferAndRateUserResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Data'] = this.data;
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

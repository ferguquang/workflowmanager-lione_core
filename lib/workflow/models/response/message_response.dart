import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/message.dart';

class MessageResponse extends BaseResponse {

  bool booleanValue;

  MessageResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    booleanValue = json['Data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    data['Data'] = this.booleanValue;
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class ResponseMessage extends BaseResponse {
  ResponseMessage.fromJson(Map<String, dynamic> json) : super.fromJson(json);
}

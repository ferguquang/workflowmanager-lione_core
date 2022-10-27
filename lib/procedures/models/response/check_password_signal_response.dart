import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/response/data_warning.dart';

class CheckPasswordSignalResponse extends BaseResponse {
  int status;
  bool data;

  CheckPasswordSignalResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null ? json['Data']["IsValidatePass"] : null;
  }

// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   data['Status'] = this.status;
//   if (this.data != null) {
//     data['Data'] = this.data;
//   }
//   if (this.messages != null) {
//     data['Messages'] = this.messages;
//   }
//   return data;
// }
}

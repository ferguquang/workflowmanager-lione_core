import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/response/handler_info.dart';
import 'package:workflow_manager/procedures/models/response/position.dart';
import 'package:workflow_manager/procedures/models/response/user.dart';

class ContentMapResponse extends BaseResponse {
  Map<String, dynamic> data;

  ContentMapResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'];
  }
}

import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';

class RecordSaveInfoStepFsResponse extends BaseResponse {
  RegisterAttachedFiles data;

  RecordSaveInfoStepFsResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new RegisterAttachedFiles.fromJson(json['Data']) : null;
  }
}
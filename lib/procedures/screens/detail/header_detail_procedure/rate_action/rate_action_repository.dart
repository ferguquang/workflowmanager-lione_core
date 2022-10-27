import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/params/rate_action_request.dart';
import 'package:workflow_manager/procedures/models/response/is_rate_response.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';

class RateActionRepository with ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  DataIsRateService _dataIsRateService;

  DataIsRateService get dataIsRateService => _dataIsRateService;

  Future<void> ratingIsRateServiceRecord(int idServiceRecord) async {
    IsRateServiceRequest isRateServiceRequest = IsRateServiceRequest(idServiceRecord: idServiceRecord);
    var response = await ApiCaller.instance.postFormData(AppUrl.ratingIsRateServiceRecord, isRateServiceRequest.getParams(), isLoading: true);
    IsRateServiceRecordResponse isRateServiceRecordResponse = IsRateServiceRecordResponse.fromJson(response);
    if (isRateServiceRecordResponse.status == 1) {
      _dataIsRateService = isRateServiceRecordResponse.data;
      notifyListeners();
    }
  }

  Future<void> ratingSaveRateServiceRecord(SaveRateServiceRequest request) async {
    var response = await ApiCaller.instance.postFormData(AppUrl.ratingSaveRateServiceRecord, request.getParams(), isLoading: true);
    ResponseMessage responseMessage = ResponseMessage.fromJson(response);
    ToastMessage.show(responseMessage.messages, responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
  }
}
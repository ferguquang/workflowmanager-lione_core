import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/businessManagement/model/request/add_comments_request.dart';
import 'package:workflow_manager/businessManagement/model/response/add_comments_response.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';

class CommentsOpportunityRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  // xóa
  Future<bool> getDeleteCommentsOpportunity(
      int id, bool isOpportunityAndContract) async {
    Map<String, dynamic> params = Map();
    params["ID"] = id;

    // cơ hội: true, hợp đồng false
    final response = await apiCaller.delete(
        isOpportunityAndContract
            ? AppUrl.getDeleteCommentsOpportunity
            : AppUrl.getContractDeleteCmt,
        params,
        isLoading: true);

    var baseResponse = BaseResponse.fromJson(response);

    // if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
    // ToastMessage.show(baseResponse.messages, ToastStyle.success);
    // notifyListeners();
    // return true;
    // }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return false;
    }*/
    baseResponse.isSuccess(isShowSuccessMessage: true);
    return baseResponse.status == 1 ? true : false;
  }

  // comment trả lời
  Future<Comments> getAddCommentsOpportunity(
      int id, String content, bool isOpportunityAndContract) async {
    AddCommentsRequest request = AddCommentsRequest();
    request.body = content;
    request.iDContent = id;

    // cơ hội: true, hợp đồng false
    final response = await apiCaller.postFormData(
        isOpportunityAndContract
            ? AppUrl.getAddCommentsOpportunity
            : AppUrl.getContractAddCmt,
        request.getParams(),
        isLoading: true);

    AddCommentsResponse baseResponse = AddCommentsResponse.fromJson(response);

    // if (baseResponse.isSuccess()) {
    // ToastMessage.show(baseResponse.messages, ToastStyle.success);
    // notifyListeners();
    // return baseResponse.data.comments;
    // }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return null;
    }*/
    baseResponse.isSuccess(isShowSuccessMessage: true);
    return baseResponse.status == baseResponse.status
        ? baseResponse.data.comments
        : null;
  }
}

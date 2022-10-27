import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/workflow/models/params/get_list_process.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';
import 'package:workflow_manager/workflow/models/response/processed_content.dart';

class ProcessedContentRepository with ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  List<ProcessedContent> _listProcessed = [];
  GetListProcessedRequest request = GetListProcessedRequest();

  MessageResponse _responseMessage;

  MessageResponse get responseMessage => _responseMessage;

  List<ProcessedContent> get listProcessed => _listProcessed;

  Future<void> getList() async {
    final responseJSON = await apiCaller.get(AppUrl.listProcessContent,
        params: request.getParams());
    ResponseProcessedContent response =
        ResponseProcessedContent.fromJson(responseJSON);
    if (response.isSuccess()) {
      _listProcessed = response.data;
      notifyListeners();
    }
    /* else {
      ToastMessage.show(response.messages, ToastStyle.error);
    }*/
  }

  Future<void> updateList(List<ProcessedContent> listProcessed) async {
    _listProcessed.clear();
    _listProcessed = listProcessed;
    notifyListeners();
  }

  // Xoá một nội dung đã xử lý trong list
  Future<void> deleteItemProcessed(ProcessedContent content) async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['IDJobHistory'] = content.iD;
    await deleteProcessContent(params);
    _listProcessed.removeWhere((item) => item.iD == content.iD);
    notifyListeners();
  }

  Future<void> deleteProcessContent(Map<String, dynamic> params) async {
    final responseJSON =
        await apiCaller.delete(AppUrl.deleteProcessContent, params);
    _responseMessage = MessageResponse.fromJson(responseJSON);
    notifyListeners();
  }

  Future<void> editProcessContent(
      Map<String, dynamic> params, int position) async {
    final responseJSON =
        await apiCaller.postFormData(AppUrl.editProcessContent, params);
    ResponseAddEditProcessContent response =
        ResponseAddEditProcessContent.fromJson(responseJSON);
    if (response.isSuccess(isShowSuccessMessage: true)) {
      ToastMessage.show('Sửa nội dung thành công', ToastStyle.success);
      ProcessedContent processedContent = response.data;
      listProcessed[listProcessed.indexWhere(
          (element) => element.iD == processedContent.iD)] = processedContent;
      notifyListeners();
    }
    /*else {
      ToastMessage.show(response.messages, ToastStyle.error);
    }*/
  }

  Future<void> addProcessContent(Map<String, dynamic> params) async {
    final responseJSON =
        await apiCaller.postFormData(AppUrl.addProcessContent, params);
    ResponseAddEditProcessContent response =
        ResponseAddEditProcessContent.fromJson(responseJSON);
    if (response.isSuccess(isShowSuccessMessage: true)) {
      ToastMessage.show('Thêm mới nội dung thành công', ToastStyle.success);
      ProcessedContent processedContent = response.data;
      listProcessed.insert(listProcessed.length, processedContent);
      notifyListeners();
    }
    /*else {
      ToastMessage.show(response.messages, ToastStyle.error);
    }*/
  }
}

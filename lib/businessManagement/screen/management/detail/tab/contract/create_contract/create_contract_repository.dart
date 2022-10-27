import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/create_contract_request.dart';
import 'package:workflow_manager/businessManagement/model/request/save_contract_request.dart';
import 'package:workflow_manager/businessManagement/model/response/create_contract_response.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/save_contract_response.dart';

import '../../../../../../../main.dart';

class CreateContractRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  DataCreateContract dataCreateContract;
  DataSaveContract dataSaveContract;

  // Create
  Future<bool> getContractCreate(CreateContractRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getContractCreate, request.getParams(),
        isLoading: true);

    CreateContractResponse baseResponse =
        CreateContractResponse.fromJson(response);

    if (baseResponse.isSuccess()) {
      dataCreateContract = baseResponse.data;
      notifyListeners();
      // return true;
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return false;
    }*/
    return baseResponse.status == 1 ? true : false;
  }

  // update
  Future<bool> getContractUpdate(CreateContractRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.getContractUpdate, request.getParams(),
        isLoading: true);

    CreateContractResponse baseResponse =
        CreateContractResponse.fromJson(response);

    if (baseResponse.isSuccess()) {
      dataCreateContract = baseResponse.data;
      notifyListeners();
      // return true;
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return false;
    }*/
    return baseResponse.status == 1 ? true : false;
  }

  // Save
  Future<bool> getContractSave(
      SaveContractRequest request, bool isCreate) async {
    final response = await apiCaller.postFormData(
        isCreate ? AppUrl.getContractSave : AppUrl.getContractChange,
        request.getParams(),
        isLoading: true);

    SaveContractResponse baseResponse = SaveContractResponse.fromJson(response);

    if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
      dataSaveContract = baseResponse.data;
      notifyListeners();
      // ToastMessage.show(baseResponse.messages, ToastStyle.success);
      eventBus
          .fire(GetDataContractEventBus(dataSaveContract.contract, isCreate));
      // return true;
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return null;
    }*/
    return baseResponse.status == 1 ? true : null;
  }

  // add file
  eventCallBackAddFile(BuildContext context, bool isFile) async {
    var file = await FileUtils.instance.uploadFileFromSdcard(context);
    if (file != null) {
      Attachments model = Attachments(
        fileName: file.fileName,
        filePath: file.filePath,
      );
      if (isFile)
        dataCreateContract?.contract?.attachments?.add(model);
      else {
        if (dataCreateContract?.contract?.attachmentsDeploy == null)
          dataCreateContract?.contract?.attachmentsDeploy = [];
        dataCreateContract?.contract?.attachmentsDeploy?.add(model);
      }

      notifyListeners();
    }
  }

  // xóa file
  eventCallApiDeleteFile(Attachments item, BuildContext context, bool isFile) {
    ConfirmDialogFunction(
        content: 'Bạn có muốn xóa file đính kèm không?',
        context: context,
        onAccept: () {
          if (isFile)
            dataCreateContract?.contract?.attachments?.remove(item);
          else
            dataCreateContract?.contract?.attachmentsDeploy?.remove(item);
          notifyListeners();
        }).showConfirmDialog();
  }
}

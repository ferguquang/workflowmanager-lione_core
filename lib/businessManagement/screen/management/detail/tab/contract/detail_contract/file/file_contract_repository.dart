import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/save_attach_response.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/attach_provider.dart';

class FileContractRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  // add file hơp đồng
  Future<Attachments> eventClickAddFile(
      BuildContext context, int iDTarget) async {
    String fileName, filePath;
    AttachFilesProvider attachFilesProvider = AttachFilesProvider();
    await attachFilesProvider.addFileToLocal(context);
    if (attachFilesProvider.files.length > 0) {
      fileName = attachFilesProvider.files[0].name;
      filePath = attachFilesProvider.files[0].path;
    }

    Map<String, dynamic> params = Map();
    params["ContractFilePath"] = filePath;
    params["ContractFileName"] = fileName;
    params["IDTarget"] = iDTarget;

    final response =
        await apiCaller.delete(AppUrl.getContractSaveAttach, params);

    SaveAttachResponse baseResponse = SaveAttachResponse.fromJson(response);

    if (baseResponse.isSuccess()) {
      ToastMessage.show(baseResponse.messages, ToastStyle.success);
      notifyListeners();
      // return baseResponse.data.attachment;
    }
    /*else {
      ToastMessage.show(baseResponse.messages, ToastStyle.error);
      return null;
    }*/
    baseResponse.isSuccess();
    return baseResponse.status == 1 ? baseResponse.data.attachment : null;
  }

  // xóa hợp đồng
  Future<bool> getDeleteFileOpportunity(int id) async {
    Map<String, dynamic> params = Map();
    params["IDAttach"] = id;

    final response =
        await apiCaller.delete(AppUrl.getContractDeleteAttach, params);

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
}

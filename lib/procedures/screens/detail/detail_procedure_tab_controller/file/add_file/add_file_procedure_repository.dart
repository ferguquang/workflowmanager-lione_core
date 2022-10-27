import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/procedures/models/params/rate_action_request.dart';
import 'package:workflow_manager/procedures/models/params/save_info_fs_request.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/models/response/save_info_fs_response.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/file/add_file/add_file_procedure_model.dart';

class AddFileProcedureRepository with ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  List<AddFileProcedureModel> listFiles = [];

  Future<void> uploadFile(BuildContext context) async {
    var file = await FileUtils.instance.uploadFileFromSdcard(context);
    if (file != null) {
      AddFileProcedureModel model = AddFileProcedureModel(
        fileName: file.fileName,
        filePath: file.filePath,
        isCheck: false
      );

      listFiles.add(model);
      notifyListeners();
    }
  }

  void updateTrinhKy(AddFileProcedureModel model) {
    model.isCheck = !model.isCheck;
    listFiles[listFiles.indexWhere((element) => element.fileName == model.fileName)] = model;
    notifyListeners();
  }

  Future<List<AllAttachedFiles>> saveInfoFs(List<AddFileProcedureModel> list, int idHoSo) async {
    SaveInfoFsRequest saveInfoFsRequest = SaveInfoFsRequest();
    saveInfoFsRequest.idHoSo = idHoSo;
    saveInfoFsRequest.isSignFiles = list;
    var response = await apiCaller.postFormData(AppUrl.recordSaveInfoFs, saveInfoFsRequest.getParams());
    SaveInfoFsResponse saveInfoFsResponse = SaveInfoFsResponse.fromJson(response);
    if (saveInfoFsResponse.status == 1) {
      List<AllAttachedFiles> allAttachedFiles = saveInfoFsResponse.data.allAttachedFiles;
      return allAttachedFiles;
    } else {
       return null;
    }
  }
}
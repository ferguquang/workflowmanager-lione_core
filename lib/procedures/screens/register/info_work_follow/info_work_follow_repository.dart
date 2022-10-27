import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/procedures/models/response/file_template.dart';
import 'package:workflow_manager/procedures/models/response/step_template_file.dart';
import 'package:workflow_manager/procedures/models/params/info_work_follow_request.dart';
import 'package:workflow_manager/procedures/models/params/list_work_follow_request.dart';
import 'package:workflow_manager/procedures/models/response/register_create_response.dart';
import 'package:workflow_manager/procedures/models/response/RegisterServiceResponse.dart';
import 'package:workflow_manager/workflow/models/response/upload_response.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/file_response.dart';

class InfoWorkFollowRepository extends ChangeNotifier {
  InfoWorkFollowCreateRequest createDataRequest = InfoWorkFollowCreateRequest();
  RegisterCreateModel registerCreateModel;
  bool isHighPriority = false;
  bool isCheckGroupInfos = false;

  void loadData(int idService, bool isUpdate) async {
    createDataRequest.idService = idService;
    InfoWorkFollowUpdateRequest updateRequest = InfoWorkFollowUpdateRequest();
    updateRequest.iDServiceRecord = idService;
    String api =
        isUpdate ? AppUrl.getQTTTRegisterUpdate : AppUrl.getQTTTRegisterCreate;
    final response = await ApiCaller.instance.postFormData(api,
        isUpdate ? updateRequest.getParams() : createDataRequest.getParams());
    RegisterCreateResponse registerCreateResponse =
        RegisterCreateResponse.fromJson(response);
    if (registerCreateResponse.status == 1) {
      registerCreateModel = registerCreateResponse.data;
      isCheckGroupInfos = registerCreateModel.groupInfos.length > 0;
      if (isUpdate) {
        for (FileTemplate file in registerCreateModel.attachedFiles) {
          file.isKeep = true;
        }
        if (registerCreateModel.fileTemplates != null) {
          for (StepTemplateFile file in registerCreateModel.fileTemplates) {
            if (file.uploadedFile.iD != 0) {
              file.isKeep = true;
            }
          }
        }
      }
      isHighPriority=registerCreateModel.priority==1;
      notifyListeners();
    } else {
      showErrorToast(registerCreateResponse.messages);
    }
  }

  void addAttachFile(UploadModel uploadModel) {
    registerCreateModel.attachedFiles.add(FileTemplate(
        fileName: uploadModel.fileName,
        path: uploadModel.filePath,
        isSignFile: false));
    notifyListeners();
  }

  setHightPriority(bool isPriority) {
    isHighPriority = isPriority;
    notifyListeners();
  }

  void removeAttachFile(int position) {
    registerCreateModel.attachedFiles.removeAt(position);
    notifyListeners();
  }
}

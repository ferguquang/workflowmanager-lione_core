import 'package:workflow_manager/base/utils/common_function.dart';

class ImportFileRequest {
  int iDPhase;
  int projectPlanID;
  String fileNames;
  String filePaths;

  // chỉnh sửa
  String fileName;
  int iD;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(iDPhase)) params["IDPhase"] = iDPhase;
    if (isNotNullOrEmpty(projectPlanID))
      params["ProjectPlanID"] = projectPlanID;
    if (isNotNullOrEmpty(fileNames)) params["FileNames"] = fileNames;
    if (isNotNullOrEmpty(filePaths)) params["FilePaths"] = filePaths;

    if (isNotNullOrEmpty(iD)) params["ID"] = iD;
    if (isNotNullOrEmpty(fileName)) params["FileName"] = fileName;

    return params;
  }
}

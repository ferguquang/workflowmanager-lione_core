import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/file/add_file/add_file_procedure_model.dart';

class SaveInfoFsRequest {
  dynamic idHoSo;
  List<AddFileProcedureModel> isSignFiles = [];

  Map<String, dynamic> getParams() {
    String fileNames = isSignFiles
        .map((e) => "'${e.fileName}'")
        .toList()
        .toString();
    String filePaths = isSignFiles
        .map((e) => "'${e.filePath}'")
        .toList()
        .toString();

    Map<String, dynamic> params = Map();
    params["ID"] = idHoSo;
    params["FileNames"] = fileNames;
    params["FilePaths"] = filePaths;
    isSignFiles.forEach((element) {
      if (element.isCheck) {
        params["IsSignFile_${element.filePath}"] = "1";
      }
    });
    return params;
  }
}

class RemoveInfoFsRequest {
  dynamic id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    params["ID"] = id;
    return params;
  }
}

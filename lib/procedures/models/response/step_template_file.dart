import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/uploaded_file.dart';

class StepTemplateFile {
  int iD;
  String name;
  String code;
  String path;
  String extension;
  bool isRequired;
  int iDServiceRecordWfStep;
  UploadedFile uploadedFile;
  bool isKeep;

  // bool _isAdd = false;

  bool get isAdd {
    if (uploadedFile == null) {
      return true;
    } else if (uploadedFile.uploadedFileName.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  StepTemplateFile.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    code = json['Code'];
    path = json['Path'];
    extension = json['Extension'];
    isRequired = json['IsRequired'];
    iDServiceRecordWfStep = json['IDServiceRecordWfStep'];
    if (isNotNullOrEmpty(json["UploadedFile"])) {
      uploadedFile = UploadedFile.fromJson(json["UploadedFile"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['ID'] = iD;
    json['Name'] = name;
    json['Code'] = code;
    json['Path'] = path;
    json['Extension'] = extension;
    isRequired = json['IsRequired'];
    json['IDServiceRecordWfStep'] = iDServiceRecordWfStep;
    if (json["UploadedFile"] != null) {
      uploadedFile = UploadedFile.fromJson(json["UploadedFile"]);
    }
    return json;
  }
}

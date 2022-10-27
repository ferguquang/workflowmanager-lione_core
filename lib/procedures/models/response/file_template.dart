import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/models/response/uploaded_file.dart';
import 'package:workflow_manager/procedures/models/response/user.dart';

import 'condition.dart';

class FileTemplate {
  int iD;
  String name;
  int iDType;
  String code;
  String fileName;
  String path;
  String signPath;
  String extension;
  bool isRequired;
  bool isRemovable;
  bool isSignable;
  int uploadAt;
  String stepUploadName;
  UploadedFile uploadedFile;
  User uploader;
  bool isSignFile;
  bool isSigned;
  bool isEnableSigned;
  List<Conditions> actions;
  bool isKeep = false;
  String getFileName(){
    return fileName??name;
  }
  FileTemplate(
      {this.iD,
      this.name,
      this.iDType,
      this.code,
      this.fileName,
      this.path,
      this.extension,
      this.isRequired,
      this.isRemovable,
      this.uploadedFile,
      this.uploadAt,
      this.stepUploadName,
      this.uploader,
      this.signPath,
      this.isSigned,
      this.isEnableSigned,
      this.isSignFile});

  FileTemplate.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    iDType = json['IDType'];
    code = json['Code'];
    fileName = json['FileName'];
    path = json['Path'];
    extension = json['Extension'];
    isRequired = json['IsRequired'];
    signPath = json['SignPath'];
    uploadAt = json['UploadAt'];
    isRemovable = json['IsRemovable'];
    stepUploadName = json['StepUploadName'];
    isSignable = json['IsSignable'];
    isSignFile = json['IsSignFile'];
    isSigned = json['IsSigned'];
    isEnableSigned = json['IsEnableSigned'];
    if (json['Uploader'] != null) uploader = User.fromJson(json['Uploader']);
    if (json['Actions'] != null) {
      actions = [];
      json['Actions'].forEach((v) {
        actions.add(new Conditions.fromJson(v));
      });
    }
    uploadedFile = json['UploadedFile'] != null
        ? new UploadedFile.fromJson(json['UploadedFile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = new Map<String, dynamic>();
    json['ID'] = this.iD;
    json['Name'] = this.name;
    json['IDType'] = this.iDType;
    json['Code'] = this.code;
    json['FileName'] = this.fileName;
    json['Path'] = this.path;
    json['Extension'] = this.extension;
    json['IsRequired'] = this.isRequired;
    json['SignPath'] = signPath;
    json['UploadAt'] = uploadAt;
    json['StepUploadName'] = stepUploadName;
    json['IsRemovable'] = isRemovable;
    json['IsSignable'] = isSignable;
    json['IsSignFile'] = isSignFile;
    json['IsSigned'] = isSigned;
    json['IsEnableSigned'] = isEnableSigned;

    if (this.uploader != null) {
      json['Uploader'] = this.uploader.toJson();
    }
    if (this.uploadedFile != null) {
      json['UploadedFile'] = this.uploadedFile.toJson();
    }
    return json;
  }
}

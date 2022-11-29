import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';

import 'data_signature_list_response.dart';

class DataRegisterSaveResponse extends BaseResponse {
  int status;
  Data data;

  DataRegisterSaveResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
  }
}

class ServiceFormStepSignConfig {
  int iD;
  int iDChannel;
  int iDService;
  int signStep;
  int signPage;
  int totalPage;
  int page;
  double x;
  double y;
  double width;
  double height;
  int iDServiceForm;
  var pageWidth;
  var pageHeight;
  bool keepConnectionAlive;
  var connection;
  var lastSQL;
  var lastArgs;
  String lastCommand;
  bool enableAutoSelect;
  bool enableNamedParams;
  int commandTimeout;
  int oneTimeCommandTimeout;
  // todo isSigned

  ServiceFormStepSignConfig(
      {this.iD,
      this.iDChannel,
      this.iDService,
      this.signStep,
      this.signPage,
      this.totalPage,
      this.page,
      this.x,
      this.y,
      this.width,
      this.height,
      this.iDServiceForm,
      this.pageWidth,
      this.pageHeight,
      this.keepConnectionAlive,
      this.connection,
      this.lastSQL,
      this.lastArgs,
      this.lastCommand,
      this.enableAutoSelect,
      this.enableNamedParams,
      this.commandTimeout,
      this.oneTimeCommandTimeout});

  ServiceFormStepSignConfig.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDService = json['IDService'];
    signStep = json['SignStep'];
    signPage = json['SignPage'];
    totalPage = json['TotalPage'];
    page = json['Page'];
    x = json['X'];
    y = json['Y'];
    width = json['Width'];
    height = json['Height'];
    iDServiceForm = json['IDServiceForm'];
    pageWidth = json['PageWidth'];
    pageHeight = json['PageHeight'];
    keepConnectionAlive = json['KeepConnectionAlive'];
    connection = json['Connection'];
    lastSQL = json['LastSQL'];
    lastArgs = json['LastArgs'];
    lastCommand = json['LastCommand'];
    enableAutoSelect = json['EnableAutoSelect'];
    enableNamedParams = json['EnableNamedParams'];
    commandTimeout = json['CommandTimeout'];
    oneTimeCommandTimeout = json['OneTimeCommandTimeout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['IDService'] = this.iDService;
    data['SignStep'] = this.signStep;
    data['SignPage'] = this.signPage;
    data['TotalPage'] = this.totalPage;
    data['Page'] = this.page;
    data['X'] = this.x;
    data['Y'] = this.y;
    data['Width'] = this.width;
    data['Height'] = this.height;
    data['IDServiceForm'] = this.iDServiceForm;
    data['PageWidth'] = this.pageWidth;
    data['PageHeight'] = this.pageHeight;
    data['KeepConnectionAlive'] = this.keepConnectionAlive;
    data['Connection'] = this.connection;
    data['LastSQL'] = this.lastSQL;
    data['LastArgs'] = this.lastArgs;
    data['LastCommand'] = this.lastCommand;
    data['EnableAutoSelect'] = this.enableAutoSelect;
    data['EnableNamedParams'] = this.enableNamedParams;
    data['CommandTimeout'] = this.commandTimeout;
    data['OneTimeCommandTimeout'] = this.oneTimeCommandTimeout;
    return data;
  }
}

class Data {
  int id; // idServiceRecord
  ServiceRecords serviceRecord;
  bool isSigned;
  ServiceInfoFile serviceInfoFile;

  List<Signatures> userSignatures;
  ServiceFormStepSignConfig serviceFormStepSignConfig;
  int iDServiceRecordTemplateExport;
  var iDGroup;
  String isDoneInfoDATA;
  String action;

  Data({
    this.id,
    this.serviceRecord,
    this.isSigned = false,
    this.serviceInfoFile,
    this.userSignatures,
    this.serviceFormStepSignConfig,
    this.iDServiceRecordTemplateExport,
    this.iDGroup,
    this.isDoneInfoDATA,
  });

  Data.fromJson(Map<String, dynamic> json) {
    serviceRecord = json['ServiceRecord'] != null
        ? new ServiceRecords.fromJson(json['ServiceRecord'])
        : null;
    isSigned = json['IsSigned'] ?? false;
    id = json['ID'];
    serviceInfoFile = json['ServiceInfoFile'] != null
        ? new ServiceInfoFile.fromJson(json['ServiceInfoFile'])
        : null;
    if (json['UserSignatures'] != null) {
      userSignatures = [];
      json['UserSignatures'].forEach((v) {
        userSignatures.add(new Signatures.fromJson(v));
      });
    }
    serviceFormStepSignConfig = json['ServiceFormStepSignConfig'] != null
        ? new ServiceFormStepSignConfig.fromJson(
            json['ServiceFormStepSignConfig'])
        : null;
    iDServiceRecordTemplateExport = json['IDServiceRecordTemplateExport'];
    iDGroup = json['IDGroup'];
    isDoneInfoDATA = json['IsDoneInfoDATA'];
    action = json['Action'];
  }
}

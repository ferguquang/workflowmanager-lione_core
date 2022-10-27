import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/field_table_list.dart';
import 'package:workflow_manager/procedures/models/response/file_data.dart';
import 'package:workflow_manager/procedures/models/response/file_template.dart';
import 'package:workflow_manager/procedures/models/response/files.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/models/response/solved_info.dart';
import 'package:workflow_manager/procedures/models/response/user_info_response.dart';

import 'field_child_datum.dart';
import 'group_infos.dart';
import 'step_template_file.dart';

class ResponseProcedureDetail extends BaseResponse {
  DataProcedureDetail data;

  ResponseProcedureDetail.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataProcedureDetail.fromJson(json['Data'])
        : null;
  }
}

class DataProcedureDetail {
  String title;
  int iDService;
  String name;
  int iDServiceRecord;
  bool isPermitted;
  bool removable;
  int iDServiceRecordWfStep;
  bool isDone;
  bool isRejected;
  int iDServiceRecordData;
  bool accessUpload;
  bool isEnableAttachSignFile;
  RegisterStep registerStep;
  CurrentStep currentStep;
  List<SolvedInfo> solvedInfos;
  List<AllAttachedFiles> allAttachedFiles;
  List<CommentProcedure> cmts;
  List<Histories> histories;
  List<ServiceRecords> serviceRecordRegisters;
  Actions actions;
  AddAction addAction;
  RateAction rateAction;
  RequiredAction requiredAction;
  List<FileTemplate> signFiles;
  List<RecordVersions> recordVersions;
  StarDetail star;
  String urlFlowChart;

  DataProcedureDetail(
      {this.title,
      this.iDService,
      this.name,
      this.iDServiceRecord,
      this.isPermitted,
      this.removable,
      this.iDServiceRecordWfStep,
      this.isDone,
      this.isRejected,
      this.iDServiceRecordData,
      this.accessUpload,
      this.registerStep,
      this.currentStep,
      this.solvedInfos,
      this.allAttachedFiles,
      this.cmts,
      this.histories,
      this.serviceRecordRegisters,
      this.actions,
      this.addAction,
      this.rateAction,
      this.signFiles,
      this.recordVersions,
      this.star,
      this.urlFlowChart});

  DataProcedureDetail.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    iDService = json['IDService'];
    name = json['Name'];
    iDServiceRecord = json['IDServiceRecord'];
    isPermitted = json['IsPermitted'];
    removable = json['Removable'];
    iDServiceRecordWfStep = json['IDServiceRecordWfStep'];
    isDone = json['IsDone'];
    isRejected = json['IsRejected'];
    iDServiceRecordData = json['IDServiceRecordData'];
    urlFlowChart = json['UrlFlowChart'];
    accessUpload = json['AccessUpload'];
    isEnableAttachSignFile = json['IsEnableAttachSignFile'];
    registerStep = isNotNullOrEmpty(json['RegisterStep'])
        ? new RegisterStep.fromJson(json['RegisterStep'])
        : null;
    currentStep = isNotNullOrEmpty(json['CurrentStep'])
        ? new CurrentStep.fromJson(json['CurrentStep'])
        : null;
    if (json['SolvedInfos'] != null) {
      solvedInfos = new List<SolvedInfo>();
      json['SolvedInfos'].forEach((v) {
        solvedInfos.add(new SolvedInfo.fromJson(v));
      });
    }
    if (json['AllAttachedFiles'] != null) {
      allAttachedFiles = new List<AllAttachedFiles>();
      json['AllAttachedFiles'].forEach((v) {
        allAttachedFiles.add(new AllAttachedFiles.fromJson(v));
      });
    }
    if (json['Cmts'] != null) {
      cmts = new List<CommentProcedure>();
      json['Cmts'].forEach((v) {
        cmts.add(new CommentProcedure.fromJson(v));
      });
    }
    if (json['Histories'] != null) {
      histories = new List<Histories>();
      json['Histories'].forEach((v) {
        histories.add(new Histories.fromJson(v));
      });
    }
    if (json['ServiceRecordRegisters'] != null) {
      serviceRecordRegisters = new List<Null>();
      json['ServiceRecordRegisters'].forEach((v) {
        serviceRecordRegisters.add(new ServiceRecords.fromJson(v));
      });
    }
    actions =
        json['Actions'] != null ? new Actions.fromJson(json['Actions']) : null;
    addAction = json['AddAction'] != null
        ? new AddAction.fromJson(json['AddAction'])
        : null;
    rateAction = json['RateAction'] != null
        ? new RateAction.fromJson(json['RateAction'])
        : null;
    requiredAction = json['RequiredAction'] != null
        ? new RequiredAction.fromJson(json['RequiredAction'])
        : null;
    if (json['SignFiles'] != null) {
      signFiles = new List<FileTemplate>();
      json['SignFiles'].forEach((v) {
        signFiles.add(new FileTemplate.fromJson(v));
      });
    }
    if (json['RecordVersions'] != null) {
      recordVersions = new List<RecordVersions>();
      json['RecordVersions'].forEach((v) {
        recordVersions.add(new RecordVersions.fromJson(v));
      });
    }
    star = json['Star'] != null ? new StarDetail.fromJson(json['Star']) : null;
  }
}

class RequiredAction {
  String action;
  int iDServiceRecordWfStepRequired;
  int iDServiceRecordWfStepAddition;
  String color;
  String name;

  RequiredAction(
      {this.action,
      this.iDServiceRecordWfStepRequired,
      this.iDServiceRecordWfStepAddition,
      this.color,
      this.name});

  RequiredAction.fromJson(Map<String, dynamic> json) {
    action = json['Action'];
    iDServiceRecordWfStepRequired = json['IDServiceRecordWfStepRequired'];
    iDServiceRecordWfStepAddition = json['IDServiceRecordWfStepAddition'];
    color = json['Color'];
    name = json['Name'];
  }
}

class RegisterStep {
  String title;
  int priority;
  List<RegisterAttachedFiles> registerAttachedFiles;
  Uploader register;
  int registerDate;
  List<Field> fields;
  List<Field> singleFields;
  List<Field> tableFields;
  List<GroupInfos> groupInfos;
  List<String> solveMessages;
  FieldTableList fieldTableList;

  RegisterStep(
      {this.title,
      this.priority,
      this.registerAttachedFiles,
      this.register,
      this.registerDate,
      this.fields,
      /* this.singleFields, this.tableFields,*/ this.groupInfos,
      this.solveMessages});

  RegisterStep.fromJson(Map<String, dynamic> json) {
    title = json['Title'];
    priority = json['Priority'];
    if (json['RegisterAttachedFiles'] != null) {
      registerAttachedFiles = new List<RegisterAttachedFiles>();
      json['RegisterAttachedFiles'].forEach((v) {
        registerAttachedFiles.add(new RegisterAttachedFiles.fromJson(v));
      });
    }
    register = json['Register'] != null
        ? new Uploader.fromJson(json['Register'])
        : null;
    registerDate = json['RegisterDate'];
    if (json['Fields'] != null) {
      fields = new List<Field>();
      json['Fields'].forEach((v) {
        fields.add(new Field.fromJson(v));
      });
    }
    if (json['SingleFields'] != null) {
      singleFields = new List<Field>();
      json['SingleFields'].forEach((v) {
        singleFields.add(new Field.fromJson(v));
      });
    }
    if (json['TableFields'] != null) {
      tableFields = [];
      json['TableFields'].forEach((v) {
        tableFields.add(new Field.fromJson(v));
      });
    }
    fieldTableList =
        FieldTableList.fromJson(json["FieldTableList"], tableFields);
    if (json['GroupInfos'] != null) {
      groupInfos = new List<GroupInfos>();
      json['GroupInfos'].forEach((v) {
        groupInfos.add(new GroupInfos.fromJson(v));
      });
    }
    if (json['SolveMessages'] != null) {
      solveMessages = new List<String>();
      json['SolveMessages'].forEach((v) {
        solveMessages.add(v);
      });
    }
  }

  bool isRegisterFieldsDataEmpty() {
    return isNullOrEmpty(singleFields);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Title'] = this.title;
    data['Priority'] = this.priority;
    if (this.registerAttachedFiles != null) {
      data['RegisterAttachedFiles'] =
          this.registerAttachedFiles.map((v) => v.toJson()).toList();
    }
    if (this.register != null) {
      data['Register'] = this.register.toJson();
    }
    data['RegisterDate'] = this.registerDate;
    if (this.fields != null) {
      data['Fields'] = this.fields.map((v) => v.toJson()).toList();
    }
    if (this.singleFields != null) {
      data['SingleFields'] = this.singleFields.map((v) => v.toJson()).toList();
    }
    if (this.tableFields != null) {
      data['TableFields'] = this.tableFields.map((v) => v.toJson()).toList();
    }
    if (this.groupInfos != null) {
      data['GroupInfos'] = this.groupInfos.map((v) => v.toJson()).toList();
    }
    if (this.solveMessages != null) {
      data['SolveMessages'] = this.solveMessages;
    }
    return data;
  }
}

class RegisterAttachedFiles {
  int iD;
  String path;
  String extension;
  String name;
  int uploadAt;
  String stepUploadName;
  bool isEnableSigned;
  Uploader uploader;

  RegisterAttachedFiles(
      {this.iD,
      this.path,
      this.extension,
      this.name,
      this.uploadAt,
      this.stepUploadName,
      this.isEnableSigned,
      this.uploader});

  RegisterAttachedFiles.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    path = json['Path'];
    extension = json['Extension'];
    name = json['Name'];
    uploadAt = json['UploadAt'];
    stepUploadName = json['StepUploadName'];
    isEnableSigned = json['IsEnableSigned'];
    uploader = json['Uploader'] != null
        ? new Uploader.fromJson(json['Uploader'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Path'] = this.path;
    data['Extension'] = this.extension;
    data['Name'] = this.name;
    data['UploadAt'] = this.uploadAt;
    data['StepUploadName'] = this.stepUploadName;
    data['IsEnableSigned'] = this.isEnableSigned;
    if (this.uploader != null) {
      data['Uploader'] = this.uploader.toJson();
    }
    return data;
  }
}

class Uploader {
  int iD;
  String name;
  String avatar;
  String email;
  String phone;
  String address;
  int iDDept;

  Uploader(
      {this.iD,
      this.name,
      this.avatar,
      this.email,
      this.phone,
      this.address,
      this.iDDept});

  Uploader.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    avatar = json['Avatar'];
    email = json['Email'];
    phone = json['Phone'];
    address = json['Address'];
    iDDept = json['IDDept'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['Avatar'] = this.avatar;
    data['Email'] = this.email;
    data['Phone'] = this.phone;
    data['Address'] = this.address;
    data['IDDept'] = this.iDDept;
    return data;
  }
}

class Actions {
  List<Conditions> conditions;

  Actions({this.conditions});

  Actions.fromJson(Map<String, dynamic> json) {
    if (json['Conditions'] != null) {
      conditions = new List<Conditions>();
      json['Conditions'].forEach((v) {
        conditions.add(new Conditions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.conditions != null) {
      data['Conditions'] = this.conditions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AddAction {
  String action;
  int iDServiceRecordWfStep;
  int idServiceRecordWfStepRequired;
  int iDStep;
  int iDWorkflow;
  String color;
  String name;
  String describe;

  AddAction(
      {this.action,
      this.iDServiceRecordWfStep,
      this.iDStep,
      this.iDWorkflow,
      this.color,
      this.name});

  AddAction.fromJson(Map<String, dynamic> json) {
    action = json['Action'];
    iDServiceRecordWfStep = json['IDServiceRecordWfStep'];
    idServiceRecordWfStepRequired = json['IDServiceRecordWfStepRequired'];
    iDStep = json['IDStep'];
    iDWorkflow = json['IDWorkflow'];
    color = json['Color'];
    name = json['Name'];
  }
}

class Conditions {
  String action;
  String type;
  int iDServiceRecordWfStep;
  int iDSchemaCondition;
  String nextSchemaConditionId;
  String color;
  String name;
  String describe;

  String idStepNext;
  String titleHoSo;

  Conditions(
      {this.action,
      this.type,
      this.iDServiceRecordWfStep,
      this.iDSchemaCondition,
      this.nextSchemaConditionId,
      this.color,
      this.name,
      this.describe});

  Conditions.fromJson(Map<String, dynamic> json) {
    action = json['Action'];
    type = json['Type'];
    iDServiceRecordWfStep = json['IDServiceRecordWfStep'];
    iDSchemaCondition = json['IDSchemaCondition'];
    nextSchemaConditionId = json['NextSchemaConditionId'];
    color = json['Color'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Action'] = this.action;
    data['Type'] = this.type;
    data['IDServiceRecordWfStep'] = this.iDServiceRecordWfStep;
    data['IDSchemaCondition'] = this.iDSchemaCondition;
    data['NextSchemaConditionId'] = this.nextSchemaConditionId;
    data['Color'] = this.color;
    data['Name'] = this.name;
    return data;
  }
}

class DateLine {
  bool isLate;
  String dateLineString;

  DateLine({this.isLate, this.dateLineString});

  DateLine.fromJson(Map<String, dynamic> json) {
    isLate = json['IsLate'];
    dateLineString = json['DateLineString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsLate'] = this.isLate;
    data['DateLineString'] = this.dateLineString;
    return data;
  }
}

class CurrentStep {
  String name;
  int endDate;
  UserInfo executors;
  List<StepTemplateFile> stepTemplateFiles;
  List<Field> singleFields;
  List<Field> tableFields;
  List<GroupInfos> groupInfos;
  List<Field> fields;
  DateLine dateLine;
  FieldTableList fieldTableList;
  bool isCheckReLoadModel = false;

  bool isDataEmpty() {
    return name == null &&
        endDate == null &&
        executors == null &&
        isNullOrEmpty(stepTemplateFiles) &&
        isNullOrEmpty(singleFields) &&
        isNullOrEmpty(dateLine);
  }

  CurrentStep(
      {this.name,
      this.endDate,
      this.isCheckReLoadModel = false,
      /*this.executors, this.stepTemplateFiles, this.singleFields, this.tableFields, this.groupInfos, this.fields,*/ this.dateLine});

  CurrentStep.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    endDate = json['EndDate'];
    executors = json['Executors'] != null
        ? new UserInfo.fromJson(json['Executors'])
        : null;
    if (json['StepTemplateFiles'] != null) {
      stepTemplateFiles = new List<StepTemplateFile>();
      json['StepTemplateFiles'].forEach((v) {
        stepTemplateFiles.add(new StepTemplateFile.fromJson(v));
      });
    }
    if (json['SingleFields'] != null) {
      singleFields = new List<Field>();
      json['SingleFields'].forEach((v) {
        singleFields.add(new Field.fromJson(v));
      });
    }
    if (json['TableFields'] != null) {
      tableFields = new List<Field>();
      json['TableFields'].forEach((v) {
        tableFields.add(new Field.fromJson(v));
      });
    }
    fieldTableList =
        FieldTableList.fromJson(json["FieldTableList"], tableFields);
    if (json['GroupInfos'] != null) {
      groupInfos = new List<GroupInfos>();
      json['GroupInfos'].forEach((v) {
        groupInfos.add(new GroupInfos.fromJson(v));
      });
    }
    if (json['Fields'] != null) {
      fields = new List<Field>();
      json['Fields'].forEach((v) {
        fields.add(new Field.fromJson(v));
      });
    }
    dateLine = json['DateLine'] != null
        ? new DateLine.fromJson(json['DateLine'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['EndDate'] = this.endDate;
    if (this.executors != null) {
      data['Executors'] = this.executors.toJson();
    }
    if (this.stepTemplateFiles != null) {
      data['StepTemplateFiles'] =
          this.stepTemplateFiles.map((v) => v.toJson()).toList();
    }
    if (this.singleFields != null) {
      data['SingleFields'] = this.singleFields.map((v) => v.toJson()).toList();
    }
    if (this.tableFields != null) {
      data['TableFields'] = this.tableFields.map((v) => v.toJson()).toList();
    }
    if (this.groupInfos != null) {
      data['GroupInfos'] = this.groupInfos.map((v) => v.toJson()).toList();
    }
    if (this.fields != null) {
      data['Fields'] = this.fields.map((v) => v.toJson()).toList();
    }
    if (this.dateLine != null) {
      data['DateLine'] = this.dateLine.toJson();
    }
    return data;
  }
}

class CommentProcedure {
  int id;
  String body;
  int created;

  CommentProcedure(this.id, this.body, this.created);

  CommentProcedure.fromJson(Map<String, dynamic> json) {
    id = json['ID'];
    body = json['Body'];
    created = json['Created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.id;
    data['Body'] = this.body;
    data['Created'] = this.created;
    return data;
  }
}

class AllAttachedFiles {
  int iD;
  String path;
  String extension;
  String name;
  int uploadAt;
  String stepUploadName;
  bool isEnableSigned;
  Uploader uploader;
  bool isRemovable;

  AllAttachedFiles(
      {this.iD,
      this.path,
      this.extension,
      this.name,
      this.uploadAt,
      this.stepUploadName,
      this.isEnableSigned,
      this.uploader,
      this.isRemovable});

  AllAttachedFiles.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    path = json['Path'];
    extension = json['Extension'];
    name = json['Name'];
    uploadAt = json['UploadAt'];
    stepUploadName = json['StepUploadName'];
    isEnableSigned = json['IsEnableSigned'];
    uploader = json['Uploader'] != null
        ? new Uploader.fromJson(json['Uploader'])
        : null;
    isRemovable = json['IsRemovable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Path'] = this.path;
    data['Extension'] = this.extension;
    data['Name'] = this.name;
    data['UploadAt'] = this.uploadAt;
    data['StepUploadName'] = this.stepUploadName;
    data['IsEnableSigned'] = this.isEnableSigned;
    if (this.uploader != null) {
      data['Uploader'] = this.uploader.toJson();
    }
    data['IsRemovable'] = this.isRemovable;
    return data;
  }
}

class Histories {
  int iD;
  int iDServiceRecordWfStep;
  String name;
  String executorName;
  String statusProcess;
  String processTime;
  String progressTime;
  String describe;
  Uploader createdBy;
  int created;

  Histories(
      {this.iD,
      this.iDServiceRecordWfStep,
      this.name,
      this.executorName,
      this.statusProcess,
      this.processTime,
      this.progressTime,
      this.describe,
      this.createdBy,
      this.created});

  Histories.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDServiceRecordWfStep = json['IDServiceRecordWfStep'];
    name = json['Name'];
    executorName = json['ExecutorName'];
    statusProcess = json['StatusProcess'];
    processTime = json['ProcessTime'];
    progressTime = json['ProgressTime'];
    describe = json['Describe'];
    createdBy = json['CreatedBy'] != null
        ? new Uploader.fromJson(json['CreatedBy'])
        : null;
    created = json['Created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDServiceRecordWfStep'] = this.iDServiceRecordWfStep;
    data['Name'] = this.name;
    data['ExecutorName'] = this.executorName;
    data['StatusProcess'] = this.statusProcess;
    data['ProcessTime'] = this.processTime;
    data['ProgressTime'] = this.progressTime;
    data['Describe'] = this.describe;
    if (this.createdBy != null) {
      data['CreatedBy'] = this.createdBy.toJson();
    }
    data['Created'] = this.created;
    return data;
  }
}

class RateAction {
  String action;
  String color;
  int redirectType;
  String name;

  RateAction({this.action, this.color, this.redirectType, this.name});

  RateAction.fromJson(Map<String, dynamic> json) {
    action = json['Action'];
    color = json['Color'];
    redirectType = json['RedirectType'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Action'] = this.action;
    data['Color'] = this.color;
    data['RedirectType'] = this.redirectType;
    data['Name'] = this.name;
    return data;
  }
}

class RecordVersions {
  String requierName;
  String additionStep;
  String additionerName;
  String content;
  String additionTime;
  List<DataRecordVersion> data;
  List<FileData> fileData;
  List<List<FieldChildDatum>> fieldChildData;
  List<GroupInfos> groupInfos;

  RecordVersions({
    this.requierName,
    this.additionStep,
    this.additionerName,
    this.content,
    this.additionTime,
    this.data,
    /*this.fileData, this.fieldChildData, this.groupInfos*/
  });

  RecordVersions.fromJson(Map<String, dynamic> json) {
    requierName = json['RequierName'];
    additionStep = json['AdditionStep'];
    additionerName = json['AdditionerName'];
    content = json['Content'];
    additionTime = json['AdditionTime'];
    if (json['Data'] != null) {
      data = new List<DataRecordVersion>();
      json['Data'].forEach((v) {
        data.add(new DataRecordVersion.fromJson(v));
      });
    }
    if (json['FileData'] != null) {
      fileData = new List<FileData>();
      json['FileData'].forEach((v) {
        fileData.add(new FileData.fromJson(v));
      });
    }
    if (json['FieldChildData'] != null) {
      fieldChildData = new List<List<FieldChildDatum>>();
      json['FieldChildData'].forEach((v) {
        var list = List<FieldChildDatum>();
        v.forEach((v) {
          list.add(FieldChildDatum.fromJson(v));
        });
        fieldChildData.add(list);
      });
    }

    if (json['GroupInfos'] != null) {
      groupInfos = new List<GroupInfos>();
      json['GroupInfos'].forEach((v) {
        groupInfos.add(new GroupInfos.fromJson(v));
      });
    }
  }
}

class DataRecordVersion {
  String newVal;
  int type;
  String title;
  String key;

  List<Files> oldFiles;
  String newID;

  List<Files> newFiles;
  String oldID;
  String oldVal;

  DataRecordVersion(
      {this.newVal,
      this.type,
      this.title,
      this.key,
      /*this.oldFiles,*/ this.newID,
      /*this.newFiles,*/ this.oldID,
      this.oldVal});

  DataRecordVersion.fromJson(Map<String, dynamic> json) {
    newVal = json['NewVal'];
    type = json['Type'];
    title = json['Title'];
    key = json['Key'];
    if (json['OldFiles'] != null) {
      oldFiles = new List<Files>();
      json['OldFiles'].forEach((v) {
        oldFiles.add(new Files.fromJson(v));
      });
    }
    newID = json['NewID'];
    if (json['NewFiles'] != null) {
      newFiles = new List<Files>();
      json['NewFiles'].forEach((v) {
        newFiles.add(new Files.fromJson(v));
      });
    }
    oldID = json['OldID'];
    oldVal = json['OldVal'];
  }
}

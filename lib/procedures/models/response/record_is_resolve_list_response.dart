import 'package:workflow_manager/base/models/base_response.dart';

class RecordIsResolveListResponse extends BaseResponse {
  DataRecordIsResolveList data;

  RecordIsResolveListResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new DataRecordIsResolveList.fromJson(json['Data']) : null;
  }
}

class DataRecordIsResolveList {
  int isHasToSign;
  List<ServiceRecordsResolve> serviceRecords;
  int state;
  DataRecordIsResolveList({this.isHasToSign, this.serviceRecords,this.state});

  DataRecordIsResolveList.fromJson(Map<String, dynamic> json) {
    isHasToSign = json['IsHasToSign'];
    if (json['ServiceRecords'] != null) {
      serviceRecords = new List<ServiceRecordsResolve>();
      json['ServiceRecords'].forEach((v) {
        serviceRecords.add(new ServiceRecordsResolve.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IsHasToSign'] = this.isHasToSign;
    if (this.serviceRecords != null) {
      data['ServiceRecords'] =
          this.serviceRecords.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceRecordsResolve {
  int iDServiceRecord;
  int rowNumber;
  String name;
  String currentStepName;
  String status;
  List<ActionsResolve> actions;

  ActionsResolve actionSelected;
  String describe;

  int idStep, idSchemaCondition;

  ServiceRecordsResolve(
      {this.iDServiceRecord,
        this.rowNumber,
        this.name,
        this.currentStepName,
        this.status,
        this.actions,
        this.actionSelected,
        this.describe
      });

  ServiceRecordsResolve.fromJson(Map<String, dynamic> json) {
    iDServiceRecord = json['IDServiceRecord'];
    rowNumber = json['RowNumber'];
    name = json['Name'];
    currentStepName = json['CurrentStepName'];
    status = json['Status'];
    if (json['Actions'] != null) {
      actions = new List<ActionsResolve>();
      json['Actions'].forEach((v) {
        actions.add(new ActionsResolve.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDServiceRecord'] = this.iDServiceRecord;
    data['RowNumber'] = this.rowNumber;
    data['Name'] = this.name;
    data['CurrentStepName'] = this.currentStepName;
    data['Status'] = this.status;
    if (this.actions != null) {
      data['Actions'] = this.actions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ActionsResolve {
  int iDServiceRecord;
  int iDSchemaCondition;
  int iDStep;
  String stepName;
  String action;
  String switchStateString;
  String stateString;
  int isAutoCheck;
  int isRewind;

  bool isSelected = false;

  ActionsResolve(
      {this.iDServiceRecord,
        this.iDSchemaCondition,
        this.iDStep,
        this.stepName,
        this.action,
        this.switchStateString,
        this.stateString,
        this.isAutoCheck,
        this.isRewind});

  ActionsResolve.fromJson(Map<String, dynamic> json) {
    iDServiceRecord = json['IDServiceRecord'];
    iDSchemaCondition = json['IDSchemaCondition'];
    iDStep = json['IDStep'];
    stepName = json['StepName'];
    action = json['Action'];
    switchStateString = json['SwitchStateString'];
    stateString = json['StateString'];
    isAutoCheck = json['IsAutoCheck'];
    isRewind = json['IsRewind'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['IDServiceRecord'] = this.iDServiceRecord;
    data['IDSchemaCondition'] = this.iDSchemaCondition;
    data['IDStep'] = this.iDStep;
    data['StepName'] = this.stepName;
    data['Action'] = this.action;
    data['SwitchStateString'] = this.switchStateString;
    data['StateString'] = this.stateString;
    data['IsAutoCheck'] = this.isAutoCheck;
    data['IsRewind'] = this.isRewind;
    return data;
  }
}

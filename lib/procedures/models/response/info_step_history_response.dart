import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/response/field_table_list.dart';
import 'package:workflow_manager/procedures/models/response/group_infos.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';

class InfoStepHistoryResponse extends BaseResponse {
  DataInfoStepHistory data;

  InfoStepHistoryResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataInfoStepHistory.fromJson(json['Data'])
        : null;
  }
}

class DataInfoStepHistory {
  List<HistoryInfo> historyInfo;

  DataInfoStepHistory({this.historyInfo});

  DataInfoStepHistory.fromJson(Map<String, dynamic> json) {
    if (json['HistoryInfo'] != null) {
      historyInfo = new List<HistoryInfo>();
      json['HistoryInfo'].forEach((v) {
        historyInfo.add(new HistoryInfo.fromJson(v));
      });
    }
  }
}

class HistoryInfo {
  String stepName;
  String executorName;
  int deadLine;
  int doneDate;
  String statusProcess;
  String progressTime;
  Progress progress;

  // List<Null> attachedFiles;
  // List<Null> fields;
  List<Field> singleFields;
  List<Field> tableFields;
  List<GroupInfos> groupInfos;
  List<String> solveMessage;
  bool isRegisterStep;

  // RegisterInfo registerInfo;
  FieldTableList fieldTableList;

  HistoryInfo({
    this.stepName,
    this.executorName,
    this.deadLine,
    this.doneDate,
    this.statusProcess,
    this.progressTime,
    this.progress,
    /* this.attachedFiles, this.fields,*/
    this.singleFields,
    this.tableFields,
    this.groupInfos,
    this.solveMessage,
    this.isRegisterStep,
    /*this.registerInfo*/
  });

  HistoryInfo.fromJson(Map<String, dynamic> json) {
    stepName = json['StepName'];
    executorName = json['ExecutorName'];
    deadLine = json['DeadLine'];
    doneDate = json['DoneDate'];
    statusProcess = json['StatusProcess'];
    progressTime = json['ProgressTime'];
    progress = json['Progress'] != null
        ? new Progress.fromJson(json['Progress'])
        : null;
    // if (json['AttachedFiles'] != null) {
    //   attachedFiles = new List<Null>();
    //   json['AttachedFiles'].forEach((v) { attachedFiles.add(new Null.fromJson(v)); });
    // }
    // if (json['Fields'] != null) {
    //   fields = new List<Null>();
    //   json['Fields'].forEach((v) { fields.add(new Null.fromJson(v)); });
    // }
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
    if (tableFields?.length > 0) {
      fieldTableList =
          FieldTableList.fromJson(json["FieldTableList"], tableFields);
      if (json['GroupInfos'] != null) {
        groupInfos = new List<GroupInfos>();
        json['GroupInfos'].forEach((v) {
          groupInfos.add(new GroupInfos.fromJson(v));
        });
      }
    }

    solveMessage = json['SolveMessage'].cast<String>();
    isRegisterStep = json['IsRegisterStep'];
    // registerInfo = json['RegisterInfo'] != null ? new RegisterInfo.fromJson(json['RegisterInfo']) : null;
  }
}

class Progress {
  bool isLate;
  String dateLineString;

  Progress({this.isLate, this.dateLineString});

  Progress.fromJson(Map<String, dynamic> json) {
    isLate = json['IsLate'];
    dateLineString = json['DateLineString'];
  }
}

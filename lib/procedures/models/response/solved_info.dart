import 'package:workflow_manager/procedures/models/response/file_template.dart';
import 'package:workflow_manager/procedures/models/response/progress.dart';

import 'register_info.dart';
import 'single_field.dart';

class SolvedInfo {
  String stepName;
  String executorName;
  int deadLine;
  int doneDate;
  Progress progress;
  List<FileTemplate> attachedFiles = null;
  List<Field> fields = null;
  List<String> solveMessages;
  bool isRegisterStep;
  RegisterInfo registerInfo;
  bool expanded;

  SolvedInfo.fromJson(Map<String, dynamic> json) {
    stepName = json['StepName'];
    executorName = json['ExecutorName'];
    deadLine = json['DeadLine'];
    doneDate = json['DoneDate'];
    progress = Progress.fromJson(json['Progress']);
    isRegisterStep = json['IsRegisterStep'];
    if (json['AttachedFiles'] != null) {
      attachedFiles = new List<FileTemplate>();
      json['attachedFiles'].forEach((v) {
        attachedFiles.add(new FileTemplate.fromJson(v));
      });
    }
    if (json['Fields'] != null) {
      fields = new List<Field>();
      json['Fields'].forEach((v) {
        fields.add(new Field.fromJson(v));
      });
    }
    if (json['SolveMessages'] != null) {
      solveMessages = new List<String>();
      json['SolveMessages'].forEach((v) {
        solveMessages.add(v);
      });
    }
    if (json['RegisterInfo'] != null) {
      registerInfo = RegisterInfo.fromJson(json['RegisterInfo']);
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['StepName'] = stepName;
    json['ExecutorName'] = executorName;
    json['DeadLine'] = deadLine;
    json['DoneDate'] = doneDate;
    json['Progress'] = progress.toJson();
    json['IsRegisterStep'] = isRegisterStep;
    if (this.attachedFiles != null) {
      json['AttachedFiles'] =
          this.attachedFiles.map((v) => v.toJson()).toList();
    }
    if (this.fields != null) {
      json['Fields'] = this.fields.map((v) => v.toJson()).toList();
    }
    if (this.solveMessages != null) {
      json['SolveMessages'] = this.solveMessages;
    }
    if (this.registerInfo != null) {
      json['RegisterInfo'] = registerInfo.toJson();
    }
    return json;
  }
}

import 'dart:core';

import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/response/field_table_list.dart';
import 'package:workflow_manager/procedures/models/response/file_template.dart';
import 'package:workflow_manager/procedures/models/response/group_infos.dart';
import 'package:workflow_manager/procedures/models/response/handler_info.dart';
import 'package:workflow_manager/procedures/models/response/position.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/models/response/star.dart';
import 'package:workflow_manager/procedures/models/response/step_template_file.dart';
import 'package:workflow_manager/procedures/models/response/user.dart';
import 'package:workflow_manager/procedures/models/response/view_types.dart';

class RegisterCreateResponse extends BaseResponse {
  int status;
  RegisterCreateModel data;

  RegisterCreateResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null
        ? new RegisterCreateModel.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class RegisterCreateModel {
  int iD;
  String name;
  String recordName;
  int priority;
  bool isEnableAttachSignFile;
  bool isSignAttachFile;
  bool isSignAttachFileRequired;
  bool isParallelAssign = false;
  String describe;
  String code;
  int iDType;
  String typeName;
  List<ViewTypes> viewTypes;
  int viewType;
  bool isAssignNewExecutor;
  List<StepTemplateFile> fileTemplates;
  List<FileTemplate> attachedFiles;
  List<User> users;
  List<HandlerInfo> depts;
  List<Position> postions;
  List<HandlerInfo> teams;

  // List<Fields> fields;
  List<Field> singleFields;
  List<Field> tableFields;
  List<GroupInfos> groupInfos;
  Star star;
  String urlFlowChart;
  FieldTableList fieldTableList;
  RegisterCreateModel(
      {this.iD,
      this.name,
      this.recordName,
      this.priority,
      this.isEnableAttachSignFile,
      this.describe,
      this.code,
      this.iDType,
      this.typeName,
      this.viewTypes,
      this.viewType,
      this.isAssignNewExecutor,
      this.fileTemplates,
      this.attachedFiles,
      this.users,
      this.depts,
      this.postions,
      this.teams,
      // this.fields,
      this.singleFields,
      this.tableFields,
      this.star,
      this.urlFlowChart});

  RegisterCreateModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    recordName = json['RecordName'];
    priority = json['Priority'];
    isEnableAttachSignFile = json['IsEnableAttachSignFile'];
    isSignAttachFile = json['IsSignAttachFile'];
    isSignAttachFileRequired = json['IsSignAttachFileRequired'];
    describe = json['Describe'];
    code = json['Code'];
    iDType = json['IDType'];
    typeName = json['TypeName'];
    if (json['ViewTypes'] != null) {
      viewTypes = new List<ViewTypes>();
      json['ViewTypes'].forEach((v) {
        viewTypes.add(new ViewTypes.fromJson(v));
      });
    }
    viewType = json['ViewType'];
    isAssignNewExecutor = json['IsAssignNewExecutor'];
    if (json['FileTemplates'] != null) {
      fileTemplates = new List<StepTemplateFile>();
      json['FileTemplates'].forEach((v) {
        fileTemplates.add(new StepTemplateFile.fromJson(v));
      });
    }
    if (json['AttachedFiles'] != null) {
      attachedFiles = new List<FileTemplate>();
      json['AttachedFiles'].forEach((v) {
        attachedFiles.add(new FileTemplate.fromJson(v));
      });
    }
    if (json['GroupInfos'] != null) {
      groupInfos = new List<GroupInfos>();
      json['GroupInfos'].forEach((v) {
        groupInfos.add(new GroupInfos.fromJson(v));
      });
    }
    if (json['Users'] != null) {
      users = new List<User>();
      json['Users'].forEach((v) {
        users.add(new User.fromJson(v));
      });
    }
    if (json['Depts'] != null) {
      depts = new List<HandlerInfo>();
      json['Depts'].forEach((v) {
        depts.add(new HandlerInfo.fromJson(v));
      });
    }
    if (json['Postions'] != null) {
      postions = new List<Position>();
      json['Postions'].forEach((v) {
        postions.add(new Position.fromJson(v));
      });
    }
    if (json['Teams'] != null) {
      teams = new List<HandlerInfo>();
      json['Teams'].forEach((v) {
        teams.add(new HandlerInfo.fromJson(v));
      });
    }
    // if (json['Fields'] != null) {
    //   fields = new List<Fields>();
    //   json['Fields'].forEach((v) {
    //     fields.add(new Fields.fromJson(v));
    //   });
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
    fieldTableList =
        FieldTableList.fromJson(json["FieldTableList"], tableFields);
    if (json['Star'] != null) {
      star = Star.fromJson(json["Star"]);
    }
    urlFlowChart = json['UrlFlowChart'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['RecordName'] = this.recordName;
    data['Priority'] = this.priority;
    data['IsEnableAttachSignFile'] = this.isEnableAttachSignFile;
    data['Describe'] = this.describe;
    data['Code'] = this.code;
    data['IDType'] = this.iDType;
    data['TypeName'] = this.typeName;
    if (this.viewTypes != null) {
      data['ViewTypes'] = this.viewTypes.map((v) => v.toJson()).toList();
    }
    data['ViewType'] = this.viewType;
    data['IsAssignNewExecutor'] = this.isAssignNewExecutor;
    if (this.fileTemplates != null) {
      data['FileTemplates'] =
          this.fileTemplates.map((v) => v.toJson()).toList();
    }
    if (this.groupInfos != null) {
      data['GroupInfos'] = this.groupInfos.map((v) => v.toJson()).toList();
    }
    if (this.attachedFiles != null) {
      data['AttachedFiles'] =
          this.attachedFiles.map((v) => v.toJson()).toList();
    }
    if (this.users != null) {
      data['Users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.depts != null) {
      data['Depts'] = this.depts.map((v) => v.toJson()).toList();
    }
    if (this.postions != null) {
      data['Postions'] = this.postions.map((v) => v.toJson()).toList();
    }
    if (this.teams != null) {
      data['Teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    // if (this.fields != null) {
    //   data['Fields'] = this.fields.map((v) => v.toJson()).toList();
    // }
    if (this.singleFields != null) {
      data['SingleFields'] = this.singleFields.map((v) => v.toJson()).toList();
    }
    if (this.tableFields != null) {
      data['TableFields'] = this.tableFields.map((v) => v.toJson()).toList();
    }
    if (this.star != null) {
      data['Star'] = this.star.toJson();
    }
    data['UrlFlowChart'] = urlFlowChart;
    return data;
  }
}

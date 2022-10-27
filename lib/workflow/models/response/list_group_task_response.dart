import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/message.dart';

class DataGroupTask {
  List<GroupTask> result;
  int totalJobGroup;
  bool canCreateAndDeleteGroupJob = false;

  DataGroupTask(
      {this.result, this.totalJobGroup, this.canCreateAndDeleteGroupJob});

  DataGroupTask.fromJson(Map<String, dynamic> json) {
    if (json['result'] != null) {
      result = new List<GroupTask>();
      json['result'].forEach((v) {
        result.add(new GroupTask.fromJson(v));
      });
    }
    totalJobGroup = json['TotalJobGroup'];
    canCreateAndDeleteGroupJob = json['CanCreateAndDeleteGroupJob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result.map((v) => v.toJson()).toList();
    }
    data['TotalJobGroup'] = this.totalJobGroup;
    data['CanCreateAndDeleteGroupJob'] = canCreateAndDeleteGroupJob;

    return data;
  }
}

class ListGroupTaskResponse extends BaseResponse {
  DataGroupTask data;

  ListGroupTaskResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data =
        json['Data'] != null ? new DataGroupTask.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }

    return data;
  }
}

class GroupTask {
  int iD;
  int iDChannel;
  String name;
  String describe;
  String startDate;
  String endDate;
  int status;
  int priority;
  String created;
  int createdBy;
  String createdName;
  bool isPin;
  bool isArchive;
  int totalMember;
  int totalJobExpires;

  bool isSelected = false;
  bool isShowFunction = false;

  GroupTask({
    this.iD,
    this.iDChannel,
    this.name,
    this.describe,
    this.startDate,
    this.endDate,
    this.status,
    this.priority,
    this.created,
    this.createdBy,
    this.createdName,
    this.isPin,
    this.isArchive,
    this.totalMember,
    this.isSelected,
    this.isShowFunction,
  });

  GroupTask.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    name = json['Name'];
    describe = json['Describe'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    status = json['Status'];
    priority = json['Priority'];
    created = json['Created'];
    createdBy = json['CreatedBy'];
    createdName = json['CreatedName'];
    isPin = json['isPin'];
    isArchive = json['IsArchive'];
    totalMember = json['TotalMember'];
    totalJobExpires = json['TotalJobExpires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['Status'] = this.status;
    data['Priority'] = this.priority;
    data['Created'] = this.created;
    data['CreatedBy'] = this.createdBy;
    data['CreatedName'] = this.createdName;
    data['isPin'] = this.isPin;
    data['IsArchive'] = this.isArchive;
    data['TotalMember'] = this.totalMember;
    data['TotalJobExpires'] = this.totalJobExpires;
    return data;
  }
}

class StatusGroupResponse extends BaseResponse {
  List<StatusGroup> data;

  StatusGroupResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['Data'] != null) {
      data = new List<StatusGroup>();
      json['Data'].forEach((v) {
        data.add(new StatusGroup.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class StatusGroup {
  int key;
  String value;
  bool isSelected;

  StatusGroup({this.key, this.value, this.isSelected});

  StatusGroup.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['Value'] = this.value;
    return data;
  }
}

// change status
class ChangeStatusResponse {
  Message data;

  ChangeStatusResponse({this.data});

  ChangeStatusResponse.fromJson(Map<String, dynamic> json) {
    data = json['Data'] != null ? new Message.fromJson(json['Data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }

    return data;
  }
}

// delete
class DeleteGroupResponse extends BaseResponse {
  int status;
  DataGroupTask data;

  DeleteGroupResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = json['Status'];
    data =
        json['Data'] != null ? new DataGroupTask.fromJson(json['Data']) : null;
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

class Data {
  Data();

  Data.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}

class ChangeStatusListResponse extends BaseResponse {
  List<StatusGroup> data;

  ChangeStatusListResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json['Data'] != null) {
      data = new List<StatusGroup>();
      json['Data'].forEach((v) {
        data.add(new StatusGroup.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

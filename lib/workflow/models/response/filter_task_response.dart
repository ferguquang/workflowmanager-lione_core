import 'package:workflow_manager/base/models/base_response.dart';

import 'list_status_response.dart';

class FilterTaskResponse extends BaseResponse {
  FilterTaskData data;

  FilterTaskResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data =
        json['Data'] != null ? new FilterTaskData.fromJson(json['Data']) : null;
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

class FilterTaskData {

  List<Priorities> priorities;

  List<StatusItem> statuses;

  List<StatusItem> statusesDeadLine;

  List<Types> types;

  FilterTaskData({this.priorities, this.statuses, this.statusesDeadLine});

  FilterTaskData.fromJson(Map<String, dynamic> json) {
    if (json['Priorities'] != null) {
      priorities = new List<Priorities>();
      json['Priorities'].forEach((v) {
        priorities.add(new Priorities.fromJson(v));
      });
    }
    if (json['Statuses'] != null) {
      statuses = new List<StatusItem>();
      json['Statuses'].forEach((v) {
        statuses.add(new StatusItem.fromJson(v));
      });
    }
    if (json['StatusDeadLine'] != null) {
      statusesDeadLine = new List<StatusItem>();
      json['StatusDeadLine'].forEach((v) {
        statusesDeadLine.add(new StatusItem.fromJson(v));
      });
    }
    if (json['Types'] != null) {
      types = new List<Types>();
      json['Types'].forEach((v) {
        types.add(new Types.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.priorities != null) {
      data['Priorities'] = this.priorities.map((v) => v.toJson()).toList();
    }
    if (this.statuses != null) {
      data['Statuses'] = this.statuses.map((v) => v.toJson()).toList();
    }
    if (this.statusesDeadLine != null) {
      data['StatusDeadLine'] = this.statuses.map((v) => v.toJson()).toList();
    }
    if (this.types != null) {
      data['Types'] = this.types.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// Loại công việc
class Types {
  int key;
  String value;
  bool isSelected;

  Types({this.key, this.value, this.isSelected = false});

  Types.fromJson(Map<String, dynamic> json) {
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

// Mức độ ưu tiên
class Priorities {
  int key;
  String value;
  String color;
  bool isSelected;

  Priorities({this.key, this.value, this.color, this.isSelected = false});

  Priorities.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    value = json['Value'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['Value'] = this.value;
    return data;
  }
}


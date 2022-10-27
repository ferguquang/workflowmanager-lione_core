import 'package:workflow_manager/base/models/base_response.dart';

class TodoListResponse extends BaseResponse{
  List<ToDoModel> data;

  TodoListResponse.fromJson(Map<String, dynamic> json):super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = new List<ToDoModel>();
      json['Data'].forEach((v) {
        data.add(new ToDoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class ToDoModel {
  int iD;
  int iDChannel;
  int iDJob;
  int iDExcuter;
  String name;
  bool isComplete;
  String created;

  ToDoModel(
      {this.iD,
      this.iDChannel,
      this.iDJob,
      this.iDExcuter,
      this.name,
      this.isComplete,
      this.created});

  ToDoModel.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDJob = json['IDJob'];
    iDExcuter = json['IDExcuter'];
    name = json['Name'];
    isComplete = json['IsComplete'];
    created = json['Created'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['IDJob'] = this.iDJob;
    data['IDExcuter'] = this.iDExcuter;
    data['Name'] = this.name;
    data['IsComplete'] = this.isComplete;
    data['Created'] = this.created;
    return data;
  }
}

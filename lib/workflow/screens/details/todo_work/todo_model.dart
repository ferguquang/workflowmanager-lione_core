import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/screens/details/todo_work/todo_list_model.dart';

class TodoResponse extends BaseResponse{
  ToDoModel data;

  TodoResponse.fromJson(Map<String, dynamic> json):super.fromJson(json) {
    status = json['Status'];
    if (json['Data'] != null) {
      data = ToDoModel.fromJson(json['Data']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data;
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

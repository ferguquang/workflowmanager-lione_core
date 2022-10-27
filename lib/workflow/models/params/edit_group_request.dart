import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';
import 'package:workflow_manager/base/extension/string.dart';

class EditGroupRequest {
  String name;

  String description;

  String startDate;

  String endDate;

  int idJobGroup;

  UserItem priority;

  UserItem status;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(name.isNotNullOrEmpty) {
      params["Name"] = name;
    }
    if(description.isNotNullOrEmpty) {
      params["Describe"] = description;
    }
    if(startDate.isNotNullOrEmpty) {
      params["StartDate"] = startDate;
    }
    if(endDate.isNotNullOrEmpty) {
      params["EndDate"] = endDate;
    }
    params["IDGroupJob"] = idJobGroup;
    if (this.priority != null) {
      params["Priority"] = this.priority.iD;
    }
    if (this.status != null) {
      params["Status"] = this.status.iD;
    }
    return params;
  }
}

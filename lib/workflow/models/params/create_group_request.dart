import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';
import 'package:workflow_manager/base/extension/string.dart';

class CreateGroupRequest {

  String name;

  String description;

  String startDate;

  String endDate;

  UserItem priority;

  UserItem status;

  // Danh sách thành viên
  String idEmps;

  // Dnah sách vai trò
  String roles;

  // Danh sách tên file
  String fileName;

  // Danh sách đường dẫn file
  String filePath;

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
    if (this.priority != null) {
      params["Priority"] = this.priority.iD;
    }
    if (this.status != null) {
      params["Status"] = this.status.iD;
    }
    if(idEmps.isNotNullOrEmpty) {
      params["ListIDEmp"] = idEmps;
    }
    if(roles.isNotNullOrEmpty) {
      params["ListRole"] = roles;
    }
    if(fileName.isNotNullOrEmpty) {
      params["FileName"] = fileName;
    }
    if(filePath.isNotNullOrEmpty) {
      params["FilePath"] = filePath;
    }
    return params;
  }

}
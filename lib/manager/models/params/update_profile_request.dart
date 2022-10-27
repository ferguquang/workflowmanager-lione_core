import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/utils/common_function.dart';

class UpdateProfileRequest {
  String userName;

  String email;

  String address;

  int gender;

  int birthday;

  String numberPhone;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (userName.isNotNullOrEmpty) {
      params["Name"] = userName;
    }
    if (email.isNotNullOrEmpty) {
      params["Email"] = email;
    }
    if (address.isNotNullOrEmpty) {
      params["Address"] = address;
    }
    if (isNotNullOrEmpty(gender)) {
      params["Gender"] = gender;
    }
    if (isNotNullOrEmpty(birthday)) {
      params["Birthday"] = birthday;
    }
    if (numberPhone.isNotNullOrEmpty) {
      params["Phone"] = numberPhone;
    }
    return params;
  }
}

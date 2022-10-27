import 'package:workflow_manager/procedures/models/response/user.dart';

class RegisterInfo {
  int registerDate;
  int priority;
  User register;

  RegisterInfo.fromJson(Map<String, dynamic> json) {
    registerDate = json['RegisterDate'];
    priority = json['Priority'];
    register = User.fromJson(json['Register']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['RegisterDate'] = registerDate;
    json['Priority'] = priority;
    json['Register'] = register.toJson();
    return json;
  }
}

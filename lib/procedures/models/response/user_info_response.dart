import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/response/handler_info.dart';
import 'package:workflow_manager/procedures/models/response/position.dart';
import 'package:workflow_manager/procedures/models/response/user.dart';

class UserInfoResponse extends BaseResponse{
  int status;
  UserInfoModel data;
  UserInfoResponse.fromJson(Map<String, dynamic> json):super.fromJson(json) {
    status = json['Status'];
    data = json['Data'] != null ? new UserInfoModel.fromJson(json['Data']) : null;
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

class UserInfoModel {
  UserInfo userInfo;

  UserInfoModel({this.userInfo});

  UserInfoModel.fromJson(Map<String, dynamic> json) {
    userInfo = json['UserInfo'] != null
        ? new UserInfo.fromJson(json['UserInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userInfo != null) {
      data['UserInfo'] = this.userInfo.toJson();
    }
    return data;
  }
}

class UserInfo {
  List<User> users;
  List<HandlerInfo> depts;
  List<Position> positions;
  List<HandlerInfo> teams;

  UserInfo({this.users, this.depts, this.positions, this.teams});

  UserInfo.fromJson(Map<String, dynamic> json) {
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
    if (json['Positions'] != null) {
      positions = new List<Position>();
      json['Positions'].forEach((v) {
        positions.add(new Position.fromJson(v));
      });
    }
    if (json['Teams'] != null) {
      teams = new List<HandlerInfo>();
      json['Teams'].forEach((v) {
        teams.add(new HandlerInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.users != null) {
      data['Users'] = this.users.map((v) => v.toJson()).toList();
    }
    if (this.depts != null) {
      data['Depts'] = this.depts.map((v) => v.toJson()).toList();
    }
    if (this.positions != null) {
      data['Positions'] = this.positions.map((v) => v.toJson()).toList();
    }
    if (this.teams != null) {
      data['Teams'] = this.teams.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


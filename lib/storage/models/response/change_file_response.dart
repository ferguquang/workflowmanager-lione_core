import 'package:workflow_manager/base/models/base_response.dart';

class ChangeFileResponse extends BaseResponse {
  Data data;

  ChangeFileResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    data = json['Data'] != null ? new Data.fromJson(json['Data']) : null;
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
  // int iD;
  String path;
  String size;
  String name;
  int created;
  String createBy;
  int updated;
  String updateBy;
  bool isFolder;
  String icon;
  bool isView;
  bool isUpdate;
  bool isDelete;
  bool isCreate;
  bool isCopy;
  bool isDownload;
  bool isMove;
  bool isShare;
  bool isNote;
  bool isPassword;
  bool isSetPassword;
  bool isChangePassword;
  int typeExtension;
  int parent;
  int isPin;
  int passwordParentId;

  Data({
      // this.iD,
      this.path,
      this.size,
      this.name,
      this.created,
      this.createBy,
      this.updated,
      this.updateBy,
      this.isFolder,
      this.icon,
      this.isView,
      this.isUpdate,
      this.isDelete,
      this.isCreate,
      this.isCopy,
      this.isDownload,
      this.isMove,
      this.isShare,
      this.isNote,
      this.isPassword,
      this.isSetPassword,
      this.isChangePassword,
      this.typeExtension,
      this.parent,
      this.isPin,
      this.passwordParentId});

  Data.fromJson(Map<String, dynamic> json) {
    // iD = json['ID'];
    path = json['Path'];
    size = json['Size'];
    name = json['Name'];
    created = json['Created'];
    createBy = json['CreateBy'];
    updated = json['Updated'];
    updateBy = json['UpdateBy'];
    isFolder = json['IsFolder'];
    icon = json['Icon'];
    isView = json['IsView'];
    isUpdate = json['IsUpdate'];
    isDelete = json['IsDelete'];
    isCreate = json['IsCreate'];
    isCopy = json['IsCopy'];
    isDownload = json['IsDownload'];
    isMove = json['IsMove'];
    isShare = json['IsShare'];
    isNote = json['IsNote'];
    isPassword = json['IsPassword'];
    isSetPassword = json['IsSetPassword'];
    isChangePassword = json['IsChangePassword'];
    typeExtension = json['TypeExtension'];
    parent = json['Parent'];
    isPin = json['IsPin'];
    passwordParentId = json['PasswordParentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['ID'] = this.iD;
    data['Path'] = this.path;
    data['Size'] = this.size;
    data['Name'] = this.name;
    data['Created'] = this.created;
    data['CreateBy'] = this.createBy;
    data['Updated'] = this.updated;
    data['UpdateBy'] = this.updateBy;
    data['IsFolder'] = this.isFolder;
    data['Icon'] = this.icon;
    data['IsView'] = this.isView;
    data['IsUpdate'] = this.isUpdate;
    data['IsDelete'] = this.isDelete;
    data['IsCreate'] = this.isCreate;
    data['IsCopy'] = this.isCopy;
    data['IsDownload'] = this.isDownload;
    data['IsMove'] = this.isMove;
    data['IsShare'] = this.isShare;
    data['IsNote'] = this.isNote;
    data['IsPassword'] = this.isPassword;
    data['IsSetPassword'] = this.isSetPassword;
    data['IsChangePassword'] = this.isChangePassword;
    data['TypeExtension'] = this.typeExtension;
    data['Parent'] = this.parent;
    data['IsPin'] = this.isPin;
    data['PasswordParentId'] = this.passwordParentId;
    return data;
  }
}

class Messages {
  int code;
  String text;

  Messages({this.code, this.text});

  Messages.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    text = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['text'] = this.text;
    return data;
  }
}

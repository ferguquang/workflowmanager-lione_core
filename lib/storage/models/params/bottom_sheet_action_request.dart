import 'package:workflow_manager/base/utils/common_function.dart';

class StgChangeFilesRequest {
  int id;
  String name;
  String accessSafePassword;
  int parent;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(name)) {
      params["Name"] = name;
    }
    if (isNotNullOrEmpty(id)) {
      params["ID"] = id;
    }
    if (isNotNullOrEmpty(accessSafePassword)) {
      params["AccessSafePassword"] = accessSafePassword;
    }
    if (isNotNullOrEmpty(parent)) {
      params["Parent"] = parent;
    }
    return params;
  }
}

class PinDocFilesRequest {
  String id;
  bool isPin;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["IsPin"] = isPin ? '1' : '0';
    if (isNotNullOrEmpty(id)) {
      params["IDDocs"] = id;
    }
    return params;
  }
}

class DeleteFilesRequest {
  String id;
  String password;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(id)) {
      params["IDDocs"] = id;
    }
    if (isNotNullOrEmpty(password)) {
      params["AccessSafePassword"] = password;
    }
    return params;
  }
}

class SetPasswordFilesRequest {
  int id;
  String currentPassword;
  String password;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(id)) {
      params["ID"] = id;
    }
    if (isNotNullOrEmpty(password)) {
      params["PasswordConfirm"] = password;
    }
    if (isNotNullOrEmpty(password)) {
      params["PasswordReplace"] = password;
    }
    if (isNotNullOrEmpty(currentPassword)) {
      params["CurrentPassword"] = currentPassword;
    } else {
      params["Password"] = password;
    }
    return params;
  }
}

class DeletePasswordFilesRequest {
  int id;
  String password;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(id)) {
      params["ID"] = id;
    }
    if (isNotNullOrEmpty(password)) {
      params["Password"] = password;
    }
    return params;
  }
}

class AuthenPassWordFilesRequest {
  int id;
  String password;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(id)) {
      params["IDDoc"] = id;
    }
    if (isNotNullOrEmpty(password)) {
      params["AccessSafePassword"] = password;
    }
    return params;
  }
}

class MoveFilesRequest {
  String id; //list id cần chuyền
  int idParent; // idParent mà cần chuyển đến
  String password;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (isNotNullOrEmpty(id)) {
      params["ID"] = id;
    }
    params["Parent"] = idParent ?? 0;
    if (isNotNullOrEmpty(password)) {
      params["AccessSafePassword"] = password;
    }
    return params;
  }
}

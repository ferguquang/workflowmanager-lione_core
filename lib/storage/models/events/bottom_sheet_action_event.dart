// dành cho di chuyển ở bottom_sheet_action.dart 1
class GetIDMoveFileEvent {
  int idMoveFile;
  String passWord;

  GetIDMoveFileEvent(this.idMoveFile, this.passWord);
}

// dành cho di chuyển ở bottom_sheet_action.dart dùng khi di chuyển thất bại 1
class GetIDMoveFileFalseEvent {
  GetIDMoveFileFalseEvent();
}

// dành cho di chuyển ở bottom_sheet_action_sub.dart hoặc list_storage_screen.dart - folderActionWidget() 1
class GetMoveListFileEvent {
  String idMoveFile;
  String passWord;

  GetMoveListFileEvent(this.idMoveFile, this.passWord);
}

class SaveIDAndPassWordEvent {
  String idMoveListFile;
  String passWord;

  SaveIDAndPassWordEvent(this.idMoveListFile, this.passWord);
}

class ActionStorageSuccessEvent {}

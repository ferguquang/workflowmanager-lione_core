class FileData {
  String newVal;
  int type;
  String title;
  int action;
  String newID;
  int oldID;
  String oldVal;
  String newPath;
  String oldPath;

  FileData.fromJson(Map<String, dynamic> json) {
    newVal = json['NewVal'];
    type = json['Type'];
    title = json['Title'];
    action = json['Action'];
    newID = json['NewID'];
    oldID = json['OldID'];
    oldVal = json['OldVal'];
    newPath = json['NewPath'];
    oldPath = json['OldPath'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['NewVal'] = newVal;
    json['Type'] = type;
    json['Title'] = title;
    json['Action'] = action;
    json['NewID'] = newID;
    json['OldID'] = oldID;
    json['OldVal'] = oldVal;
    json['NewPath'] = newPath;
    json['OldPath'] = oldPath;
    return json;
  }
}

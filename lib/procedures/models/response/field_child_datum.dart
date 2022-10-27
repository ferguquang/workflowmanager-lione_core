import 'package:workflow_manager/base/utils/common_function.dart';

import 'files.dart';

class FieldChildDatum {
  String key;
  String newVal;
  int type;
  String title;
  String newID;
  String oldID;
  String oldVal;
  List<Files> newFiles;
  List<Files> oldFiles;
  String iDGroup;

  FieldChildDatum.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    newVal = json['NewVal'];
    type = json['Type'];
    title = json['Title'];
    newID =isNullOrEmpty(json['NewID'])?"0":json['NewID'].toString() ;
    oldID = isNullOrEmpty(json['OldID'])?"0":json['OldID'].toString();
    oldVal = json['OldVal'];
    iDGroup = json['IDGroup'];
    if (json['NewFiles'] != null) {
      newFiles = new List<Files>();
      json['NewFiles'].forEach((v) {
        newFiles.add(new Files.fromJson(v));
      });
    }
    if (json['OldFiles'] != null) {
      oldFiles = new List<Files>();
      json['OldFiles'].forEach((v) {
        oldFiles.add(new Files.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['Key'] = key;
    json['NewVal'] = newVal;
    json['Type'] = type;
    json['Title'] = title;
    json['NewID'] = newID;
    json['OldID'] = oldID;
    json['OldVal'] = oldVal;
    json['IDGroup'] = iDGroup;
    if (this.oldFiles != null) {
      json['OldFiles'] = this.oldFiles.map((v) => v.toJson()).toList();
    }
    if (this.newFiles != null) {
      json['NewFiles'] = this.oldFiles.map((v) => v.toJson()).toList();
    }
    return json;
  }
}

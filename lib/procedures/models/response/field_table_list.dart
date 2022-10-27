import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';

class FieldTableList {
  List<TableFieldInfo> tableFieldInfos = [];

  FieldTableList();

  List<Field> getAllFields() {
    List<Field> fields = [];
    for (TableFieldInfo info in tableFieldInfos) {
      fields.addAll(info.fields);
    }
    return fields;
  }

  FieldTableList.fromJson(
      Map<String, dynamic> jsonTableFieldInfo, List<Field> tableFields) {
    Map<int, List<String>> mapKeys = Map();
    if (isNullOrEmpty(jsonTableFieldInfo) ||
        isNullOrEmpty(jsonTableFieldInfo["Fields"])) return;
    var fields = jsonTableFieldInfo["Fields"];
    var ids = jsonTableFieldInfo["Tables"] as List;
    Map<int, Role> mapConfigs = Map();
    for (int id in ids) {
      List keys = fields['Table$id'];
      if (keys == null) break;
      mapKeys[id] = keys.map((e) => e as String).toList();
      mapConfigs[id] = Role.fromJson(jsonTableFieldInfo["Configs"]['$id']);
    }
    var names = jsonTableFieldInfo["Names"];

    tableFieldInfos = [];
    for (int i in mapConfigs.keys) {
      Role role = mapConfigs[i];
      List<String> keys = mapKeys[i];
      TableFieldInfo tableFieldInfo = TableFieldInfo(
          isAdd: role.isAdd,
          isDelete: role.isDelete,
          isImport: role.isImport,
          listKeys: keys,
          iDTable: i,
          id: i,
          name: names != null ? names["$i"] : null);
      tableFieldInfo.getFields(tableFields);
      tableFieldInfos.add(tableFieldInfo);
    }
  }
}

class FieldKeys {
  List<String> listKeys;
  int index;

  FieldKeys({this.listKeys});

  FieldKeys.fromJson(Map<String, dynamic> json, int index) {
    while (true) {
      List keys = json['Table$index'];
      if (keys != null) {
        listKeys = keys.map((e) => e as String).toList();
      }
    }
  }
}

class TableFieldInfo {
  int iDTable;
  int id;
  bool isAdd;
  bool isDelete;
  bool isImport;
  List<String> listKeys;
  List<Field> fields;
  String name;

  TableFieldInfo(
      {this.isAdd,
      this.isDelete,
      this.isImport,
      this.listKeys,
      this.id,
      this.name,
      this.iDTable});

  getFields(List<Field> fields) {
    if (isNullOrEmpty(fields)) return;
    this.fields =
        fields.where((element) => listKeys.contains(element.key)).toList();
  }
}

class Role {
  bool isAdd;
  bool isDelete;
  bool isImport;
  int index;

  Role.fromJson(Map<String, dynamic> json) {
    isAdd = json['IsAdd'];
    isDelete = json['IsDelete'];
    isImport = json['IsImport'];
  }
}

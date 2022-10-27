import 'package:workflow_manager/procedures/models/response/files.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';

class ProdureVersion2ItemModel {
  String nameField = "";
  String content = "";
  bool isShowButton = false;
  bool isTextColor = false;
  bool isTextType = false;
  bool isCheckGroupInfos = false;
  int iNumberIndexTableField = -1;
  String filePath = "";
  List<Files> filesList = [];
  String type = "";
  String sIDGroupInfos = null;
  List<ProdureVersion2ItemModel> listGroupInfos = [];
  List<Field> tableFieldList = [];
  bool isCheckbox = false;

  ProdureVersion2ItemModel(
      {this.nameField,
      this.content,
      this.isShowButton,
      this.isTextColor,
      this.isTextType,
      this.isCheckGroupInfos,
      this.iNumberIndexTableField,
      this.filePath,
      this.filesList,
      this.type,
      this.sIDGroupInfos,
      this.listGroupInfos,
      this.tableFieldList,
      this.isCheckbox});

  ProdureVersion2ItemModel.nameConntent(String nameField, String content) {
    this.nameField = nameField;
    this.content = content;
  }
}

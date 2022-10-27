import 'single_field.dart';

class ListTableItemModel {
  List<Field> fieldList = [];
  EventCheckValidatePass eventCheckValidatePass;

  ListTableItemModel(List<Field> list) {
    this.fieldList.clear();
    for (int i = 0; i < list.length; i++) {
      Field field = new Field();
      list[i].copyTo(field);
      fieldList.add(field);
    }
  }

  List<Field> getFieldList() {
    return fieldList;
  }

  void setFieldList(List<Field> fieldList) {
    this.fieldList = fieldList;
  }

  EventCheckValidatePass getEventCheckValidatePass() {
    return eventCheckValidatePass;
  }

  void setEventCheckValidatePass(
      EventCheckValidatePass eventCheckValidatePass) {
    this.eventCheckValidatePass = eventCheckValidatePass;
  }
}

class EventCheckValidatePass {}

import 'package:workflow_manager/procedures/models/response/pair.dart';

class SendTableColListener {
  static const int TYPE_SHOW_COL = 1;
  static const int TYPE_HIDDEN_COL = 2;

  static const int TYPE_ENABLE_COL = 3;
  static const int TYPE_READONLY_COL = 4;

  void updateCol(List<Pair<int, String>> colInfo) {}

  void genTableRow(int targetId, List<Map<String, dynamic>> rows) {}

  void sendUpdateApiLinkDropDown(
      List<String> target, String link, List<String> params) {}

  void onClearDataInTableField(List<String> resetCol) {}
}

import 'package:workflow_manager/procedures/models/response/position.dart';

import 'handler_info.dart';

class ListPositionDeptSelectedModel {
  Position positionSelected;
  List<HandlerInfo> listDeptSelected;
  bool isRemovable = true;

  ListPositionDeptSelectedModel(
      {this.positionSelected, this.isRemovable, this.listDeptSelected});
}

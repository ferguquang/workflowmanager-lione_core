import 'package:workflow_manager/procedures/models/response/data_register_save_response.dart';

class EventReloadDetailProcedure {
  bool isFinish;
  DataRegisterSaveResponse response;
  EventReloadDetailProcedure({this.isFinish = false, this.response});
}

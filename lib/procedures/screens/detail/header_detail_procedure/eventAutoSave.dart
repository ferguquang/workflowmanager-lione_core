import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';

class EventAutoSave {

}

class EventDoneAutoSave {
  Conditions conditions;
  int idServiceRecord;
  bool isReject;
  bool isFinish = true;
  bool isAutoSave;

  EventDoneAutoSave({this.conditions, this.idServiceRecord, this.isReject,
    this.isFinish, this.isAutoSave});
}
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';
import 'package:workflow_manager/workflow/models/response/task_detail_response.dart';

class BackDetailData {
  int totalAttachFiles;
  int totalTodo;
  int totalSubJob;
  int newTransferJobId;
  int newExcuteId;
  JobExtension jobExtension;
  bool isApproval;
  bool isReject;
  double ratings;
  StatusItem statusItem;

  BackDetailData(
      {this.totalAttachFiles,
      this.totalTodo,
      this.totalSubJob,
      this.jobExtension,
      this.isApproval,
      this.isReject,
      this.newTransferJobId,
      this.statusItem,
      this.ratings,
      this.newExcuteId});
}

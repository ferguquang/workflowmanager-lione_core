import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/workflow/models/response/filter_task_response.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_edit_respone.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';

class CreateJobRequest {
  bool isCreate = true;
  String sName;
  String describe;
  String startDate;
  String endDate;
  Priorities priority;
  SharedSearchModel groupJob;
  SharedSearchModel executor;
  String sIDParent;
  SharedSearchModel groupJobCol;
  String sFileName;
  String sFilePath;
  List<SharedSearchModel> coexecutor;
  List<SharedSearchModel> supervisor;
  String sJobID;

  ListStatus status;
  String iDOldCoExecuter;
  String iDOldSupervisor;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if (sName.isNotNullOrEmpty) {
      params["Name"] = sName;
    }
    if (describe.isNotNullOrEmpty) {
      params["Describe"] = describe;
    }
    if (startDate.isNotNullOrEmpty) {
      params["StartDate"] = "$startDate:00";
    }
    if (endDate.isNotNullOrEmpty) {
      params["EndDate"] = "$endDate:00";
    }
    params["Priority"] = priority.key.toString();
    params["IDGroupJobCol"] = groupJobCol?.iD ?? 0;

    List<String> listIDCoexecutor = [];
    List<String> listIDSupervisor = [];
    coexecutor.forEach((element) {
      listIDCoexecutor.add(element.iD.toString());
    });
    supervisor.forEach((element) {
      listIDSupervisor.add(element.iD.toString());
    });
    if (isCreate) {
      params["IDGroupJob"] = groupJob?.iD ?? 0;
      params["IDExecutor"] = executor?.iD ?? 0;
      params["IDParent"] = sIDParent;
      if (sFileName.length > 2) {
        params["FileName"] = sFileName;
      }
      if (sFilePath.length > 2) {
        params["FilePath"] = sFilePath;
      }
      params["IDCoexecutor"] = '[' +
          FileUtils.instance.getListStringConvertString(listIDCoexecutor) +
          ']';
      params["IDSupervisor"] = '[' +
          FileUtils.instance.getListStringConvertString(listIDSupervisor) +
          ']';
      params["jobID"] = sJobID;
    } else {
      params["ID"] = sJobID;
      params["CoExecute"] = '[' +
          FileUtils.instance.getListStringConvertString(listIDCoexecutor) +
          ']';
      params["Supervisor"] = '[' +
          FileUtils.instance.getListStringConvertString(listIDSupervisor) +
          ']';
      params["IDOldCoExecuter"] = iDOldCoExecuter.toString();
      params["IDOldSupervisor"] = iDOldSupervisor.toString();
      params["IDExecuter"] = executor?.iD ?? 0;
      params["Status"] = status?.key ?? 0;
    }

    return params;
  }
}

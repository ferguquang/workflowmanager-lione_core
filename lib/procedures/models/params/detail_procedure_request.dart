// request chung cho cả chi tiết đăng ký và chi tiết giải quyết
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/action_procedure_response.dart';
import 'package:workflow_manager/procedures/models/response/handler_info.dart';
import 'package:workflow_manager/procedures/models/response/list_position_dept_selected_model.dart';
import 'package:workflow_manager/procedures/models/response/position.dart';
import 'package:workflow_manager/procedures/models/response/user.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/assign_widget/assign_widget.dart';

class DetailProcedureRequest {
  int idServiceRecord;
  String iDShare;
  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["IDServiceRecord"] = idServiceRecord;
    params["IDShare"] = iDShare;
    return params;
  }
}

class IsDoneInfoRequest {
  dynamic idStep, idSchemaCondition, id;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["IDStep"] = idStep;
    params["IDSchemaCondition"] = idSchemaCondition;
    params["ID"] = id;
    return params;
  }
}

class InfoStepHistoryRequest {
  dynamic idServiceRecordHistory, idServiceRecord, idServiceRecordWfStep;

  InfoStepHistoryRequest(
      {this.idServiceRecordHistory,
      this.idServiceRecord,
      this.idServiceRecordWfStep});

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["IDServiceRecordHistory"] = idServiceRecordHistory;
    params["IDServiceRecord"] = idServiceRecord;
    params["IDServiceRecordWfStep"] = idServiceRecordWfStep;
    return params;
  }
}

class IsResolveRequest {
  dynamic nextSchemaConditionId, idServiceRecord;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["NextSchemaConditionId"] = nextSchemaConditionId;
    params["IDServiceRecord"] = idServiceRecord;
    return params;
  }
}

class DoneInfoRequest {
  dynamic id, stepExecutor, describe, idStep, idSchemaCondition;
  dynamic idUser, idDept, idTeam, deptofIDPosition, idPosition;
  AssignWidget assignWidget;
  List<AssignWidget> listAssignWidget;
  bool isAssignExcutor;
  List<StepAssignParallels> stepAssignParallels;
  String pdfPath;
  int iDServiceRecordTemplateExport;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["IDServiceRecordTemplateExport"] = iDServiceRecordTemplateExport;
    params["ID"] = id;
    params["IDServiceRecord"] = id;
    params["StepExecutor"] = stepExecutor;
    params["IDServiceRecordWfStep"] = stepExecutor;
    params["Describe"] = describe;
    params["IDStep"] = idStep;
    params["IDSchemaCondition"] = idSchemaCondition;

    params["PdfPath"] = pdfPath;

    if (isNotNullOrEmpty(listAssignWidget) &&
        isNotNullOrEmpty(stepAssignParallels)) {
      params["ParallelStepExecutor"] =
          stepAssignParallels?.map((e) => e.iD)?.toList().toString() ?? "";

      for (int i = 0; i < listAssignWidget?.length; i++) {
        AssignWidget element = listAssignWidget[i];
        List<User> listUserSelected = element.getSelectedUsers();
        if (listUserSelected == null) listUserSelected = [];
        List<String> listIDUser = [];
        for (int i = 0; i < listUserSelected.length; i++) {
          listIDUser.add(listUserSelected[i].iD.toString());
        }
        if (listUserSelected.length >= 1) {
          params["IDUser${stepAssignParallels[i]?.iD}"] = listIDUser.join(", ");
        }
        List<HandlerInfo> listDeptSelected = element.getSelectedDepts();
        if (listDeptSelected == null) listDeptSelected = [];
        List<String> listIDDept = [];
        for (int i = 0; i < listDeptSelected.length; i++) {
          listIDDept.add(listDeptSelected[i].iD.toString());
        }
        if (listDeptSelected.length >= 1) {
          params["IDDept${stepAssignParallels[i]?.iD}"] = listIDDept.join(", ");
        }
        List<HandlerInfo> listGroupSelected = element.getSelectedTeams();
        if (listGroupSelected == null) listGroupSelected = [];
        List<String> listIDGroup = [];
        for (int i = 0; i < listGroupSelected.length; i++) {
          listIDGroup.add(listGroupSelected[i].iD.toString());
        }
        if (listGroupSelected.length >= 1) {
          params["IDTeam${stepAssignParallels[i]?.iD}"] =
              listIDGroup.join(", ");
        }

        // IDPosition và (DeptofIDPosition + ID Position) vd: DeptofIDPosition345
        List<ListPositionDeptSelectedModel> listPositionDeptSelectedModels =
            element.getSelectedPositionAndDepts();
        if (listPositionDeptSelectedModels == null)
          listPositionDeptSelectedModels = [];

        List<String> listIDPositionSelected = [];
        for (int i = 0; i < listPositionDeptSelectedModels.length; i++) {
          Position positionSelected =
              listPositionDeptSelectedModels[i].positionSelected;
          listIDPositionSelected.add(positionSelected.iD.toString());

          List<String> deptToIDPosition = [];
          for (int a = 0;
              a < listPositionDeptSelectedModels[i].listDeptSelected.length;
              a++) {
            HandlerInfo deptSelected =
                listPositionDeptSelectedModels[i].listDeptSelected[a];
            deptToIDPosition.add(deptSelected.iD.toString());
            params["DeptofIDPosition" + positionSelected.iD.toString()] =
                deptToIDPosition.join(", ");
          }
        }

        if (listIDPositionSelected.length > 0) {
          params["IDPosition${stepAssignParallels[i]?.iD}"] =
              listIDPositionSelected.join(", ");
        }
      }
    }

    if (isAssignExcutor) {
      List<User> listUserSelected = assignWidget.getSelectedUsers();
      if (listUserSelected == null) listUserSelected = [];
      List<String> listIDUser = [];
      for (int i = 0; i < listUserSelected.length; i++) {
        listIDUser.add(listUserSelected[i].iD.toString());
      }
      if (listUserSelected.length >= 1) {
        params["IDUser$stepExecutor"] = listIDUser.join(", ");
      }
      List<HandlerInfo> listDeptSelected = assignWidget.getSelectedDepts();
      if (listDeptSelected == null) listDeptSelected = [];
      List<String> listIDDept = [];
      for (int i = 0; i < listDeptSelected.length; i++) {
        listIDDept.add(listDeptSelected[i].iD.toString());
      }
      if (listDeptSelected.length >= 1) {
        params["IDDept$stepExecutor"] = listIDDept.join(", ");
      }
      List<HandlerInfo> listGroupSelected = assignWidget.getSelectedTeams();
      if (listGroupSelected == null) listGroupSelected = [];
      List<String> listIDGroup = [];
      for (int i = 0; i < listGroupSelected.length; i++) {
        listIDGroup.add(listGroupSelected[i].iD.toString());
      }
      if (listGroupSelected.length >= 1) {
        params["IDTeam$stepExecutor"] = listIDGroup.join(", ");
      }

      // IDPosition và (DeptofIDPosition + ID Position) vd: DeptofIDPosition345
      List<ListPositionDeptSelectedModel> listPositionDeptSelectedModels =
          assignWidget.getSelectedPositionAndDepts();
      if (listPositionDeptSelectedModels == null)
        listPositionDeptSelectedModels = [];

      List<String> listIDPositionSelected = [];
      for (int i = 0; i < listPositionDeptSelectedModels.length; i++) {
        Position positionSelected =
            listPositionDeptSelectedModels[i].positionSelected;
        listIDPositionSelected.add(positionSelected.iD.toString());

        List<String> deptToIDPosition = [];
        for (int a = 0;
            a < listPositionDeptSelectedModels[i].listDeptSelected.length;
            a++) {
          HandlerInfo deptSelected =
              listPositionDeptSelectedModels[i].listDeptSelected[a];
          deptToIDPosition.add(deptSelected.iD.toString());
          params["DeptofIDPosition" + positionSelected.iD.toString()] =
              deptToIDPosition.join(", ");
        }
      }

      if (listIDPositionSelected.length > 0) {
        params["IDPosition$stepExecutor"] = listIDPositionSelected.join(", ");
      }
    }

    return params;
  }
}

// add action(require action):
class IsRequireAdditionRequest {
  dynamic idServiceRecord, idStep, idWorkflow;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["IDServiceRecord"] = idServiceRecord;
    params["IDStep"] = idStep;
    params["IDWorkflow"] = idWorkflow;

    return params;
  }
}

class RequireAdditionRequest {
  dynamic idServiceRecord,
      idServiceRecordWfStepAddition,
      idServiceRecordWfStepRequired,
      content;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["IDServiceRecord"] = idServiceRecord;
    params["IDServiceRecordWfStepAddition"] = idServiceRecordWfStepAddition;
    params["IDServiceRecordWfStepRequired"] = idServiceRecordWfStepRequired;
    params["Content"] = content;

    return params;
  }
}

class IsResentInfoRequest {
  dynamic idServiceRecord, idStep;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map<String, dynamic>();
    params["IDServiceRecord"] = idServiceRecord;
    params["IDStep"] = idStep;

    return params;
  }
}

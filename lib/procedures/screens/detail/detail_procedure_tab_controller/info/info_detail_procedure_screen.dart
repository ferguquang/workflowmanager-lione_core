import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/models/response/solved_info.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/info/current_step_widget.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/info/item_widget.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/info/register_step_widget.dart';

class InfoDetailProcedureScreen extends StatefulWidget {
  DataProcedureDetail dataProcedureDetail;
  int type;
  bool isReject = false;

  InfoDetailProcedureScreen(this.dataProcedureDetail, this.type, this.isReject);

  @override
  _InfoDetailProcedureScreenState createState() =>
      _InfoDetailProcedureScreenState();
}

class _InfoDetailProcedureScreenState extends State<InfoDetailProcedureScreen> {
  static const int type_empty = 0;
  static const int type_register_info = 1;
  static const int type_current_step = 2;
  static const int type_item = 3;
  DataProcedureDetail dataProcedureDetail;
  RegisterStep registerStep;
  CurrentStep currentStep;
  List<SolvedInfo> solvedInfoList;

  @override
  void initState() {
    super.initState();
    dataProcedureDetail = widget.dataProcedureDetail;
    registerStep = dataProcedureDetail.registerStep;
    currentStep = dataProcedureDetail.currentStep;
    if (currentStep == null || currentStep.isDataEmpty() || widget.isReject) {
      currentStep = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    dataProcedureDetail = widget.dataProcedureDetail;
    registerStep = dataProcedureDetail.registerStep;
    currentStep = dataProcedureDetail.currentStep;
    if (dataProcedureDetail.currentStep == null ||
        dataProcedureDetail.currentStep.isDataEmpty() ||
        widget.isReject) {
      currentStep = null;
    }
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: ListView.builder(
            itemCount: getItemCount(),
            itemBuilder: (context, index) {
              int type = getType(index);
              switch (type) {
                case type_current_step:
                  return  CurrentStepWidget(
                    currentStep,
                    widget.type,
                    widget.dataProcedureDetail.iDServiceRecord,
                    widget.dataProcedureDetail.iDServiceRecordWfStep,
                    widget.dataProcedureDetail.title
                  );
                case type_register_info:
                  return RegisterStepWidget(registerStep, widget.type);
                case type_item:
                  return ItemWidget(solvedInfoList[index + 1], widget.type);
                default:
                  return Container();
              }
            }));
  }

  int getItemCount() {
    if ((registerStep == null || registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep == null &&
        isNullOrEmpty(solvedInfoList)) {
      return 1; // TH1: empty
    } else if ((registerStep != null &&
            !registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep == null &&
        isNullOrEmpty(solvedInfoList)) {
      return 1; // TH2: only has Register Info
    } else if ((registerStep == null ||
            registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep != null &&
        isNullOrEmpty(solvedInfoList)) {
      return 1; // TH3: only has current step
    } else if ((registerStep == null ||
            registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep == null &&
        isNotNullOrEmpty(solvedInfoList)) {
      return solvedInfoList.length; // TH4:  only has solve info list
    } else if ((registerStep != null &&
            !registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep != null &&
        isNullOrEmpty(solvedInfoList)) {
      return 2; // TH5: has registerInfo and currentStep
    } else if ((registerStep != null &&
            !registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep == null &&
        isNotNullOrEmpty(solvedInfoList)) {
      return 1 +
          solvedInfoList.length; // TH6: has registerInfo and solvedInfoList
    } else if ((registerStep == null ||
            registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep != null &&
        isNotNullOrEmpty(solvedInfoList)) {
      return 1 +
          solvedInfoList.length; // TH7: has currentStep and solvedInfoList
    } else if ((registerStep != null &&
            !registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep != null &&
        isNotNullOrEmpty(solvedInfoList)) {
      return 2 + solvedInfoList.length; // TH8: has all
    }
    return 0;
  }

  int getType(int position) {
    if ((registerStep == null || registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep == null &&
        isNullOrEmpty(solvedInfoList)) {
      return type_empty; // TH1: empty
    } else if ((registerStep != null &&
            !registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep == null &&
        isNullOrEmpty(solvedInfoList)) {
      return type_register_info; // TH2: only has Register Info
    } else if ((registerStep == null ||
            registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep != null &&
        isNullOrEmpty(solvedInfoList)) {
      return type_current_step; // TH3: only has current step
    } else if ((registerStep == null ||
            registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep == null &&
        isNotNullOrEmpty(solvedInfoList)) {
      return type_item; // TH4:  only has solve info list
    } else if ((registerStep != null &&
            !registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep != null &&
        isNullOrEmpty(solvedInfoList)) {
      // TH5: has registerInfo and currentStep
      if (position == 0) {
        return type_register_info;
      } else {
        return type_current_step;
      }
    } else if ((registerStep != null &&
            !registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep == null &&
        isNotNullOrEmpty(solvedInfoList)) {
      // TH6: has registerInfo and solvedInfoList
      if (position == 0) {
        return type_register_info;
      } else {
        return type_item;
      }
    } else if ((registerStep == null ||
            registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep != null &&
        isNotNullOrEmpty(solvedInfoList)) {
      // TH7: has currentStep and solvedInfoList
      if (position == 0) {
        return type_current_step;
      } else {
        return type_item;
      }
    } else if ((registerStep != null &&
            !registerStep.isRegisterFieldsDataEmpty()) &&
        currentStep != null &&
        isNotNullOrEmpty(solvedInfoList)) {
      // TH8: has all
      if (position == 0) {
        return type_register_info;
      } else if (position == 1) {
        return type_current_step;
      } else {
        return type_item;
      }
    }
    return type_empty; // TH1: empty
  }
}

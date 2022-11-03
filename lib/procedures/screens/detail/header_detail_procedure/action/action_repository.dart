import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/params/detail_procedure_request.dart';
import 'package:workflow_manager/procedures/models/response/action_procedure_response.dart';
import 'package:workflow_manager/procedures/models/response/data_register_save_response.dart';
import 'package:workflow_manager/procedures/models/response/data_signature_list_response.dart';
import 'package:workflow_manager/procedures/models/response/done_info_response.dart';
import 'package:workflow_manager/procedures/models/response/file_template.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/assign_widget/assign_widget.dart';
import 'package:workflow_manager/procedures/widgets/pdf/signal_screen.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';

class ActionRepository with ChangeNotifier {
  DataIsDoneInfo _dataIsDoneInfo;
  List<SelectSteps> _selectSteps;
  SelectSteps selectStep;

  DataIsDoneRequireAddition _dataIsDoneRequireAddition;
  DataIsResentInfo _dataIsResentInfo;

  bool isResolve = false;
  dynamic idStepNext, idSchemaConditionResolve;

  List<SelectSteps> get selectSteps => _selectSteps;

  DataIsDoneInfo get dataIsDoneInfo => _dataIsDoneInfo;

  DataIsDoneRequireAddition get dataIsDoneRequireAddition =>
      _dataIsDoneRequireAddition;

  DataIsResentInfo get dataIsResentInfo => _dataIsResentInfo;

  Future<int> getIsResolve(
      Conditions conditions, int idServiceRecord, bool isReject) async {
    if (conditions.type.toLowerCase() == "Resolve".toLowerCase()) {
      IsResolveRequest isResolveRequest = IsResolveRequest();
      isResolveRequest.idServiceRecord = idServiceRecord;
      isResolveRequest.nextSchemaConditionId = conditions.nextSchemaConditionId;

      var responseRecordIsResolve = await ApiCaller.instance
          .postFormData(AppUrl.recordIsResolve, isResolveRequest.getParams());
      RecordIsResolveResponse recordIsResolveResponse =
          RecordIsResolveResponse.fromJson(responseRecordIsResolve);
      if (recordIsResolveResponse.status == 1) {
        DataIsResolve dataIsResolve = recordIsResolveResponse.dataIsResolve;

        IsDoneInfoRequest infoRequest = IsDoneInfoRequest();
        infoRequest.id = idServiceRecord;
        infoRequest.idSchemaCondition = dataIsResolve.resolve.iDSchemaCondition;
        infoRequest.idStep = dataIsResolve.resolve.idStep;

        idSchemaConditionResolve = dataIsResolve.resolve.iDSchemaCondition;

        var response = await ApiCaller.instance.postFormData(
            AppUrl.recordIsDoneInfo, infoRequest.getParams(),
            isLoading: true);
        IsDoneInfoResponse isDoneInfoResponse =
            IsDoneInfoResponse.fromJson(response);
        if (isDoneInfoResponse.status == 1) {
          isResolve = true;
          _dataIsDoneInfo = isDoneInfoResponse.data;
          idStepNext = isDoneInfoResponse.data.iDServiceRecordWfStep;
          notifyListeners();
        } else {
          ToastMessage.show(isDoneInfoResponse.messages, ToastStyle.error);
        }

        return isDoneInfoResponse.status;
      } else {
        ToastMessage.show(recordIsResolveResponse.messages, ToastStyle.error);
      }
    } else {
      if (isReject) {
        IsResentInfoRequest request = IsResentInfoRequest();
        request.idServiceRecord = idServiceRecord;
        request.idStep = conditions.iDServiceRecordWfStep;
        var json = await ApiCaller.instance
            .postFormData(AppUrl.registerIsResentInfo, request.getParams());
        RegisterIsResentInfoResponse response =
            RegisterIsResentInfoResponse.fromJson(json);
        if (response.status == 1) {
          _dataIsResentInfo = response.data;
          notifyListeners();
        } else {
          ToastMessage.show(response.messages, ToastStyle.error);
        }

        return response.status;
      } else {
        //data - thông tin xác nhận chuyển bước
        IsDoneInfoRequest infoRequest = IsDoneInfoRequest();
        infoRequest.id = idServiceRecord;
        infoRequest.idStep = conditions.iDServiceRecordWfStep;
        infoRequest.idSchemaCondition = conditions.iDSchemaCondition;

        var response = await ApiCaller.instance.postFormData(
            AppUrl.recordIsDoneInfo, infoRequest.getParams(),
            isLoading: true);
        IsDoneInfoResponse isDoneInfoResponse =
            IsDoneInfoResponse.fromJson(response);
        if (isDoneInfoResponse.status == 1) {
          _dataIsDoneInfo = isDoneInfoResponse.data;
          idStepNext = isDoneInfoResponse.data.iDServiceRecordWfStep;
          notifyListeners();
        } else {
          ToastMessage.show(isDoneInfoResponse.messages, ToastStyle.error);
        }

        return isDoneInfoResponse.status;
      }
    }
  }

  // khi nhấn (Click) xác nhận chuyển bước
  Future<int> recordDoneInfo(
      Conditions conditions,
      int idServiceRecord,
      bool isAssignExcutor,
      List<AssignWidget> listAssignWidget,
      AssignWidget assignWidget,
      List<StepAssignParallels> stepAssignParallels,
      BuildContext context) async {
    DoneInfoRequest doneInfoRequest = DoneInfoRequest();
    doneInfoRequest.id = idServiceRecord;
    doneInfoRequest.stepExecutor = conditions.iDServiceRecordWfStep;
    doneInfoRequest.describe = conditions.describe;
    doneInfoRequest.idStep = idStepNext;
    doneInfoRequest.idSchemaCondition =
        isResolve ? idSchemaConditionResolve : conditions.iDSchemaCondition;
    doneInfoRequest.isAssignExcutor = isAssignExcutor;
    if (isAssignExcutor) {
      doneInfoRequest.assignWidget = assignWidget;
    }
    doneInfoRequest.listAssignWidget = listAssignWidget;
    doneInfoRequest.stepAssignParallels = stepAssignParallels;

    // doneInfoRequest.getParams();
    var json = await ApiCaller.instance
        .postFormData(AppUrl.recordDoneInfo, doneInfoRequest.getParams());
    DoneInfoResponse response = DoneInfoResponse.fromJson(json);
    if (response.data.isSigned == true) {
      doneInfoRequest.pdfPath = response.data.serviceInfoFile.path;
      doneInfoRequest.iDServiceRecordTemplateExport =
          response.data.iDServiceRecordTemplateExport;

      FileTemplate signalFile = FileTemplate(
          name: response.data.serviceInfoFile.name,
          path: "/Storage/Files/" + response.data?.serviceInfoFile?.path,
          signPath: "/Storage/Files/" + response.data?.serviceInfoFile?.path,
          extension: response.data?.serviceInfoFile?.extension);
      var status = await pushPage(
          context,
          SignalScreen(
            signalFile,
            idServiceRecord,
            "Ký khi chuyển bước",
            paramsRegitster: doneInfoRequest.getParams(),
            signatures: response.data.userSignatures,
            isTypeRegister: false,
            iDGroupPdfForm: response.data.iDGroup.toString(),
          ));
      if (status == 1) {
        return status;
      }
    } else {
      ToastMessage.show(response.messages,
          response.status == 1 ? ToastStyle.success : ToastStyle.error);
      return response.status;
    }
  }

  // addition
  Future<void> recordIsRequireAddition(
      AddAction addAction, int idServiceRecord) async {
    IsRequireAdditionRequest request = IsRequireAdditionRequest();
    request.idServiceRecord = idServiceRecord;
    request.idStep = addAction.iDStep;
    request.idWorkflow = addAction.iDWorkflow;

    var json = await ApiCaller.instance
        .postFormData(AppUrl.recordIsRequireAddition, request.getParams());
    IsRequireAdditionResponse response =
        IsRequireAdditionResponse.fromJson(json);
    if (response.status == 1) {
      _selectSteps = response.data.selectSteps;
      notifyListeners();
    }
  }

  void setSelectStep(SelectSteps itemSelected) {
    this.selectStep = itemSelected;
    notifyListeners();
  }

  Future<int> recordRequireAddition(
      int idServiceRecord,
      int idServiceRecordWfStepAddition,
      int idServiceRecordWfStepRequired,
      String content) async {
    RequireAdditionRequest request = RequireAdditionRequest();
    request.idServiceRecord = idServiceRecord;
    request.idServiceRecordWfStepAddition = idServiceRecordWfStepAddition;
    request.idServiceRecordWfStepRequired = idServiceRecordWfStepRequired;
    request.content = content;

    var json = await ApiCaller.instance
        .postFormData(AppUrl.recordRequireAddition, request.getParams());
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    ToastMessage.show(responseMessage.messages,
        responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }

  // require action:
  // register
  Future<void> registerIsDoneRequireAddition(
      AddAction addAction, int idHoSo) async {
    Map<String, dynamic> params = Map();
    params["ID"] = idHoSo;
    params["IDServiceRecordWfStepRequired"] =
        addAction.idServiceRecordWfStepRequired;

    var json = await ApiCaller.instance
        .postFormData(AppUrl.registerIsDoneRequireAddition, params);
    IsDoneRequireAdditionResponse response =
        IsDoneRequireAdditionResponse.fromJson(json);
    if (response.status == 1) {
      _dataIsDoneRequireAddition = response.data;
      notifyListeners();
    } else {
      ToastMessage.show(response.messages, ToastStyle.error);
    }
  }

  Future<int> doneRequireAddition(int idHoSo,
      AdditionalRequired additionalRequired, String describe, int type) async {
    Map<String, dynamic> params = Map();
    params["IDServiceRecord"] = idHoSo;
    params["IDServiceRecordWfStepRequired"] =
        additionalRequired.iDServiceRecordWfStepRequired;
    params["IDServiceRecordWfStepAddition"] =
        additionalRequired.iDServiceRecordWfStepAddition;
    // đang không hiểu tại sao chi tiết đăng ký lại truyền idHoSo vào Describe
    params["Describe"] =
        /*type == DetailProcedureScreen.TYPE_REGISTER ? idHoSo : */ describe;
    String api = type == DetailProcedureScreen.TYPE_REGISTER
        ? AppUrl.registerDoneRequireAddition
        : AppUrl.recordDoneRequireAddition;
    var json = await ApiCaller.instance.postFormData(api, params);
    ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    ToastMessage.show(responseMessage.messages,
        responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return responseMessage.status;
  }

  // record
  Future<void> recordIsDoneRequireAddition(
      int idHoSo, RequiredAction requiredAction) async {
    Map<String, dynamic> params = Map();
    params["ID"] = idHoSo;
    params["IDServiceRecordWfStepRequired"] =
        requiredAction.iDServiceRecordWfStepRequired;
    params["IDServiceRecordWfStepAddition"] =
        requiredAction.iDServiceRecordWfStepAddition;

    var json = await ApiCaller.instance
        .postFormData(AppUrl.registerIsDoneRequireAddition, params);
    IsDoneRequireAdditionResponse response =
        IsDoneRequireAdditionResponse.fromJson(json);
    if (response.status == 1) {
      _dataIsDoneRequireAddition = response.data;
      notifyListeners();
    } else {
      ToastMessage.show(response.messages, ToastStyle.error);
    }
  }

  Future<int> registerResentInfo(BuildContext context, int idNextStep, int idServiceRecord, String describe) async {
    Map<String, dynamic> params = Map();
    params["IDNextStep"] = idNextStep;
    params["IDServiceRecord"] = idServiceRecord;
    params["Describe"] = describe;
    var json = await ApiCaller.instance
        .postFormData(AppUrl.registerResentInfo, params);
    DataRegisterSaveResponse response = DataRegisterSaveResponse.fromJson(json);
    if (response.data.isSigned) {
      params["IDServiceRecordTemplateExport"] =
          response.data.iDServiceRecordTemplateExport;
      params["PdfPath"] = response.data.serviceInfoFile.path;
      // params["FieldIndexCreate"] = listIntString;
      FileTemplate signalFile = FileTemplate(
          name: response.data?.serviceInfoFile?.name,
          path: "/Storage/Files/" + response.data?.serviceInfoFile?.path,
          signPath:
          "/Storage/Files/" + response.data?.serviceInfoFile?.path,
          extension: response.data?.serviceInfoFile?.extension);
      SignatureLocation signatureLocation;
      if (response?.data?.serviceFormStepSignConfig != null &&
          response?.data?.serviceFormStepSignConfig?.iD > 0) {
        signatureLocation = SignatureLocation();
        signatureLocation.page =
            response.data.serviceFormStepSignConfig.page;
        signatureLocation.height =
            response.data.serviceFormStepSignConfig.height;
        signatureLocation.width =
            response.data.serviceFormStepSignConfig.width;
        signatureLocation.pageHeight =
            response.data.serviceFormStepSignConfig.pageHeight;
        signatureLocation.pageWidth =
            response.data.serviceFormStepSignConfig.pageWidth;
        signatureLocation.signPage =
            response.data.serviceFormStepSignConfig.signPage;
        signatureLocation.totalPage =
            response.data.serviceFormStepSignConfig.totalPage;
        signatureLocation.x = response.data.serviceFormStepSignConfig.x;
        signatureLocation.y = response.data.serviceFormStepSignConfig.y;
      }
      DataRegisterSaveResponse responseSignal = await pushPage(
          context,
          SignalScreen(
            signalFile,
            response.data?.serviceRecord?.iD,
            "Ký ngay khi ký",
            signatureLocation: signatureLocation,
            signatures: response.data.userSignatures,
            action: response.data.action,
            // paramsRegitster: params,
            iDGroupPdfForm: response.data.iDGroup.toString(),
          ));
    }

    // ResponseMessage responseMessage = ResponseMessage.fromJson(json);
    // ToastMessage.show(responseMessage.messages,
    //     responseMessage.status == 1 ? ToastStyle.success : ToastStyle.error);
    return response.status;
  }
}

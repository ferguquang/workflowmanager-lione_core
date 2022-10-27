import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/models/params/detail_procedure_request.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_screen.dart';

class DetailProcedureRepository with ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  DataProcedureDetail dataProcedureDetail = DataProcedureDetail();

  Future<int> getDataDetail(int idService, int type,{String idShare}) async {
    DetailProcedureRequest detailProcedureRequest = DetailProcedureRequest();
    detailProcedureRequest.idServiceRecord = idService;
    detailProcedureRequest.iDShare = idShare;
    String api = type == DetailProcedureScreen.TYPE_REGISTER
        ? AppUrl.registerInfo
        : AppUrl.recordInfo;
    final response =
        await apiCaller.postFormData(api, detailProcedureRequest.getParams(), isLoading: true);
    ResponseProcedureDetail responseProcedureDetail = ResponseProcedureDetail.fromJson(response);
    // set avatar:
    String root = await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
    if (responseProcedureDetail.data != null) {
      List<Histories> listHistory = responseProcedureDetail.data.histories;
      if(isNotNullOrEmpty(listHistory)) {
        listHistory.forEach((element) {
          element.createdBy.avatar = "$root${element.createdBy.avatar}";
        });
      }
    }
    if (responseProcedureDetail.status == 1) {
      dataProcedureDetail = responseProcedureDetail.data;
      notifyListeners();
    } else {
      ToastMessage.show(responseProcedureDetail.messages, ToastStyle.error);
    }

    return responseProcedureDetail.status;
  }
}

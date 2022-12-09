import 'package:flutter/widgets.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/procedures/models/response/check_password_signal_response.dart';
import 'package:workflow_manager/procedures/models/response/data_signature_list_response.dart';

class PdfRepository extends ChangeNotifier {
  DataSignatureList dataSignatureList;

  Future<DataSignatureList> loadAllSignals(
      int idServiceRecord, int idPdf) async {
    Map<String, dynamic> params = Map();
    params["IDServiceRecord"] = idServiceRecord;
    params["IDServiceInfoFile"] = idPdf;
    var json = await ApiCaller.instance
        .postFormData(AppUrl.getQTTTRecordSignatures, params);
    DataSignatureListResponse response =
        DataSignatureListResponse.fromJson(json);
    if (response.status == 1) {
      dataSignatureList = response.data;
      notifyListeners();
      return dataSignatureList;
    } else {
      showErrorToast(response.messages);
    }
    return null;
  }

  Future<bool> checkPassword(String password) async {
    Map<String, String> params = Map();
    params["Password"] = password;
    String url = AppUrl.getQTTTSignatureCheckPasswordSignature;
    var json = await ApiCaller.instance.postFormData(url, params, isLoading: false);
    CheckPasswordSignalResponse response = CheckPasswordSignalResponse.fromJson(json);
    if (response.status == 1) {
      return response.data;
    } else {
      showErrorToast(response.messages);
      return false;
    }
  }

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

import 'package:workflow_manager/base/utils/common_function.dart';

class InfoWorkFollowCreateRequest {
  int idService = -1;
  int IDServiceRecord = -1;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    if (idService != -1) params["IDService"] = idService;
    return params;
  }
}
class InfoWorkFollowUpdateRequest {
  int iDServiceRecord = -1;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = Map();
    if (iDServiceRecord != -1) params["IDServiceRecord"] = iDServiceRecord;
    return params;
  }
}
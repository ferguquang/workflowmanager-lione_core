import 'package:workflow_manager/base/utils/common_function.dart';

class TransferRateUserRequest {
  String sIDJob,
      sRatingNote,
      sRate,
      sReason,
      sIDNewExecutor,
      sIDOldCoExecuter,
      sIDOldSupervisor;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(isNotNullOrEmpty(sIDJob)) {
      params["IDJob"] = sIDJob;
    }
    if(isNotNullOrEmpty(sRatingNote)) {
      params["RatingNote"] = sRatingNote;
    }
    if(isNotNullOrEmpty(sRate)) {
      params["Rate"] = sRate;
    }
    if(isNotNullOrEmpty(sReason)) {
      params["Reason"] = sReason;
    }
    if(isNotNullOrEmpty(sIDNewExecutor)) {
      params["IDNewExecutor"] = sIDNewExecutor;
    }
    if(isNotNullOrEmpty(sIDOldCoExecuter)) {
      params["IDOldCoExecuter"] = sIDOldCoExecuter;
    }
    if(isNotNullOrEmpty(sIDOldSupervisor)) {
      params["IDOldSupervisor"] = sIDOldSupervisor;
    }
    return params;
  }
}

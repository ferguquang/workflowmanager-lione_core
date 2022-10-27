import 'package:workflow_manager/base/utils/common_function.dart';

class VoteTaskRequest {
  int idJob;
  String ratingNote;
  int rate;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    if(isNotNullOrEmpty(idJob)) {
      params["IDJob"] = idJob;
    }
    if(isNotNullOrEmpty(ratingNote)) {
      params["RatingNote"] = ratingNote;
    }
    if(isNotNullOrEmpty(rate)) {
      params["Rate"] = rate.toInt();
    }
    return params;
  }
}

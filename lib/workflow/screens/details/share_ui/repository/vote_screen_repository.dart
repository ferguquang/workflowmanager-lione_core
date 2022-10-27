import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/params/vote_task_request.dart';
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';
import 'package:workflow_manager/workflow/models/response/vote_task_response.dart';

class VoteScreenRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  StatusItem ratingCloseJobData;

  Future<void> ratingCloseJob(VoteTaskRequest request) async {
    final response = await apiCaller.postFormData(
        AppUrl.ratingCloseJob, request.getParams(),
        isLoading: true);

    RatingCloseJobResponse _closeJobResponse =
        RatingCloseJobResponse.fromJson(response);
    if (_closeJobResponse.isSuccess()) {
      this.ratingCloseJobData = _closeJobResponse.data;
      notifyListeners();
    } else {
      // ToastMessage.show(_closeJobResponse.messages, ToastStyle.error);
      notifyListeners();
    }
  }
}

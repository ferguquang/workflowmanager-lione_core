import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/workflow/models/notification_model.dart';
import 'package:workflow_manager/workflow/models/params/notification_request.dart';

class NotificationRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  List<NotificationInfos> notificationList = new List<NotificationInfos>();

  int page = 1;
  int _pageSize = 100;

  NotificationRequest request = NotificationRequest();

  void pullToRefreshData() {
    page = 1;
  }

  Future<void> getNotification({String term, bool isSearch = false}) async {
    this.request.pageIndex = page.toString();
    this.request.pageSize = _pageSize.toString();
    this.request.term = term;

    final response = await apiCaller.postFormData(
        AppUrl.getNotification, this.request.getParams(),
        isLoading: page == 1 && !isSearch);
    NotificationResponse notificationResponse =
        NotificationResponse.fromJson(response);

    if (notificationResponse.isSuccess(isDontShowErrorMessage: true)) {
      if (this.page == 1) {
        this.notificationList = notificationResponse.data.notificationInfos;
      } else {
        this
            .notificationList
            .addAll(notificationResponse.data.notificationInfos);
      }
      this.page++;
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Future<void> markNotificationReaded(int id) async {
    NotificationStatusRequest statusRequest = NotificationStatusRequest();
    statusRequest.id = id;
    final response = await apiCaller.postFormData(
        AppUrl.markNotificationRead, statusRequest.getParams(),
        isLoading: page == 1);
    var notificationResponse = BaseResponse.fromJson(response);

    if (notificationResponse.isSuccess(isDontShowErrorMessage: true)) {
      notifyListeners();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/workflow/models/params/search_user_request.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';

class SearchUserScreenRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  List<UserItem> userData = new List<UserItem>();

  int page = 1;
  int _pageSize = 20;

  SearchUserRequest request = SearchUserRequest();

  Future<void> getListUserName() async {
    this.request.pageIndex = page;
    this.request.pageSize = _pageSize;

    final response = await apiCaller.get(AppUrl.getListUser,
        params: this.request.getParams(), isLoading: page == 1);
    SearchUserModelResponse userResponse =
        SearchUserModelResponse.fromJson(response);

    if (userResponse.isSuccess(isDontShowErrorMessage: true)) {
      if (this.page == 1) {
        this.userData = userResponse.data;
      } else {
        this.userData.addAll(userResponse.data);
      }
      this.page++;
      notifyListeners();
    } else {
      ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }

  Future<void> getJobGroupForSearch() async {
    this.request.pageIndex = page;
    this.request.pageSize = _pageSize;

    final response = await apiCaller.get(AppUrl.getJobGroupForSearch,
        params: this.request.getParams(), isLoading: page == 1);
    SearchUserModelResponse userResponse =
        SearchUserModelResponse.fromJson(response);

    if (userResponse.isSuccess(isDontShowErrorMessage: true)) {
      if (this.page == 1) {
        this.userData = userResponse.data;
      } else {
        this.userData.addAll(userResponse.data);
      }

      this.page++;
      notifyListeners();
    } else {
      ToastMessage.show('Đã xảy ra lỗi khi lấy dữ liệu', ToastStyle.error);
      notifyListeners();
    }
  }
}

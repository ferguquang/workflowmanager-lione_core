import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/selected_user_search_request.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_auser_response.dart';

class SelectedUserSearchRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;
  List<AUser> userData = new List();
  int idUserSelected = -1;

  SelectedUserSearchRequest request = SelectedUserSearchRequest();

  Future<void> getByName(String name) async {
    request.term = name;
    final response = await apiCaller.postFormData(
        AppUrl.getBorrowAuser, request.getParams(),
        isLoading: true);
    BorrowAuserResponse userResponse = BorrowAuserResponse.fromJson(response);
    if (userResponse.isSuccess()) {
      userData = userResponse.data.aUser;

      String root = await SharedPreferencesClass.getRoot();
      userData.forEach((element) {
        element.avatar = root + element.avatar;
        if (element.iD == idUserSelected) element.isCheck = true;
      });
      notifyListeners();
    }
    /*else {
      ToastMessage.show(userResponse.messages, ToastStyle.error);
    }*/
  }
}

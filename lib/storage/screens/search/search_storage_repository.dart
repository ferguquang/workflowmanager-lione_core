import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/manager/models/params/login_request.dart';
import 'package:workflow_manager/storage/models/params/storage_index_request.dart';
import 'package:workflow_manager/storage/repository/search_storage_model.dart';
import 'package:workflow_manager/storage/screens/tabs/main_tab_storage_screen.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';

import 'detail/detail_search_storage_screen.dart';

class SearchStorageRepository extends ChangeNotifier {
  static const int FILE = 0;
  static const int TIME = 1;
  static const int DOC = 2;
  static const int SEARCH = 3;
  static const int TITLE = 4;

  ApiCaller apiCaller = ApiCaller.instance;
  // List<DocTypes> docTypes;x
  List<SearchStorageModel> listModel = [];

  Future<void> login() async {
    LoginRequest loginRequest = LoginRequest();
    loginRequest.userName =
        await SharedPreferencesClass.getValue(SharedPreferencesClass.USER_NAME);
    loginRequest.password =
        await SharedPreferencesClass.getValue(SharedPreferencesClass.PASS_WORD);
    loginRequest.isCloudApi =
        await SharedPreferencesClass.get(SharedPreferencesClass.IS_CLOUD_API) ??
            false;
    final response =
        await apiCaller.postFormData(AppUrl.login, loginRequest.getParams());
    final LoginResponse authResponse = LoginResponse.fromJson(response);
    if (authResponse.isSuccess()) {
      addList();
      await addRepositoryForList(authResponse.data.docTypes);
      notifyListeners();
    }
  }

  addRepositoryForList(List<DocTypes> docTypes) {
    for (int i = 0; i < docTypes.length; i++) {
      listModel.add(SearchStorageModel(
          docTypes[i].iD, 'assets/images/icon_day.png', docTypes[i].name, DOC));
    }
  }

  addList() {
    listModel.add(SearchStorageModel(null, null, 'Loại tệp', TITLE));

    listModel.add(SearchStorageModel(1, 'assets/images/pdf.png', 'PDF', FILE));
    listModel.add(SearchStorageModel(
        2, 'assets/images/doc.png', 'Tài liệu văn bản', FILE));
    listModel.add(SearchStorageModel(
        3, 'assets/images/xls.png', 'Bảng tính excel', FILE));
    listModel.add(SearchStorageModel(
        4, 'assets/images/ppt.png', 'Trình chiêu Powpoint', FILE));
    listModel.add(SearchStorageModel(
        5, 'assets/images/png.png', 'Ảnh và hình ảnh', FILE));
    listModel
        .add(SearchStorageModel(6, 'assets/images/mp4.png', 'Video', FILE));
    listModel
        .add(SearchStorageModel(7, 'assets/images/mp3.png', 'Âm thanh', FILE));
    listModel.add(
        SearchStorageModel(10, 'assets/images/folder.png', 'Thư mục', FILE));

    listModel.add(SearchStorageModel(null, null, 'Ngày tạo', TITLE));
    listModel.add(
        SearchStorageModel(1, 'assets/images/icon_day.png', 'Hôm nay', TIME));
    listModel.add(
        SearchStorageModel(2, 'assets/images/icon_day.png', 'Hôm qua', TIME));
    listModel.add(SearchStorageModel(
        3, 'assets/images/icon_day.png', '7 ngày qua', TIME));
    listModel.add(SearchStorageModel(
        4, 'assets/images/icon_day.png', '30 ngày qua', TIME));
    listModel.add(SearchStorageModel(
        5, 'assets/images/icon_day.png', '90 ngày qua', TIME));

    listModel.add(SearchStorageModel(null, null, 'Loại văn bản', TITLE));
  }

  clickScreen(BuildContext context, int position, String search,
      StorageTopTabType typeStorage, StorageBottomTabType type) async {
    List<String> typeExtensionList = [];
    List<String> tpDateCreateList = [];
    List<String> iDDoctypeList = [];
    List<SearchStorageModel> listCheck = [];

    for (int i = 0; i < listModel.length; i++) {
      SearchStorageModel data = listModel[i];
      if (i == position) data.isCheck = true;
      if (data.isCheck) {
        listCheck.add(data);
        if (data.type == FILE) {
          typeExtensionList.add(data.position.toString());
        } else if (data.type == TIME) {
          tpDateCreateList.add(data.position.toString());
        } else if (data.type == DOC) {
          iDDoctypeList.add(data.position.toString());
        }
        data.isCheck = false;
      }
    }

    StorageIndexRequest request = StorageIndexRequest();

    if (typeExtensionList.length > 0) {
      request.typeExtension =
          FileUtils.instance.getListStringConvertString(typeExtensionList);
    }

    if (tpDateCreateList.length > 0) {
      request.tpDateCreate =
          FileUtils.instance.getListStringConvertString(tpDateCreateList);
    }

    if (iDDoctypeList.length > 0) {
      request.iDDoctype =
          FileUtils.instance.getListStringConvertString(iDDoctypeList);
    }

    request.term = '$search';
    request.idDoc = 0;
    request.take = 20;
    request.skip = 1;
    pushPage(context,
        DetailSearchStorageScreen(request, listCheck, null, typeStorage, type));
    notifyListeners();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/base/models/storage_index_response.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/storage/models/events/bottom_sheet_action_event.dart';
import 'package:workflow_manager/storage/models/params/bottom_sheet_action_request.dart';
import 'package:workflow_manager/storage/models/params/check_download_file_request.dart';
import 'package:workflow_manager/storage/models/params/create_folder_request.dart';
import 'package:workflow_manager/storage/models/params/save_up_file_request.dart';
import 'package:workflow_manager/storage/models/params/storage_index_request.dart';
import 'package:workflow_manager/storage/models/response/create_folder_response.dart';
import 'package:workflow_manager/storage/models/response/save_up_file_response.dart';
import 'package:workflow_manager/storage/repository/search_storage_model.dart';
import 'package:workflow_manager/storage/screens/search/detail/detail_search_storage_screen.dart';
import 'package:workflow_manager/storage/screens/search/search_storage_repository.dart';
import 'package:workflow_manager/workflow/models/response/upload_response.dart';

import '../tabs/main_tab_storage_screen.dart';

class ListStorageRepository extends ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  StorageIndexRequest storageIndexRequest = StorageIndexRequest();

  StorageTopTabType typeStorage;

  StorageBottomTabType type;

  List<DocChildItem> listDocs = [];
  List<DocChildItem> listCheckDocs = [];
  String message = "";
  DocChildItem docParent;
  bool isCheckCreate = false;
  int errorCode;
  bool isCheckSelecteAll = false;

  List<String> typeExtensionList;
  List<String> tpDateCreateList;
  List<String> iDDoctypeList;

  Future<bool> getDocumentList() async {
    this.message = "";
    String url = "";
    if (this.storageIndexRequest.idDoc != null &&
        this.storageIndexRequest.idDoc != 0) {
      url = AppUrl.getStorageIndex();
    } else {
      if (this.typeStorage == StorageTopTabType.Document) {
        url = AppUrl.getStorageIndex();
      } else if (this.typeStorage == StorageTopTabType.Pin) {
        url = AppUrl.getStoragePins();
      } else if (this.typeStorage == StorageTopTabType.Recently) {
        url = AppUrl.getStorageRecents();
      }
    }
    // print("===========> url: ${url}");
    final response = await apiCaller.postFormData(
        url, storageIndexRequest.getParams(),
        isLoading: storageIndexRequest.skip == 1);
    StorageIndexResponse _storageIndexResponse =
        StorageIndexResponse.fromJson(response);
    if (storageIndexRequest.skip == 1) {
      this.listDocs.clear();
    }
    if (_storageIndexResponse.isSuccess()) {
      if (isCheckSelecteAll) {
        _storageIndexResponse.data?.docChilds?.forEach((element) {
          element?.isCheck = true;
        });
        this.listCheckDocs.addAll(_storageIndexResponse.data.docChilds);
      }
      this.listDocs.addAll(_storageIndexResponse.data.docChilds);

      // this.request.skip++;
      docParent = _storageIndexResponse.data.docParent;
      isCheckCreate = docParent.isCreate;
      if (this.type == StorageBottomTabType.Shared ||
          this.typeStorage == StorageTopTabType.Pin ||
          this.typeStorage == StorageTopTabType.Recently) {
        isCheckCreate = false;
      }
      notifyListeners();
      return true;
    } else {
      errorCode = _storageIndexResponse.errorCode;
      message = _storageIndexResponse.messages;
      // ToastMessage.show(_storageIndexResponse.messages, ToastStyle.error);
      // print("Size listDocs = ${listDocs.length}");
      notifyListeners();
      return false;
    }
  }

  Future<void> createNewFolder(CreateFolderRequest newFolderRequest) async {
    String url = AppUrl.getCreateNewFolder();
    final response =
        await apiCaller.postFormData(url, newFolderRequest.getParams());
    CreateFolderResponse _createFolderResponse =
        CreateFolderResponse.fromJson(response);
    if (_createFolderResponse.isSuccess(isShowSuccessMessage: true)) {
      pullToRefreshData();
      getDocumentList();
      // ToastMessage.show(_createFolderResponse.messages, ToastStyle.success);
      notifyListeners();
    }
    /*else {
      ToastMessage.show(_createFolderResponse.messages, ToastStyle.error);
      notifyListeners();
    }*/
  }

  Future<void> saveUpFile(SaveUpFileRequest saveUpFileRequest) async {
    String url = AppUrl.getSaveupFile();
    final response =
        await apiCaller.postFormData(url, saveUpFileRequest.getParams());
    SaveUpFileResponse _saveUpFileResponse =
        SaveUpFileResponse.fromJson(response);
    if (_saveUpFileResponse.isSuccess(isShowSuccessMessage: true)) {
      pullToRefreshData();
      getDocumentList();
      // ToastMessage.show(_saveUpFileResponse.messages, ToastStyle.success);
      // notifyListeners();
    }
    /*else {
      ToastMessage.show(_saveUpFileResponse.messages, ToastStyle.error);
      notifyListeners();
    }*/
  }

  Future<bool> checkBeforeDownloadFile(CheckDownloadFileRequest request,
      {bool isShared}) async {
    String url = AppUrl.checkDownloadFile(isShared: isShared);
    final response = await apiCaller.postFormData(url, request.getParams());
    BaseResponse _baseResponse = BaseResponse.fromJson(response);
    if (_baseResponse.isSuccess()) {
      return true;
    } else {
      // ToastMessage.show(_baseResponse.messages, ToastStyle.error);
      errorCode = _baseResponse.errorCode;
      return false;
    }
  }

  // upload profile when use capture
  Future<void> uploadFileCamera(
      String pathFile, int idDoc, String password) async {
    print("uploadFileCamera pathFile = ${pathFile}");
    UploadModel uploadModel = await FileUtils().uploadFileWithPath(pathFile);
    if (uploadModel != null) {
      SaveUpFileRequest _request = SaveUpFileRequest();
      _request.path = uploadModel.filePath;
      _request.name = uploadModel.fileName;
      _request.parent = idDoc;
      _request.docTypes = 0;
      _request.accessSafePassword = password;
      this.saveUpFile(_request);
    }
  }

  Future<bool> callApiGetDocumentList(bool isFirstIndex,
      {String sortName, int sortType, int idDoc, String password}) {
    if (isNotNullOrEmpty(password)) {
      this.storageIndexRequest.accessSafePassword = password;
    }
    if (isFirstIndex) {
      this.storageIndexRequest.skip = 1;
      this.storageIndexRequest.take = 10;
      this.storageIndexRequest.idDoc = idDoc ?? 0;
      this.storageIndexRequest.sortname = sortName ?? "Name";
      this.storageIndexRequest.sortType = sortType ?? 1;
    } else {
      this.storageIndexRequest.skip = this.storageIndexRequest.skip + 1;
    }
    return this.getDocumentList();
  }

  void pullToRefreshData() {
    storageIndexRequest.skip = 1;
  }

  void eventClickShowData(DocChildItem item, String search,
      BuildContext context, String passWord) async {
    StorageIndexRequest request = StorageIndexRequest();
    request.idDoc = item.iD;
    request.take = 100;
    request.skip = 1;
    request.accessSafePassword = passWord;
    pushPage(context,
        DetailSearchStorageScreen(request, null, item, typeStorage, type));
  }

  // Di chuyển thu mục, files
  Future<int> getStgFileMove(String idMove, String passWordFileMove) async {
    MoveFilesRequest requestMove = MoveFilesRequest();
    requestMove.id = idMove;
    requestMove.idParent = docParent.iD;
    requestMove.password = passWordFileMove;

    final response = await apiCaller.postFormData(
        AppUrl.getStorageMove(), requestMove.getParams());
    BaseResponse baseResponse = BaseResponse.fromJson(response);
    if (baseResponse.isSuccess(isShowSuccessMessage: true)) {
      // ToastMessage.show(baseResponse.messages, ToastStyle.success);
      eventBus.fire(GetIDMoveFileEvent(null, null));
      return null;
    } else {
      // ToastMessage.show(baseResponse.messages, ToastStyle.error);
      if (baseResponse.errorCode == 1002) return 1002;
      eventBus.fire(GetIDMoveFileFalseEvent());
    }
  }

  checkListThreeSearch(List<SearchStorageModel> listCheck) {
    typeExtensionList = [];
    tpDateCreateList = [];
    iDDoctypeList = [];
    for (int i = 0; i < listCheck.length; i++) {
      SearchStorageModel data = listCheck[i];
      if (data.type == SearchStorageRepository.FILE) {
        typeExtensionList.add(data.position.toString());
      } else if (data.type == SearchStorageRepository.TIME) {
        tpDateCreateList.add(data.position.toString());
      } else if (data.type == SearchStorageRepository.DOC) {
        iDDoctypeList.add(data.position.toString());
      }
    }
  }

  removeListCheckSearch(List<SearchStorageModel> listCheck, int index) async {
    listCheck.removeAt(index);
    await checkListThreeSearch(listCheck);

    notifyListeners();

    storageIndexRequest.typeExtension = null;
    if (typeExtensionList.length > 0) {
      storageIndexRequest.typeExtension =
          FileUtils.instance.getListStringConvertString(typeExtensionList);
    }

    storageIndexRequest.tpDateCreate = null;
    if (tpDateCreateList.length > 0) {
      storageIndexRequest.tpDateCreate =
          FileUtils.instance.getListStringConvertString(tpDateCreateList);
    }

    storageIndexRequest.iDDoctype = null;
    if (iDDoctypeList.length > 0) {
      storageIndexRequest.iDDoctype =
          FileUtils.instance.getListStringConvertString(iDDoctypeList);
    }
    pullToRefreshData();
    getDocumentList();
  }
}

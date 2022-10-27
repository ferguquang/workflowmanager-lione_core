import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/models/storage_index_response.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/custom_dialog.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/storage/models/events/bottom_sheet_action_event.dart';
import 'package:workflow_manager/storage/models/params/check_download_file_request.dart';
import 'package:workflow_manager/storage/models/params/storage_index_request.dart';
import 'package:workflow_manager/storage/repository/search_storage_model.dart';
import 'package:workflow_manager/storage/screens/list_storage/list_storage_repository.dart';
import 'package:workflow_manager/storage/screens/tabs/main_tab_storage_screen.dart';
import 'package:workflow_manager/storage/widgets/bottom_sheet_action/bottom_sheet_action_repository.dart';
import 'package:workflow_manager/storage/widgets/bottom_sheet_action_sub.dart';
import 'package:workflow_manager/storage/widgets/dialog/dialog_authen_pass_word.dart';
import 'package:workflow_manager/storage/widgets/dialog/dialog_get_pass_word.dart';
import 'package:workflow_manager/base/utils/palette.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'list_storage_item.dart';

class DetailSearchStorageScreen extends StatefulWidget {
  // String image;
  // String name;
  StorageIndexRequest request;
  List<SearchStorageModel> listCheck;
  var isShowAction = 1;
  String passWord;
  DocChildItem docChildItem;
  StorageTopTabType typeStorage;

  StorageBottomTabType type;

  DetailSearchStorageScreen(
      this.request,
      this.listCheck,
      this.docChildItem,
      this.typeStorage,
      this.type); // ẩn hiện floatingbutton = 1, selected = 2, move = 3

  // DetailSearchStorageScreen(this.image, this.name, this.request);

  @override
  State<StatefulWidget> createState() {
    return DetailSearchStorageState();
  }
}

class DetailSearchStorageState extends State<DetailSearchStorageScreen>
    with AutomaticKeepAliveClientMixin {
  ListStorageRepository listStorageRepository;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  TextEditingController searchController = TextEditingController();
  ListStorageRepository _listStorageRepository = ListStorageRepository();

  void _listenerEventBus() {
    eventBus.on<ActionStorageSuccessEvent>().listen((event) {
      // bottom_sheet_action.dart khi nhấn vào các item(ghim, xóa , đặt-thay-xóa mật khẩu, thay thế)
      // bottom_sheet_action_sub.dart khi nhấn vào các item(xóa, ghim)
      _onRefresh();
      _listStorageRepository.listCheckDocs.clear();
      widget.isShowAction = 1;
    });

    eventBus.on<GetRemoveCheckEventBus>().listen((event) {
      // bottom_sheet_action_sub.dart khi nhấn vào Xóa lựa chọn
      setState(() {
        widget.isShowAction = 1;
        _listStorageRepository.listCheckDocs.clear();
        _listStorageRepository.listDocs.forEach((element) {
          element.isCheck = false;
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchController.text = widget.request.term;
    listStorageRepository = ListStorageRepository();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getDocumentList();
      _listenerEventBus();
    });
  }

  void _getDocumentList() async {
    listStorageRepository.storageIndexRequest = widget.request;
    listStorageRepository.typeStorage = widget.typeStorage;
    listStorageRepository.type = widget.type;
    if (isNotNullOrEmpty(widget.passWord))
      listStorageRepository.storageIndexRequest.accessSafePassword =
          widget.passWord;
    bool status = await listStorageRepository.getDocumentList();

    if (!status && listStorageRepository.errorCode == 1002) {
      CustomDialogWidget(
          context,
          DialogGetPassWordScreen(
            onGetPassListener: (String passWord) async {
              this.widget.passWord = passWord;
              _getDocumentList();
            },
            onExitPassListener: () {
              Navigator.of(context).pop();
            },
          )).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => listStorageRepository,
      child: Consumer(
        builder:
            (context, ListStorageRepository _listStorageRepository, child) {
          return Scaffold(
            appBar: AppBar(
              leading: BackIconButton(),
              title: TextField(
                controller: searchController,
                style: TextStyle(color: Colors.white),
                textInputAction: TextInputAction.search,
                onSubmitted: (value) {
                  listStorageRepository.storageIndexRequest.term = value;
                  listStorageRepository.getDocumentList();
                },
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm',
                  hintStyle: TextStyle(color: Colors.white60),
                  enabledBorder: new UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Palette.borderEditText.toColor())),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            ),
            body: SafeArea(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.listCheck == null || widget.listCheck.length == 0
                          ? const Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Không có bộ lọc nào",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
                          : SizedBox(
                              height: 50,
                              child: ListView.builder(
                                itemCount: widget.listCheck.length ?? 0,
                                scrollDirection: Axis.horizontal,
                                // ignore: missing_return
                                itemBuilder: (context, index) {
                                  return itemListHeaderWidget(
                                      widget.listCheck[index], index);
                                },
                              ),
                            ),
                      Container(
                        height: 1,
                        color: getColor('#dedede'),
                      ),
                      Expanded(
                          child: listStorageRepository?.listDocs == null ||
                                  listStorageRepository?.listDocs?.length == 0
                              ? EmptyScreen()
                              : listViewWidget())
                    ],
                  ),
                  folderActionWidget()
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget itemListHeaderWidget(SearchStorageModel item, int index) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 8,
          ),
          Image.asset(
            item.image ?? "",
            width: 20,
            height: 20,
          ),
          const SizedBox(
            width: 5,
          ),
          Text(
            item.text ?? "",
            style: TextStyle(color: Colors.grey),
          ),
          IconButton(
            alignment: Alignment.center,
            onPressed: () {
              if (widget.listCheck.length > 1) {
                listStorageRepository.removeListCheckSearch(
                    widget.listCheck, index);
              } else {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(
              Icons.cancel_outlined,
              size: 20,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }

  //folder footer
  Widget folderActionWidget() {
    return Visibility(
      visible: widget.isShowAction == 2 ? true : false,
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.only(left: 16),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.grey)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                  '${_listStorageRepository.listCheckDocs?.length ?? 0} mục'),
              flex: 5,
            ),
            Expanded(
                child: IconButton(
              onPressed: () {
                _getDeletesListFolder();
              },
              icon: Icon(
                Icons.delete,
                color: Colors.black,
              ),
            )),
            Expanded(
                child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (ctx) {
                      return SizedBox(
                        child: BottomSheetActionSub(
                            context, _listStorageRepository, false),
                        height: 300.0,
                      );
                    });
              },
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget listViewWidget() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: true,
      header: WaterDropHeader(),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          } else if (mode == LoadStatus.failed) {
          } else if (mode == LoadStatus.canLoading) {
          } else {}
          return Container(
            height: 55.0,
            child: Center(
              child: body,
            ),
          );
        },
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: ListView.separated(
        itemCount: listStorageRepository?.listDocs?.length ?? 0,
        itemBuilder: (context, index) {
          DocChildItem item = listStorageRepository?.listDocs[index];
          item.isMove = false;
          item.passWordItem = '';
          return listStorageRepository?.listDocs == null ||
                  listStorageRepository?.listDocs?.length == 0
              ? EmptyScreen()
              : InkWell(
                  onTap: () {
                    if (item.isFolder) {
                      listStorageRepository.eventClickShowData(
                          item, searchController.text, context, null);
                    } else {
                      _showFile(item, passWord: null);
                    }
                  },
                  child: ListStorageItem(
                      item, _listStorageRepository.docParent?.iD),
                  onLongPress: () {
                    setState(() {
                      if (item.isCheck) {
                        item.isCheck = false;
                        _listStorageRepository.listCheckDocs.remove(item);
                        if (_listStorageRepository.listCheckDocs?.length == 0) {
                          widget.isShowAction = 1;
                        }
                      } else {
                        item.isCheck = true;
                        widget.isShowAction = 2;
                        _listStorageRepository.listCheckDocs.add(item);
                      }
                    });
                  },
                );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  // Download và xem chi tiết 1 file
  _showFile(DocChildItem item, {String passWord}) async {
    CheckDownloadFileRequest request = CheckDownloadFileRequest();
    request.idDoc = item.iD;
    request.accessSafePassword = passWord;
    bool status = await _listStorageRepository.checkBeforeDownloadFile(request);
    if (status) {
      FileUtils.instance.downloadFileAndOpen(item.name, item.path, context,
          typeExtension: item.typeExtension);
    } else if (!status && _listStorageRepository.errorCode == 1002) {
      CustomDialogWidget(context, DialogGetPassWordScreen(
        onGetPassListener: (String passWord) async {
          _showFile(item, passWord: passWord);
        },
      )).show();
    }
  }

  // xóa danh sách đã chọn
  void _getDeletesListFolder() {
    int isCheckPassWord = 0;
    int isCheckRemove = 0;
    List<String> listDocIds = List();
    _listStorageRepository.listCheckDocs.forEach((element) {
      listDocIds.add(element.iD.toString());
      if (element.isPassword) {
        isCheckPassWord++;
      }
      if (!element.isDelete) {
        isCheckRemove++;
      }
    });

    if (isCheckRemove > 0) {
      ToastMessage.show(
          'Có $isCheckRemove tài liệu không có quyền xóa', ToastStyle.error);
      return;
    }

    switch (isCheckPassWord) {
      case 0:
        // tất cả folder không có mật khẩu
        ConfirmDialogFunction(
            content: 'Bạn có muốn xóa không?',
            context: context,
            onAccept: () {
              BottomSheetActionRepository _deleteRepository =
                  BottomSheetActionRepository();
              _deleteRepository.getDeletesListFile(
                  FileUtils.instance.getListStringConvertString(listDocIds),
                  null);
            }).showConfirmDialog();
        break;

      case 1:
        // 1 folder và folder đó có mật khẩu
        if (_listStorageRepository.listCheckDocs.length == 1) {
          ConfirmDialogFunction(
              content: 'Bạn có muốn xóa không?',
              context: context,
              onAccept: () {
                _eventDeleteFile(int.parse(listDocIds[0]), null);
              }).showConfirmDialog();
        } else {
          ToastMessage.show(
              'Bạn không thể xóa nhiều tài liệu có mật khẩu', ToastStyle.error);
        }
        break;

      default:
        // tất cả folder có nhiều hơn 1 mật khẩu
        ToastMessage.show(
            'Bạn không thể xóa nhiều tài liệu có mật khẩu', ToastStyle.error);
        break;
    }
  }

  _eventDeleteFile(int id, String passWord) async {
    BottomSheetActionRepository _deleteRepository =
        BottomSheetActionRepository();
    int errorCode =
        await _deleteRepository.getDeletesListFile(id.toString(), passWord);
    if (isNullOrEmpty(errorCode) && errorCode == 1002) {
      CustomDialogWidget(
              context,
              DialogAuthenPassWordScreen(
                id,
                onSuccessPassWord: (int value, String passWordSuccess) {
                  if (value == 1) {
                    _eventDeleteFile(id, passWordSuccess);
                  }
                },
              ),
              isClickOutWidget: true)
          .show();
    }
  }

  @override
  bool get wantKeepAlive => true;

  void _onRefresh() async {
    FocusScope.of(context).unfocus();
    _refreshController.refreshCompleted();
    listStorageRepository.pullToRefreshData();
    listStorageRepository.getDocumentList();
  }

  void _onLoading() async {
    FocusScope.of(context).unfocus();
    listStorageRepository.storageIndexRequest.skip++;
    _refreshController.loadComplete();
    listStorageRepository.getDocumentList();
  }
}

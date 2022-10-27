import 'dart:async';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workflow_manager/base/models/storage_index_response.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/ui/bottom_sheet_dialog.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/custom_dialog.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/floating_buttom_widget.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/base/utils/one_signal_manager.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/storage/models/events/bottom_sheet_action_event.dart';
import 'package:workflow_manager/storage/models/events/change_tab_event.dart';
import 'package:workflow_manager/storage/models/params/check_download_file_request.dart';
import 'package:workflow_manager/storage/models/params/create_folder_request.dart';
import 'package:workflow_manager/storage/models/params/save_up_file_request.dart';
import 'package:workflow_manager/storage/screens/list_storage/list_storage_repository.dart';
import 'package:workflow_manager/storage/screens/search/detail/list_storage_item.dart';
import 'package:workflow_manager/storage/screens/search/search_storage_screen.dart';
import 'package:workflow_manager/storage/widgets/bottom_sheet_action/bottom_sheet_action_repository.dart';
import 'package:workflow_manager/storage/widgets/bottom_sheet_action_sub.dart';
import 'package:workflow_manager/storage/widgets/dialog/dialog_authen_pass_word.dart';
import 'package:workflow_manager/storage/widgets/dialog/dialog_get_pass_word.dart';
import 'package:workflow_manager/workflow/models/response/pair_reponse.dart';

import '../tabs/main_tab_storage_screen.dart';

class ListStorageScreen extends StatefulWidget {
  StorageTopTabType typeStorage;

  StorageBottomTabType type;

  int idDoc; // id của folder cha

  int sortType = 0; // 0: Không sort, 1: Tên, 2: Thời gian chỉnh sửa, 3: Tạo

  String title;

  String password;

  String idFileForMove;

  String passWordFileMove;

  DocChildItem item; // doc item của màn hiện tại

  StreamSubscription changeTabSubs;

  ListStorageScreen({
    this.typeStorage,
    this.type,
    this.item,
    this.idFileForMove,
    this.passWordFileMove,
  });

  @override
  State<StatefulWidget> createState() {
    return ListStorageState();
  }
}

class ListStorageState extends State<ListStorageScreen> {
  int idDoc;
  String title;
  String password;
  String _image;

  // idFileForMove, passWordFileMove phải khai báo và sử dụng ở đây thì event bus mới tác động được?
  String idFileForMove;
  String passWordFileMove;
  final picker = ImagePicker();
  var isCheckSort = false;

  var isShowAction = 1; // ẩn hiện floatingbutton = 1, selected = 2, move = 3
  bool isVisible = false;
  List<Pair> listSort = [
    Pair(key: 1, value: "Tên", selectType: 1),
    Pair(key: 2, value: "Thời gian chỉnh sửa"),
    Pair(key: 3, value: "Thời gian tạo"),
    // Pair(key: 4, value: "Huỷ"),
  ];

  Pair selectItem = Pair();

  var nameSortCode = 'Name';

  ListStorageRepository _listStorageRepository = ListStorageRepository();

  TextEditingController _createFolderNameController = TextEditingController();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  StreamSubscription _actionStorageSuccessSubs;

  StreamSubscription _moveListFileSubs;

  StreamSubscription _iDMoveFileSubs;

  StreamSubscription _iDMoveFileFalseSubs;

  StreamSubscription _removeCheckSubs;

  void _listenerEventBus() {
    // bottom_sheet_action.dart khi nhấn vào các item(ghim, xóa , đặt-thay-xóa mật khẩu, thay thế)
    // bottom_sheet_action_sub.dart khi nhấn vào các item(xóa, ghim)
    if (_actionStorageSuccessSubs != null) _actionStorageSuccessSubs.cancel();
    _actionStorageSuccessSubs =
        eventBus.on<ActionStorageSuccessEvent>().listen((event) {
      _listStorageRepository.isCheckSelecteAll = false;
      _getDocumentList();
      isShowAction = 1;
      widget.idFileForMove = null;
      _listStorageRepository?.listCheckDocs?.clear();
    });

    // Khi click di chuyển folder và di chuyển thành công
    if (_iDMoveFileSubs != null) _iDMoveFileSubs.cancel();
    _iDMoveFileSubs = eventBus.on<GetIDMoveFileEvent>().listen((event) {
      setState(() {
        _listStorageRepository?.listCheckDocs?.clear();
        if (event.idMoveFile != null) {
          // chạy vào đây khi bấm nào bottomsheet di chuyển bottom_sheet_action.dart dòng 193
          isShowAction = 3;
          passWordFileMove = event.passWord;
          idFileForMove = event.idMoveFile.toString();
          _listStorageRepository?.listDocs?.forEach((element) {
            if (element?.iD == event.idMoveFile) {
              element?.isCheck = true;
              // không break; dc ở đây????
            }
          });
        } else {
          // chạy vào đây khi di chuyển thành công list_storage_repository.dart dòng 133
          isShowAction = 1;
          _getDocumentList();
          idFileForMove = null;
          passWordFileMove = null;
        }
      });
    });

    // Khi di chuyển failure
    if (_iDMoveFileFalseSubs != null) _iDMoveFileFalseSubs.cancel();
    _iDMoveFileFalseSubs =
        eventBus.on<GetIDMoveFileFalseEvent>().listen((event) {
      setState(() {
        // widget.isCheckMove = false;
        _listStorageRepository?.listCheckDocs?.clear();
        isShowAction = 1;
        idFileForMove = null;
        passWordFileMove = null;
        _listStorageRepository?.listDocs?.forEach((element) {
          element?.isCheck = false;
        });
      });
    });

    // khi nhấn vào Xóa lựa chọn
    if (_removeCheckSubs != null) _removeCheckSubs.cancel();
    _removeCheckSubs = eventBus.on<GetRemoveCheckEventBus>().listen((event) {
      setState(() {
        isShowAction = 1;
        _listStorageRepository?.listCheckDocs?.clear();
        _listStorageRepository?.listDocs?.forEach((element) {
          element?.isCheck = false;
        });
      });
    });

    // click di chuyển list folder trong bottomsheet
    if (_moveListFileSubs != null) _moveListFileSubs.cancel();
    _moveListFileSubs = eventBus.on<GetMoveListFileEvent>().listen((event) {
      setState(() {
        isShowAction = 3;
        idFileForMove = event.idMoveFile;
        passWordFileMove = event.passWord;
      });
    });

    // load lại list khi chuyển tab
    if (widget.changeTabSubs != null) widget.changeTabSubs.cancel();
    widget.changeTabSubs = eventBus.on<ChangeTabEvent>().listen((event) {
      if (AppStore.currentBottomViewTypeStorage != widget.type) {
        return;
      }
      this._listStorageRepository.pullToRefreshData();
      this._getDocumentList();
    });
  }

  // Khi di chuyển folder
  _eventClickMove({String passWord}) async {
    int errorCode =
        await _listStorageRepository.getStgFileMove(idFileForMove, passWord);
    if (isNotNullOrEmpty(errorCode) && errorCode == 1002) {
      CustomDialogWidget(context, DialogGetPassWordScreen(
        onGetPassListener: (String passWord) async {
          isShowAction = 3;
          _eventClickMove(passWord: passWord);
        },
      )).show();
    }
  }

  void _getDocumentList() async {
    bool status = await this._listStorageRepository.callApiGetDocumentList(true,
        idDoc: idDoc,
        password: password,
        sortName: this.nameSortCode,
        sortType: selectItem.selectType);
    if (!status && _listStorageRepository.errorCode == 1002) {
      //1002: lỗi xác thực
      CustomDialogWidget(
          context,
          DialogGetPassWordScreen(
            onGetPassListener: (String passWord) async {
              this.password = passWord;
              _getDocumentList();
            },
            onExitPassListener: () {
              Navigator.of(context).pop();
            },
          )).show();
    }
  }

  @override
  void dispose() {
    super.dispose();
    removeScreenName(widget);
    if (_actionStorageSuccessSubs != null) _actionStorageSuccessSubs.cancel();
    if (_iDMoveFileSubs != null) _iDMoveFileSubs.cancel();
    if (_iDMoveFileFalseSubs != null) _iDMoveFileFalseSubs.cancel();
    if (_removeCheckSubs != null) _removeCheckSubs.cancel();
    if (_moveListFileSubs != null) _moveListFileSubs.cancel();
    if (widget.changeTabSubs != null) widget.changeTabSubs.cancel();
  }

  @override
  void initState() {
    super.initState();
    eventBus.on<NotiData>().listen((event) {
      if (isVisible) {
        Navigator.pop(context);
      }
      pushPage(
          context,
          ListStorageScreen(
            typeStorage: event.typeStorage,
            type: event.type,
            item: event.item,
          ));
    });
    this._listStorageRepository.type = this.widget.type;
    this._listStorageRepository.typeStorage = this.widget.typeStorage;
    idFileForMove = widget.idFileForMove;
    passWordFileMove = widget.passWordFileMove;
    if (idFileForMove != null) {
      isShowAction = 3;
    }
    title = widget.item?.name ?? 'Kho dữ liệu';
    idDoc = widget.item?.iD;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getDocumentList();
      _listenerEventBus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("liststore"),
      onVisibilityChanged: (info) {
        isVisible = info.visibleFraction == 1;
      },
      child: ChangeNotifierProvider.value(
        value: this._listStorageRepository,
        child: Consumer(
          builder: (context, ListStorageRepository _repository, _) {
            return Scaffold(
              appBar: appBarWidget(),
              body: SafeArea(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned(
                      child: Column(
                        children: [
                          headerWidget(),
                          Container(
                            margin: EdgeInsets.only(top: 5),
                          ),
                          Expanded(
                            child: Container(
                              child: SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                header: WaterDropHeader(),
                                footer: CustomFooter(
                                  builder:
                                      (BuildContext context, LoadStatus mode) {
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
                                controller: this._refreshController,
                                onRefresh: this._onRefresh,
                                onLoading: this._onLoadMore,
                                child: isNullOrEmpty(
                                        _listStorageRepository.listDocs)
                                    ? EmptyScreen(
                                        message: _listStorageRepository.message)
                                    : listDataWidget(),
                              ),
                              color: Colors.white,
                            ),
                          ),
                          showMoveWidget()
                        ],
                      ),
                    ),
                    folderActionWidget()
                  ],
                ),
              ),
              floatingActionButton: Visibility(
                visible:
                    _listStorageRepository.isCheckCreate && isShowAction == 1
                        ? true
                        : false,
                child: FloatingButtonWidget(
                  onSelectedButton: () => createDataWidget(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //ui di chuyển
  Widget showMoveWidget() {
    return Visibility(
      visible: isShowAction == 3 ? true : false,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FlatButton(
              onPressed: () {
                setState(() {
                  isShowAction = 1;
                  idFileForMove = null;
                  _listStorageRepository.listCheckDocs?.clear();
                  _listStorageRepository.listDocs?.forEach((element) {
                    element?.isCheck = false;
                  });
                });
              },
              child: const Text(
                'THOÁT',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            FlatButton(
              onPressed: () {
                if (_listStorageRepository.docParent.isCreate) {
                  _eventClickMove();
                } else {
                  ToastMessage.show(
                      'Bạn chưa được quyền tạo trên thư mục ${_listStorageRepository.docParent.name}',
                      ToastStyle.error);
                }
              },
              child: const Text(
                'DI CHUYỂN',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //folder footer
  Widget folderActionWidget() {
    return Visibility(
      visible: isShowAction == 2 ? true : false,
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
              flex: 4,
            ),
            Expanded(
                child: IconButton(
              onPressed: () {
                setState(() {
                  getMoveListFolder();
                });
              },
              icon: Icon(
                Icons.snippet_folder_outlined,
                color: Colors.grey,
              ),
            )),
            Expanded(
                child: IconButton(
              onPressed: () {
                _getDeletesListFolder();
              },
              icon: Icon(
                Icons.delete,
                color: Colors.grey,
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
                            context, _listStorageRepository, true),
                        height: 300.0,
                      );
                    });
              },
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
            )),
          ],
        ),
      ),
    );
  }

  // appbar
  Widget appBarWidget() {
    if (widget.item?.iD != null && widget.item?.iD != 0) {
      return AppBar(
        title: Text(title),
        leading: BackIconButton(
          onTapListener: () {
            SaveIDAndPassWordEvent saveIDAndPassWord =
                SaveIDAndPassWordEvent(idFileForMove, passWordFileMove);
            Navigator.of(context).pop(saveIDAndPassWord);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              pushPage(context,
                  SearchStorageScreen(StorageTopTabType.Document, widget.type));
            },
          ),
        ],
      );
    }
    return null;
  }

  //popup menu
  void _eventClickPopUpMenu(int value) {
    if (value == 0) {
    } else if (value == 1) {
      isShowAction = 2;
      _listStorageRepository.listDocs?.forEach((element) {
        element?.isCheck = true;
      });
      _listStorageRepository.listCheckDocs
          ?.addAll(_listStorageRepository.listDocs);
    } else if (value == 2) {
      isShowAction = 1;
      _listStorageRepository.listDocs?.forEach((element) {
        element.isCheck = false;
      });
      _listStorageRepository.listCheckDocs?.clear();
    }
  }

  // tạo
  Widget createDataWidget() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return SizedBox(
            // ignore: null_aware_before_operator
            height: 160.0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tạo mới',
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.folder_sharp,
                                color: Colors.grey,
                                size: 40,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'Thư mục',
                                style: TextStyle(color: Colors.black),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            this._displayDialogWithInputTextWidget(context);
                            // Navigator.of(context).pop();
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.upload_sharp,
                                color: Colors.grey,
                                size: 40,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text('Tải lên')
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            this._execUpload();
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.photo_camera_outlined,
                                color: Colors.grey,
                                size: 40,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text('Quét')
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            this._execScan();
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  //header thư mục tài liệu
  Widget headerWidget() {
    return InkWell(
      onTap: () {
        setState(() {
          // isCheckSort = !isCheckSort;
        });
      },
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 16),
        //all(16),
        color: Colors.grey[200],
        child: Row(
          children: [
            const Text('Thư mục tài liệu'),
            const Spacer(),
            const SizedBox(
              width: 5,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  if (this.isShowAction == 1) {
                    this._eventClickPopUpMenu(1);
                    _listStorageRepository.isCheckSelecteAll = true;
                  } else {
                    // this._eventClickPopUpMenu(2);
                    _listStorageRepository.isCheckSelecteAll = false;
                    isShowAction = 1;
                    _listStorageRepository.listCheckDocs.clear();
                    _listStorageRepository.listDocs?.forEach((element) {
                      element?.isCheck = false;
                    });
                  }
                });
              },
              child: Text(
                this.isShowAction == 1 ? "Chọn" : "Huỷ",
                style: TextStyle(color: Colors.blue),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 5),
            ),
            SVGImage(
                svgName: 'ic_filter',
                onTap: () {
                  this._execSortBy();
                }),
          ],
        ),
      ),
    );
  }

  //listView
  Widget listDataWidget() {
    return ListView.separated(
      itemCount: this._listStorageRepository?.listDocs?.length ?? 0,
      itemBuilder: (context, index) {
        DocChildItem item = this._listStorageRepository?.listDocs[index];
        item.passWordItem = password;
        return InkWell(
          child: ListStorageItem(item, _listStorageRepository.docParent?.iD),
          onTap: () {
            _showNextScreen(item);
          },
          onLongPress: () {
            setState(() {
              if (item.isCheck) {
                item.isCheck = false;
                _listStorageRepository?.listCheckDocs?.remove(item);
                if (_listStorageRepository?.listCheckDocs?.length == 0) {
                  isShowAction = 1;
                }
              } else {
                item.isCheck = true;
                isShowAction = 2;
                _listStorageRepository?.listCheckDocs?.add(item);
              }
            });
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  // create - tạo thư mục
  Future<void> _displayDialogWithInputTextWidget(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Tạo thư mục',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          content: TextField(
            controller: _createFolderNameController,
            decoration: InputDecoration(
              hintText: "Nhập tên",
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey, width: 1.0),
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Huỷ bỏ'.toUpperCase(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                'Đồng ý'.toUpperCase(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                Navigator.pop(context);
                this._execCreateFolder();
              },
            ),
          ],
        );
      },
    );
  }

  //create - tải lên
  Future<void> _execUpload() async {
    var file = await FileUtils.instance
        .uploadFileFromSdcard(context, fileType: FileType.any);
    SaveUpFileRequest _request = SaveUpFileRequest();
    _request.path = file.filePath;
    _request.name = file.fileName;
    _request.parent = idDoc ?? 0;
    _request.docTypes = 0;
    _request.accessSafePassword = password;

    _listStorageRepository.saveUpFile(_request);
  }

  //create - quét
  Future<void> _execScan() async {
    BottomSheetDialog bottomSheetDialog = BottomSheetDialog(
      context: context,
      onTapListener: (item) async {
        if (item.key == 1) {
          displayImagePicker();
        } else {
          var file = await FileUtils.instance
              .uploadFileFromSdcard(context, fileType: FileType.image);
          SaveUpFileRequest _request = SaveUpFileRequest();
          _request.path = file.filePath;
          _request.name = file.fileName;
          _request.parent = idDoc ?? 0;
          _request.docTypes = 0;
          _request.accessSafePassword = password;

          _listStorageRepository.saveUpFile(_request);
        }
      },
    );
    List<Pair> list = [
      Pair(key: 1, value: "Camera"),
      Pair(key: 2, value: "Thư viện ảnh"),
    ];
    await bottomSheetDialog.showBottomSheetDialog(list);
  }

  Future<void> _execSortBy() async {
    BottomSheetDialog bottomSheetDialog = BottomSheetDialog(
      context: context,
      onTapListener: (item) async {
        this.selectItem = item;
        listSort.forEach((element) {
          if (element.key == item.key) {
            element.selectType = item.selectType;
            return;
          }
        });
        switch (item.key) {
          case 1:
            this.nameSortCode = 'Name';
            break;
          case 2:
            this.nameSortCode = 'Updated';
            break;
          case 3:
            this.nameSortCode = 'Created';
            break;
          // case 4:
          //   break;
        }
        // 2 dòng này để clear dữ liệu đã chọn
        isShowAction = 1;
        _listStorageRepository.listCheckDocs.clear();
        _listStorageRepository.isCheckSelecteAll = false;
        this._listStorageRepository.callApiGetDocumentList(true,
            sortName: this.nameSortCode,
            sortType: item.selectType,
            idDoc: idDoc);
      },
    );
    await bottomSheetDialog.showBottomSheetDialogWithCheckIcon(listSort,
        icon1: Icons.arrow_downward, icon2: Icons.arrow_upward);
  }

  //call api create - thư mục
  Future<void> _execCreateFolder() async {
    CreateFolderRequest _request = CreateFolderRequest();
    _request.parent = idDoc ?? 0;
    _request.name = _createFolderNameController.text;
    _request.accessSafePassword = password;
    _listStorageRepository.createNewFolder(_request);
    _createFolderNameController.text = "";
  }

  Future displayImagePicker() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile.path;
        var file = _listStorageRepository.uploadFileCamera(
            pickedFile.path, idDoc ?? 0, password);
        print("image path: ${_image}");
      } else {
        print('No image selected.');
      }
    });
  }

// di chuyển danh sách đã chọn
  void getMoveListFolder() {
    int isCheckPassWord = 0;
    int isCheckMove = 0;
    List<String> listString = List();
    _listStorageRepository?.listCheckDocs?.forEach((element) {
      listString.add(element?.iD?.toString());
      if (element.isPassword) {
        isCheckPassWord++;
      }
      if (!element.isMove) {
        isCheckMove++;
      }
    });

    if (isCheckMove > 0) {
      ToastMessage.show('Có $isCheckMove tài liệu không có quyền di chuyển',
          ToastStyle.error);
      return;
    }

    switch (isCheckPassWord) {
      case 0:
        // tất cả folder không có mật khẩu
        isShowAction = 3;
        // convert list về String
        idFileForMove =
            FileUtils.instance.getListStringConvertString(listString);
        // widget.passWordFileMove = widget.password;
        passWordFileMove = null;
        break;

      case 1:
        // 1 folder và folder đó có mật khẩu
        if (_listStorageRepository?.listCheckDocs?.length == 1) {
          // CustomDialogWidget(
          //         context,
          //         DialogAuthenPassWordScreen(
          //           int.parse(listString[0]),
          //           onSuccessPassWord: (int value, String passWord) {
          //             if (value == 1) {
          //               setState(() {
          isShowAction = 3;
          //                 // convert list về String
          idFileForMove =
              FileUtils.instance.getListStringConvertString(listString);
          passWordFileMove = null;
          //               });
          //             }
          //           },
          //         ),
          //         isClickOutWidget: true)
          //     .show();
        } else {
          ToastMessage.show(
              'Bạn không thể di chuyển nhiều tài liệu có mật khẩu',
              ToastStyle.error);
        }
        break;

      default:
        // tất cả folder có nhiều hơn 1 mật khẩu
        ToastMessage.show('Bạn không thể di chuyển nhiều tài liệu có mật khẩu',
            ToastStyle.error);
        break;
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
    if (isNotNullOrEmpty(errorCode) && errorCode == 1002) {
      _eventDialogAuthenPassWordDelete(id);
    }
  }

  _eventDialogAuthenPassWordDelete(int id) {
    CustomDialogWidget(
            context,
            DialogAuthenPassWordScreen(
              id,
              onSuccessPassWord: (int value, String passWordSuccess) {
                if (value == 1) {
                  _eventDeleteFile(id, passWordSuccess);
                } else {
                  _eventDialogAuthenPassWordDelete(id);
                }
              },
            ),
            isClickOutWidget: true)
        .show();
  }

  void _onRefresh() async {
    isShowAction = 1;
    _listStorageRepository?.listCheckDocs?.clear();
    _listStorageRepository.isCheckSelecteAll = false;

    this._refreshController.refreshCompleted();
    this._listStorageRepository.pullToRefreshData();
    this._listStorageRepository.callApiGetDocumentList(
          true,
          sortName: nameSortCode,
          sortType: selectItem.selectType,
          idDoc: idDoc,
        );
  }

  void _onLoadMore() async {
    this._refreshController.loadComplete();
    this._listStorageRepository.callApiGetDocumentList(
          false,
          idDoc: idDoc,
        );
  }

  void _showNextScreen(DocChildItem item) async {
    if (item.isFolder) {
      SaveIDAndPassWordEvent saveIDAndPassWord = await pushPage(
          context,
          ListStorageScreen(
            typeStorage: widget.typeStorage,
            type: widget.type,
            item: item,
            idFileForMove: idFileForMove,
            passWordFileMove: passWordFileMove,
          ));

      idFileForMove = saveIDAndPassWord.idMoveListFile;
      passWordFileMove = saveIDAndPassWord.passWord;
      setState(() {
        if (idFileForMove != null) {
          isShowAction = 3;
        }
      });
    } else {
      _showFile(item);
    }
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
}

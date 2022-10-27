import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/ui/webview_screen.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/divider_widget.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/commons/separator_header_widget.dart';
import 'package:workflow_manager/shopping_management/constracts/manager_serial/serial_detail/serial_detail_repository.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/serial_detail_model.dart';
import 'package:workflow_manager/shopping_management/response/serial_detail_update_response.dart';

class SerialDetailScreen extends StatefulWidget {
  int id;
  bool isEditing;

  SerialDetailScreen(this.id, this.isEditing);

  @override
  _SerialDetailScreenState createState() => _SerialDetailScreenState();
}

class _SerialDetailScreenState extends State<SerialDetailScreen> {
  SerialDetailRepository _detailRepository = SerialDetailRepository();

  @override
  void initState() {
    super.initState();
    _detailRepository.isEditing = widget.isEditing;
    _detailRepository.loadOrInitDate(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!widget.isEditing
            ? "Chi tiết quản lý serial"
            : widget.id == null
                ? "Tạo mới serial"
                : "Cập nhật serial"),
      ),
      body: ChangeNotifierProvider.value(
        value: _detailRepository,
        child: Consumer(
          builder:
              (context, SerialDetailRepository serialDetailRepository, child) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _detailRepository?.listItems?.length ?? 0,
                          itemBuilder: (context, index) {
                            ContentShoppingModel model =
                                _detailRepository?.listItems?.elementAt(index);
                            return ContentViewShoppingItem(
                              model: model,
                              onClick: (model, position) {
                                if (model.isNextPage == false) return;
                                if (model ==
                                    _detailRepository.codeRequestItem) {
                                  if (isNullOrEmpty(
                                      _detailRepository.requisitions)) {
                                    showErrorToast("Không có dữ liệu");
                                    return;
                                  }
                                  pushPage(
                                      context,
                                      ChoiceDialog(
                                          context,
                                        _detailRepository.requisitions,
                                        getTitle: (data) => data.name,
                                        title: model.title,
                                        hintSearchText: "Tìm kiếm",
                                        selectedObject:
                                            isNullOrEmpty(model?.selected)
                                                ? []
                                                : _detailRepository.requisitions
                                                    .where((element) =>
                                                        element.iD ==
                                                            model?.selected
                                                                ?.elementAt(0)
                                                                ?.iD ??
                                                        -1)
                                                    .toList(),
                                        choiceButtonText: "Lưu",
                                        onAccept: (list) async {
                                          if (isNullOrEmpty(list)) {
                                            model.value = "";
                                            model.selected = [];
                                            model.idValue = null;
                                            _detailRepository.contacts = [];
                                            _detailRepository.serialDetailModel
                                                .serial.requisition = [];
                                            _detailRepository.serialDetailModel
                                                .serial.contract = [];
                                            _detailRepository.codeContractItem
                                                ?.clearSelected();
                                            _detailRepository.notifyListeners();
                                          } else {
                                            // isCheckCodeContract = true;
                                            _detailRepository.iIDCodeRequest =
                                                list[0].iD;
                                            _detailRepository.serialDetailModel
                                                .serial.contract = [];
                                            model.value = list[0].name;
                                            model.selected = list;
                                            model.idValue = list[0].iD;
                                            _detailRepository.serialDetailModel
                                                .serial.requisition = [
                                              Requisition(
                                                  iD: list[0].iD,
                                                  name: list[0].name,
                                                  key: list[0].key)
                                            ];
                                            await _detailRepository
                                                .loadContractCode(
                                                    _detailRepository
                                                        .iIDCodeRequest);
                                            _detailRepository.notifyListeners();
                                          }
                                        },
                                      ));
                                } else if (model ==
                                    _detailRepository.codeContractItem) {
                                  if (isNullOrEmpty(
                                      _detailRepository.iIDCodeRequest)) {
                                    showErrorToast("Hãy chọn Mã yêu cầu trước");
                                    return;
                                  }
                                  if (isNullOrEmpty(
                                      _detailRepository.contacts)) {
                                    showErrorToast("Không có dữ liệu");
                                    return;
                                  }
                                  pushPage(
                                      context,
                                      ChoiceDialog<Requisitions>(
                                        context,
                                        _detailRepository.contacts,
                                        hintSearchText: "Tìm kiếm",
                                        getTitle: (data) => data.name,
                                        selectedObject: isNullOrEmpty(
                                                _detailRepository
                                                    .serialDetailModel
                                                    .serial
                                                    .contract)
                                            ? []
                                            : _detailRepository.contacts
                                                .where((element) =>
                                                    element.iD ==
                                                        _detailRepository
                                                            .serialDetailModel
                                                            .serial
                                                            .contract
                                                            ?.elementAt(0)
                                                            ?.iD ??
                                                    -1)
                                                .toList(),
                                        title: model.title,
                                        choiceButtonText: "Lưu",
                                        onAccept: (list) {
                                          if (isNullOrEmpty(list)) {
                                            model.value = "";
                                            model.selected = [];
                                            model.idValue = null;
                                            _detailRepository.serialDetailModel
                                                .serial.contract = [];
                                            _detailRepository.notifyListeners();
                                          } else {
                                            _detailRepository.iIDCodeRequest =
                                                list[0].iD;
                                            model.value = list[0].name;
                                            model.selected = list;
                                            model.idValue = list[0].iD;
                                            _detailRepository.serialDetailModel
                                                .serial.contract = [
                                              Contract(
                                                  iD: list[0].iD,
                                                  name: list[0].name,
                                                  key: list[0].key)
                                            ];
                                            _detailRepository.notifyListeners();
                                          }
                                        },
                                      ));
                                } else {
                                  _detailRepository.openFile(context, model);
                                }
                              },
                            );
                          },
                        ),
                        SeparatorHeaderWidget(
                          "Dữ liệu quản lý serial",
                          isShowIcon: widget.isEditing,
                          onTap: () async {
                            var resutl = await showSerialDetails(null);
                          },
                        ),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _detailRepository
                                  ?.serialDetailModel?.serialDetails?.length ??
                              0,
                          itemBuilder: (context, index) {
                            SerialDetails serial = _detailRepository
                                ?.serialDetailModel?.serialDetails[index];
                            return Slidable(
                              actionPane: SlidableDrawerActionPane(),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                "assets/images/icon_item_commodity_category.webp",
                                                width: 40,
                                                height: 40,
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      serial?.nameCommodity ??
                                                          "",
                                                      style: TextStyle(
                                                          color: getColor(
                                                              "#6BA3DB"),
                                                          fontSize: 16),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("Mã hàng: "),
                                                        Expanded(
                                                            child: Text(serial
                                                                    ?.commodity
                                                                    ?.name ??
                                                                ""))
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("Số serial: "),
                                                        Expanded(
                                                            child: Text(serial
                                                                    ?.serialNo ??
                                                                ""))
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        RightArrowIcons(
                                          isVisible:
                                              _detailRepository.isEditing,
                                        )
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 1,
                                    height: 1,
                                  )
                                ],
                              ),
                              secondaryActions: widget.isEditing == true
                                  ? [
                                      IconSlideAction(
                                        color: Colors.grey[100],
                                        iconWidget: Icon(
                                          Icons.edit,
                                          color: Colors.blue,
                                        ),
                                        onTap: () async {
                                          showSerialDetails(serial);
                                        },
                                      ),
                                      IconSlideAction(
                                        color: Colors.grey[100],
                                        iconWidget: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onTap: () async {
                                          showConfirmDialog(context,
                                              "Bạn có muốn xóa serial này?",
                                              () async {
                                            _detailRepository.remove(serial);
                                          });
                                        },
                                      ),
                                    ]
                                  : [],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible:
                      _detailRepository.isCreate || _detailRepository.isEditing,
                  child: SaveButton(
                    margin: EdgeInsets.all(16),
                    title: "Xong",
                    onTap: () async {
                      bool isSuccess = await _detailRepository.updateOrCreate();
                      if (isSuccess == true) {
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  showSerialDetails(SerialDetails serialDetails) async {
    List<ContentShoppingModel> list = [];
    ContentShoppingModel commondity = ContentShoppingModel(
        title: "Mã hàng hóa",
        isRequire: true,
        isNextPage: widget.isEditing,
        isDropDown: true,
        selected: isNullOrEmpty(serialDetails?.commodity)
            ? []
            : _detailRepository?.commodities
                ?.where((element) =>
                    element.iD == (serialDetails?.commodity?.iD ?? -1))
                ?.toList(),
        dropDownData: _detailRepository.commodities,
        getTitle: (data) => data.name);
    list.add(commondity);
    ContentShoppingModel name = ContentShoppingModel(
        title: "Tên hàng hóa",
        isRequire: false,
        isNextPage: false,
        value: serialDetails?.nameCommodity);
    list.add(name);
    ContentShoppingModel serialNumber = ContentShoppingModel(
      title: "Số serial",
      isRequire: true,
      isNextPage: widget.isEditing,
      value: serialDetails?.serialNo,
    );
    list.add(serialNumber);
    var result = await pushPage(
        context,
        ListWithArrowScreen(
          data: list,
          screenTitle: serialDetails == null
              ? "Thêm mới dữ liệu serial"
              : "Chỉnh sửa dữ liệu serial",
          isShowSaveButton: true,
          saveTitle: "Lưu",
          onValidValue: (data) {
            if (isNullOrEmpty(commondity.selected)) {
              showErrorToast("Không được để trống hàng hóa");
              return false;
            }
            if (isNullOrEmpty(serialNumber.value)) {
              showErrorToast("Không được để trống số serial");
              return false;
            }
            return true;
          },
          onValueChanged: (model) async {
            if (model == commondity) {
              name.value = model.selected[0].fullName;
            }
          },
        ));
    if (result != null) {
      if (serialDetails == null) {
        serialDetails = SerialDetails();
        serialDetails.serialNo = serialNumber.value;
        Requisition requisition = Requisition(
          iD: commondity.selected[0].iD,
          name: commondity.selected[0].name,
          key: commondity.selected[0].key,
        );
        serialDetails.commodity = requisition;
        serialDetails.nameCommodity = commondity.selected[0].fullName;
        _detailRepository.serialDetailModel.serialDetails.add(serialDetails);
        _detailRepository.notifyListeners();
      } else {
        serialDetails.commodity.iD = commondity.selected[0].iD;
        serialDetails.commodity.name = commondity.selected[0].name;
        serialDetails.commodity.key = commondity.selected[0].key;
        serialDetails.serialNo = serialNumber.value;
        serialDetails.nameCommodity = commondity.selected[0].fullName;
      }
      _detailRepository.notifyListeners();
    }
  }
}

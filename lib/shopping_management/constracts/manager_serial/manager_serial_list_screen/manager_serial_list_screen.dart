import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/constracts/manager_serial/manager_serial_list_screen/manager_serial_list_repository.dart';
import 'package:workflow_manager/shopping_management/constracts/manager_serial/serial_detail/serial_detail_screen.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/manager_serial_list_reponse.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';

class ManagerSerialListScreen extends StatefulWidget {
  @override
  _ManagerSerialListScreenState createState() =>
      _ManagerSerialListScreenState();
}

class _ManagerSerialListScreenState extends State<ManagerSerialListScreen> {
  ManagerSerialListRepository _managerSerialListRepository =
      ManagerSerialListRepository();
  RefreshController _refreshController = RefreshController();
  List<ContentShoppingModel> filterList = [];

  @override
  void initState() {
    super.initState();

    _managerSerialListRepository.refreshController = _refreshController;
    _managerSerialListRepository.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _managerSerialListRepository,
      child: Consumer(
        builder: (context,
            ManagerSerialListRepository managerSerialListRepository, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Quản lý serial"),
              ),
              floatingActionButton: Container(
                margin: EdgeInsets.only(bottom: 40),
                child: Visibility(
                  visible: _managerSerialListRepository
                          ?.managerSerialListModel?.isCreate ==
                      true,
                  child: FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () async {
                      var result = await pushPage(
                          context, SerialDetailScreen(null, true));
                      if (result == true)
                        _managerSerialListRepository.refreshData();
                    },
                  ),
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropHeader(
                          complete: Container(),
                        ),
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
                        onRefresh: _managerSerialListRepository.refreshData,
                        onLoading: _managerSerialListRepository.loadMore,
                        child: isNullOrEmpty(_managerSerialListRepository
                            ?.managerSerialListModel?.serials)
                            ? Center(
                          child: Text("Không có dữ liệu"),
                        )
                            : ListView.builder(
                          itemCount: managerSerialListRepository
                              ?.managerSerialListModel
                              ?.serials
                              ?.length ??
                              0,
                          itemBuilder: (context, index) {
                            Serials serial = managerSerialListRepository
                                .managerSerialListModel.serials[index];
                            return InkWell(
                              onTap: () async {
                                var result = await pushPage(context,
                                    SerialDetailScreen(serial.iD, false));
                                if (result == true)
                                  _managerSerialListRepository
                                      .refreshData();
                              },
                              child: Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                child: Container(
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
                                                    "assets/images/icon_magage_serial.webp",
                                                    width: 40,
                                                    height: 40,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 16),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          serial?.project ?? "",
                                                          style: TextStyle(
                                                              color: getColor(
                                                                  "#6BA3DB"),
                                                              fontSize: 16),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 4),
                                                        ),
                                                  Row(
                                                    children: [
                                                      Text("Mã PR: "),
                                                      Expanded(
                                                          child: Text(serial
                                                              .requisitionNumber ??
                                                              ""))
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                    EdgeInsets.only(
                                                        top: 4),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                          "Mã PO: ${serial.pONumber}"),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      RightArrowIcons()
                                    ],
                                  ),
                                ),
                                secondaryActions: [
                                  Visibility(
                                    visible: serial.isUpdate,
                                    child: IconSlideAction(
                                      color: Colors.grey[100],
                                      iconWidget: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onTap: () async {
                                        var result = await pushPage(
                                            context,
                                            SerialDetailScreen(
                                                serial.iD, true));
                                        if (result == true)
                                          _managerSerialListRepository
                                              .refreshData();
                                      },
                                    ),
                                  ),
                                  Visibility(
                                    visible: serial.isDelete,
                                    child: IconSlideAction(
                                      color: Colors.grey[100],
                                      iconWidget: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onTap: () async {
                                        showConfirmDialog(context,
                                            "Bạn có muốn xóa danh mục hàng hòa này không?",
                                                () async {
                                              var result =
                                              await _managerSerialListRepository
                                                  .delete(serial.iD);
                                              if (result == true) {
                                                _managerSerialListRepository
                                                    .managerSerialListModel
                                                    .serials
                                                    .remove(serial);
                                                _managerSerialListRepository
                                                    .notifyListeners();
                                              }
                                            });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
                  ),
                  SortFilterBaseWidget(
                    onSortType: _managerSerialListRepository.sort,
                    onFilter: filter,
                    sortType: _managerSerialListRepository.sortType,
                  )
                ],
              )
          );
        },
      ),
    );
  }


  filter() async {
    if (isNullOrEmpty(filterList)) {
      ContentShoppingModel model = ContentShoppingModel(
        title: "Số serial",
      );
      filterList.add(model);
      model = ContentShoppingModel(
        title: "Mã hàng",
      );
      filterList.add(model);
      model = ContentShoppingModel(
        title: "Tên hàng",
      );
      filterList.add(model);
    }
    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: filterList,
          screenTitle: "Lọc nâng cao",
          isCanClear: true,
          saveTitle: "Lọc",
        ));
    if (isNotNullOrEmpty(result)) {
      _managerSerialListRepository.params.serialNo = filterList[0].value;
      _managerSerialListRepository.params.nameCommodity = filterList[2].value;
      _managerSerialListRepository.params.codeCommodity = filterList[1].value;
      _managerSerialListRepository.refreshData();
    }
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/constracts/provider/provider_details/provider_detail_screen.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/choose_provider_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

import 'choose_provider_repository.dart';

class ChooseProviderScreen extends StatefulWidget {
  bool isBrowse;

  ChooseProviderScreen(this.isBrowse);

  @override
  _ChooseProviderScreenState createState() => _ChooseProviderScreenState();
}

class _ChooseProviderScreenState extends State<ChooseProviderScreen> {
  ChooseProviderRepository _chooseProviderRepository =
      ChooseProviderRepository();
  RefreshController _refreshController = RefreshController();
  List<ContentShoppingModel> filterList = [];

  @override
  void initState() {
    super.initState();
    _chooseProviderRepository.refreshController = _refreshController;
    _chooseProviderRepository.isBrowse = widget.isBrowse;
    _chooseProviderRepository.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isBrowse
            ? "Duyệt lựa chọn nhà cung cấp"
            : "Lựa chọn nhà cung cấp"),
      ),
      body: ChangeNotifierProvider.value(
        value: _chooseProviderRepository,
        child: Consumer(
          builder: (context, ChooseProviderRepository chooseProviderRepository,
              child) {
            return Column(
              children: [
                Visibility(
                  visible: widget.isBrowse,
                  child: Container(
                    color: getColor("#F1F1F1"),
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chevron_left_outlined,
                          size: 16,
                        ),
                        Expanded(
                            child: Text(
                          _chooseProviderRepository.checkedList.length
                              .toString(),
                          style: TextStyle(fontSize: 16),
                        )),
                        InkWell(
                          onTap: approve,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                                color: getColor("#66AB39"),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 4),
                                ),
                                Text(
                                  "Duyệt",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
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
                      onRefresh: _chooseProviderRepository.refreshData,
                      onLoading: _chooseProviderRepository.loadMore,
                      child: isNullOrEmpty(_chooseProviderRepository
                              ?.chooseProvider?.requisitions)
                          ? Center(
                              child: Text("Không có dữ liệu"),
                            )
                          : ListView.separated(
                              itemCount: _chooseProviderRepository
                                      ?.chooseProvider?.requisitions?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                Requisitions requisitions =
                                    _chooseProviderRepository
                                        ?.chooseProvider?.requisitions
                                        ?.elementAt(index);
                                return InkWell(
                                  onTap: () async {
                                    bool isSuccess = await pushPage(
                                        context,
                                        ProviderDetailScreen(
                                            widget.isBrowse, requisitions.iD));
                                    if (isSuccess == true) {
                                      _chooseProviderRepository.refreshData();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Row(
                                      children: [
                                        Visibility(
                                          visible: widget.isBrowse,
                                          child: InkWell(
                                            onTap: () {
                                              if (_chooseProviderRepository
                                                  .checkedList
                                                  .contains(requisitions))
                                                _chooseProviderRepository
                                                    .checkedList
                                                    .remove(requisitions);
                                              else {
                                                _chooseProviderRepository
                                                    .checkedList
                                                    .add(requisitions);
                                              }
                                              _chooseProviderRepository
                                                  .notifyListeners();
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 16,
                                                  top: 16,
                                                  bottom: 16),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                child: Checkbox(
                                                  value:
                                                      _chooseProviderRepository
                                                          .checkedList
                                                          .contains(
                                                              requisitions),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                "assets/images/icon_statistic.webp",
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
                                                      requisitions
                                                              ?.requisitionNumber ??
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
                                                        Text("Tên dự án: "),
                                                        Expanded(
                                                            child: Text(requisitions
                                                                    ?.project ??
                                                                ""))
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 4),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text("Trạng thái: "),
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal: 8,
                                                                  vertical: 4),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          100)),
                                                              color: getColor(
                                                                  requisitions
                                                                          ?.status
                                                                          ?.bgColor ??
                                                                      "")),
                                                          child: Text(
                                                            requisitions?.status
                                                                    ?.name ??
                                                                "",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        )
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
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const Divider(
                                thickness: 1,
                                height: 1,
                              ),
                            )),
                ),
                SortFilterBaseWidget(
                  onSortType: _chooseProviderRepository.sort,
                  onFilter: filter,
                  sortType: _chooseProviderRepository.sortType,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  approve() async {
    if (isNullOrEmpty(_chooseProviderRepository.checkedList)) {
      showErrorToast("Chưa có lựa chọn nào có thể duyệt");
      return;
    }
    showConfirmDialog(context, "Bạn có muốn duyệt những nhà cung cấp này",
        () async {
      if (await _chooseProviderRepository.approve(context))
        _chooseProviderRepository.refreshData();
    });
  }

  filter() async {
    if (isNullOrEmpty(filterList)) {
      ContentShoppingModel model = ContentShoppingModel(
        title: "Mã PR",
      );
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Trạng thái",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData:
              _chooseProviderRepository.chooseProvider.searchParam.status,
          getTitle: (status) => status.name);
      filterList.add(model);
    }
    List<ContentShoppingModel> result = await pushPage(
        context,
        ListWithArrowScreen(
          data: filterList,
          screenTitle: "Lọc nâng cao",
          isCanClear: true,
        ));

    if (isNotNullOrEmpty(result)) {
      _chooseProviderRepository.params.requisitionNumber = filterList[0].value;
      _chooseProviderRepository.params.status =
          filterList[1]?.selected?.elementAt(0)?.iD;
      _chooseProviderRepository.refreshData();
    }
  }
}

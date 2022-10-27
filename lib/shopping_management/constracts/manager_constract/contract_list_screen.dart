import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/list_with_arrow_screen.dart';
import 'package:workflow_manager/shopping_management/commons/right_arrow_icon.dart';
import 'package:workflow_manager/shopping_management/constracts/manager_constract/contract_list_repository.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/contract_list_response.dart';
import 'package:workflow_manager/shopping_management/view/sort_filter_base_widget.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

import 'contract_detail/contract_detail_screen.dart';

class ContractListScreen extends StatefulWidget {
  @override
  _ContractListScreenState createState() => _ContractListScreenState();
}

class _ContractListScreenState extends State<ContractListScreen> {
  RefreshController _refreshController = RefreshController();
  ContractListRepository _contractListRepository = ContractListRepository();
  List<ContentShoppingModel> filterList = [];

  @override
  void initState() {
    super.initState();
    _contractListRepository.refreshController = _refreshController;
    _contractListRepository.refreshData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý hợp đồng"),
      ),
      body: ChangeNotifierProvider.value(
        value: _contractListRepository,
        child: Consumer(
          builder:
              (context, ContractListRepository contractListRepository, child) {
            return Column(
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
                      onRefresh: _contractListRepository.refreshData,
                      onLoading: _contractListRepository.loadMore,
                      child: isNullOrEmpty(_contractListRepository
                              ?.contractListModel?.contracts)
                          ? Center(
                              child: Text("Không có dữ liệu"),
                            )
                          : ListView.separated(
                              itemCount: _contractListRepository
                                      ?.contractListModel?.contracts?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                Contracts contract = _contractListRepository
                                    ?.contractListModel?.contracts
                                    ?.elementAt(index);
                                return InkWell(
                                  onTap: () async {
                                    var result = await pushPage(context,
                                        ContractDetailScreen(contract.iD));
                                    if (result == true) {
                                      _contractListRepository.refreshData();
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                'assets/images/icon_manage_contract.webp',
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.fill,
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
                                                      contract?.project ?? "",
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
                                                        Text("Mã PO: "),
                                                        Expanded(
                                                            child: Text(contract
                                                                    ?.pONumber ??
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
                                                              color: getColor(contract
                                                                      ?.status
                                                                      ?.bgColor ??
                                                                  "")),
                                                          child: Text(
                                                            contract?.status
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
                  onSortType: _contractListRepository.sort,
                  onFilter: filter,
                  sortType: _contractListRepository.sortType,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  filter() async {
    if (isNullOrEmpty(filterList)) {
      ContentShoppingModel model;
      model = ContentShoppingModel(
          title: "Dự án",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData:
              _contractListRepository.contractListModel.searchParam.projects,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Chọn PR",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData: _contractListRepository
              .contractListModel.searchParam.requisitions,
          getTitle: (status) => status.name);
      filterList.add(model);
      model = ContentShoppingModel(
        title: "Chọn PO",
        isDropDown: true,
        isSingleChoice: true,
        dropDownData:
            _contractListRepository.contractListModel.searchParam.pONumbers,
        getTitle: (status) => status.name,
      );
      filterList.add(model);
      model = ContentShoppingModel(
          title: "Trạng thái",
          isDropDown: true,
          isSingleChoice: true,
          dropDownData:
              _contractListRepository.contractListModel.searchParam.status,
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
      _contractListRepository.params.iDProject =
          filterList[0].selected?.elementAt(0)?.iD;
      _contractListRepository.params.iDPR =
          filterList[1].selected?.elementAt(0)?.iD;
      _contractListRepository.params.iDPO =
          filterList[2].selected?.elementAt(0)?.iD;
      _contractListRepository.params.status =
          filterList[3].selected?.elementAt(0)?.iD;
      _contractListRepository.refreshData();
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/custom_listview_loading_refresh_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/top_contract_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/row_icon_text_widget.dart';

import '../../../../../main.dart';
import 'list_contract_repository.dart';

// hợp đồng - danh sách Hợp đồng
class ListContractScreen extends StatefulWidget {
  int statusTab = 0;

  static const int TAB_LIST_CONTRACT = 50;

  ListContractScreen(this.statusTab); // danh sách Hợp đồng
  @override
  _ListContractScreenState createState() => _ListContractScreenState();
}

class _ListContractScreenState extends State<ListContractScreen> {
  var _repository = ListContractRepository();
  bool isCheckSort = false;
  OverViewRequest request = OverViewRequest();
  StreamSubscription _dataRequestFilter;

  String root;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getContractListAll();

    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    _dataRequestFilter =
        eventBus.on<GetRequestFilterToTabEventBus>().listen((event) {
      if (event.numberTabFilter == ListContractScreen.TAB_LIST_CONTRACT) {
        setState(() {
          request = event.request;
          _getContractListAll();
        });
      }
    });
  }

  _getContractListAll() async {
    root = await SharedPreferencesClass.getRoot();
    request.pageIndex = 1;
    await _repository.getContractListAll(widget.statusTab, request);
  }

  @override
  void dispose() {
    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, ListContractRepository _repository1, child) {
          return Scaffold(
            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        '${_repository.contractInfos?.length ?? 0} hợp đồng',
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _eventClickSortName();
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        padding: EdgeInsets.all(8),
                        child: Row(
                          children: [
                            const Text(
                              'Tên ',
                              style: TextStyle(fontSize: 14),
                            ),
                            Icon(
                              isCheckSort
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: Colors.grey,
                              size: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: isNullOrEmpty(_repository.contractInfos)
                        ? EmptyScreen()
                        : CustomListViewWidget(
                            onLoading: _onLoading,
                            onRefresh: _onRefresh,
                            lengthList: _repository.contractInfos?.length,
                            textEmpty: 'Không có dữ liệu',
                            listViewWidget: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _repository.contractInfos?.length ?? 0,
                              itemBuilder: (context, index) {
                                ContractInfos item =
                                    _repository.contractInfos[index];
                                item.sellerAvatar = '$root${item.sellerAvatar}';
                                return ItemListContract(item, index + 1);
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                            ),
                          ))
              ],
            ),
          );
        },
      ),
    );
  }

  _eventClickSortName() {
    setState(() {
      isCheckSort = !isCheckSort;
      if (isCheckSort)
        _repository.contractInfos.sort((a, b) => a.name.compareTo(b.name));
      else
        _repository.contractInfos.sort((a, b) => b.name.compareTo(a.name));
    });
  }

  void _onLoading() async {
    await _repository.getContractListAll(widget.statusTab, request);
  }

  void _onRefresh() async {
    request = OverViewRequest();
    _getContractListAll();
  }
}

class ItemListContract extends StatelessWidget {
  ContractInfos item;
  int index;

  ItemListContract(this.item, this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item?.name,
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold)),
          RowAndTextWidget(
            icon: Icons.import_contacts_rounded,
            text: '  Loại hợp đồng: ${item?.projectType}',
          ),
          RowAndTextWidget(
            icon: Icons.timer,
            text:
                '  Ngày ký: ${convertTimeStampToHumanDate(item?.signDate, Constant.ddMMyyyy2)}',
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Row(
              children: [
                Icon(
                  Icons.person_pin,
                  color: Colors.grey,
                  size: 15,
                ),
                Text(
                  '  Seller: ',
                  style: TextStyle(color: Colors.black),
                ),
                CircleNetworkImage(
                  url: item?.sellerAvatar,
                  height: 20,
                  width: 20,
                ),
                Text(
                  ' ${item?.sellerName}',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
import 'top_contract_repository.dart';

// hợp đồng - top Hợp đồng
class TopContractScreen extends StatefulWidget {
  int statusTab = 0;

  static const int TAB_TOP_CONTRACT = 40;

  TopContractScreen(this.statusTab); // top Hợp đồng

  @override
  _TopContractScreenState createState() => _TopContractScreenState();
}

class _TopContractScreenState extends State<TopContractScreen> {
  var _repository = TopContractRepository();
  OverViewRequest request = OverViewRequest();
  StreamSubscription _dataRequestFilter;

  String root;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getTopContract();

    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    _dataRequestFilter =
        eventBus.on<GetRequestFilterToTabEventBus>().listen((event) {
      if (event.numberTabFilter == TopContractScreen.TAB_TOP_CONTRACT) {
        setState(() {
          request = event.request;
          _getTopContract();
        });
      }
    });
  }

  _getTopContract() async {
    root = await SharedPreferencesClass.getRoot();
    await _repository.getTopContract(widget.statusTab, request);
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
        builder: (context, TopContractRepository _repository1, child) {
          return Scaffold(
            body: Column(
              children: [
                Image.asset(
                  'assets/images/tong_quan_doanh_thu.webp',
                  height: 150,
                  fit: BoxFit.fill,
                ),
                Expanded(
                    child: isNullOrEmpty(
                            _repository.dataTopContract?.contractInfos)
                        ? EmptyScreen()
                        : CustomListViewWidget(
                            onRefresh: _onRefresh,
                            lengthList: _repository
                                .dataTopContract?.contractInfos?.length,
                            textEmpty: 'Không có dữ liệu hiển thị',
                            listViewWidget: ListView.separated(
                              shrinkWrap: true,
                              itemCount: _repository
                                      .dataTopContract?.contractInfos?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                ContractInfos item = _repository
                                    .dataTopContract?.contractInfos[index];
                                item.sellerAvatar = '$root${item.sellerAvatar}';
                                print(item?.sellerAvatar);
                                return ItemTopContract(item, index + 1);
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

  void _onRefresh() async {
    request = OverViewRequest();
    _getTopContract();
  }
}

class ItemTopContract extends StatelessWidget {
  ContractInfos item;
  int index;

  ItemTopContract(this.item, this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 38,
            width: 38,
            alignment: Alignment.center,
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
                color: index == 1
                    ? Colors.orange
                    : index == 2
                        ? Colors.green[800]
                        : index == 3
                            ? Colors.amberAccent
                            : Colors.white ?? Colors.white,
                borderRadius: BorderRadius.circular(50)),
            child: Text(
              '$index',
              style: TextStyle(
                  color: index == 1 || index == 2 || index == 3
                      ? Colors.white
                      : Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
                RowAndTextWidget(
                  icon: Icons.import_contacts_rounded,
                  text: '  Loại hợp đồng: ${item.projectType}',
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
                        ' ${item.sellerName}',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/custom_listview_loading_refresh_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/statistic_seller_response.dart';

import '../statistic_seller_repository.dart';
import 'item_top_seller.dart';

class ListSellerScreen extends StatefulWidget {
  String year;

  ListSellerScreen({this.year});

  @override
  _ListSellerScreenState createState() => _ListSellerScreenState();
}

class _ListSellerScreenState extends State<ListSellerScreen> {
  var _repository = StatisticSellerRepository();
  OverViewRequest request = OverViewRequest();
  List<SellerInfos> listSeller;
  String root;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTopSeller();
  }

  _getTopSeller() async {
    root = await SharedPreferencesClass.getRoot();
    request.year = widget.year;
    request.pageIndex = 1;
    await _repository.getTopSeller(request);
    listSeller = _repository.listSeller;
  }

  void _onLoading() async {
    await _repository.getTopSeller(request);
    request.pageIndex++;
  }

  void _onRefresh() async {
    request = OverViewRequest();
    _getTopSeller();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, StatisticSellerRepository _repository1, child) {
          return isNullOrEmpty(listSeller)
              ? EmptyScreen()
              : CustomListViewWidget(
                  onLoading: _onLoading,
                  onRefresh: _onRefresh,
                  lengthList: listSeller?.length,
                  textEmpty: 'Không có dữ liệu',
                  listViewWidget: ListView.separated(
                    shrinkWrap: true,
                    itemCount: listSeller?.length ?? 0,
                    itemBuilder: (context, index) {
                      SellerInfos item = listSeller[index];
                      item?.sellerAvatar =
                          '$root${item?.sellerAvatar.replaceAll('$root', '')}';
                      return ItemTopSeller(item, null);
                    },
                    separatorBuilder: (context, index) {
                      return Divider();
                    },
                  ),
                );
        },
      ),
    );
  }
}

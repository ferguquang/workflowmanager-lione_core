import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/custom_listview_loading_refresh_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/response/history_opportunity_response.dart';

import 'history_opportunity_reponse.dart';

// class này dùng chung cho lịch sử cơ hội và hợp đồng
class HistoryOpportunityScreen extends StatefulWidget {
  int idOpportunity;
  bool isOpportunityAndContract; // cơ hội: true, hợp đồng false

  @override
  _HistoryOpportunityScreenState createState() =>
      _HistoryOpportunityScreenState();

  HistoryOpportunityScreen(this.idOpportunity, this.isOpportunityAndContract);
}

class _HistoryOpportunityScreenState extends State<HistoryOpportunityScreen> {
  HistoryOpportunityRepository _repository = HistoryOpportunityRepository();

  String root;
  int sort = 1;
  List<Histories> listHistories = [];

  @override
  void initState() {
    super.initState();
    _getDetailHistories(); // mặc định là 1
  }

  _getDetailHistories() async {
    if (root == null) root = await SharedPreferencesClass.getRoot();
    await _repository.getDetailHistories(
        widget.idOpportunity, sort, widget.isOpportunityAndContract);
    listHistories = _repository.listHistories;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, HistoryOpportunityRepository __repository1, child) {
          return Scaffold(
            body: SafeArea(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 32, right: 16, bottom: 16),
                      child: InkWell(
                        onTap: () {
                          if (sort == 1)
                            sort = 2;
                          else
                            sort = 1;
                          _getDetailHistories();
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.grey,
                                size: 16,
                              ),
                              Text(
                                '  Sắp xếp: ',
                              ),
                              Text(
                                sort == 1 ? 'Theo thời gian' : 'Theo giai đoạn',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: CustomListViewWidget(
                      lengthList: listHistories.length,
                      onLoading: this._onLoading,
                      onRefresh: this._onRefresh,
                      listViewWidget: listHistories?.length == 0
                          ? EmptyScreen()
                          : ListView.separated(
                              // physics: NeverScrollableScrollPhysics(),
                              // shrinkWrap: true,
                              itemCount: listHistories?.length ?? 0,
                              itemBuilder: (context, index) {
                                Histories item = listHistories[index];
                                return _itemHistories(item);
                              },
                              separatorBuilder: (context, index) {
                                return Divider();
                              },
                            ),
                    )),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _itemHistories(Histories item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleNetworkImage(
                height: 32,
                width: 32,
                url: '$root${item?.seller?.avatar}' ?? ''),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item?.seller?.name ?? '',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Html(
                  style: {"body": Style(textAlign: TextAlign.start)},
                  data: item?.body ?? "",
                ),
                Text(
                  '${convertTimeStampToHumanDate(item?.created, Constant.ddMMyyyyHHmm2)}' ??
                      '',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onLoading() async {
    _getDetailHistories();
  }

  void _onRefresh() async {
    _repository.pageIndex = 1;
    _getDetailHistories();
  }
}

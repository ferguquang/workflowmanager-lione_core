import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/statistic_seller/statistic_seller_repository.dart';
import 'package:workflow_manager/businessManagement/widgets/item_tab_bar_view.dart';

import 'list_seller/list_seller_screen.dart';

class StatisticSellerScreen extends StatefulWidget {
  @override
  _StatisticSellerScreenState createState() => _StatisticSellerScreenState();
}

class _StatisticSellerScreenState extends State<StatisticSellerScreen>
    with SingleTickerProviderStateMixin {
  var _repository = StatisticSellerRepository();
  TabController _tabController;
  List<Tab> myTabs = [];
  OverViewRequest request = OverViewRequest();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    request.year = getCurrentDate(Constant.yyyy);
    _getTopSeller();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _getTopSeller() async {
    request.pageIndex = 1;
    await _repository.getTopSeller(request);
    int indexTab = 0;
    if (isNotNullOrEmpty(_repository.years)) {
      for (int i = 0; i < _repository.years.length; i++) {
        myTabs.add(ItemTabBarView(_repository.years[i].toString()));
        if (_repository.years[i].toString() == request.year) indexTab = i;
      }
    }
    _tabController = new TabController(vsync: this, length: myTabs.length);
    _tabController.animateTo(indexTab);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, StatisticSellerRepository _repository1, child) {
          return DefaultTabController(
            length: myTabs.length,
            child: (isNullOrEmpty(myTabs))
                ? EmptyScreen()
                : Scaffold(
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(kToolbarHeight * 3.6),
                      child: Container(
                        color: Colors.white,
                        child: SafeArea(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/top_sellre.webp',
                                height: 150,
                                fit: BoxFit.fill,
                              ),
                              TabBar(
                                controller: _tabController,
                                isScrollable: true,
                                indicatorColor: Colors.blue,
                                labelColor: Colors.blue,
                                unselectedLabelColor: Colors.grey,
                                tabs: myTabs,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    body: TabBarView(
                      controller: _tabController,
                      children: getTabView(),
                    ),
                  ),
          );
        },
      ),
    );
  }

  // lấy tab năm từ api
  List<Widget> getTabView() {
    List<Widget> list = isNullOrEmpty(_repository.years)
        ? <Widget>[]
        : _repository.years.map((content) {
            return ListSellerScreen(year: content.toString());
          }).toList();
    return list;
  }
}

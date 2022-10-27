import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/gradient_text.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/overview/by_plan/overview_plan_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/overview/overview_repository.dart';
import 'package:workflow_manager/businessManagement/widgets/item_tab_bar_view.dart';

import '../../../../../main.dart';

//Doan thu - Tổng quan
class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen>
    with SingleTickerProviderStateMixin {
  // height image
  double height = 0;

  // color text
  final Shader linearGradient = LinearGradient(
    colors: <Color>[Color(0xffDA44bb), Color(0xff8921aa)],
  ).createShader(Rect.fromLTWH(10.0, 10.0, 50.0, 70.0));

  TabController _tabController;
  List<Tab> myTabs;
  OverViewRepository _repository = OverViewRepository();

  ScrollController _scrollController;
  OverViewRequest request = OverViewRequest();
  StreamSubscription _dataRequestFilter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myTabs = <Tab>[
      ItemTabBarView('Theo kế hoạch'),
      ItemTabBarView('Theo quý'),
      ItemTabBarView('Theo chi nhánh'),
      ItemTabBarView('Theo phòng ban'),
      ItemTabBarView('Theo nguồn khách hàng'),
      ItemTabBarView('Theo chiến dịch marketing'),
    ];
    _tabController = new TabController(vsync: this, length: myTabs.length);
    _scrollController = ScrollController();

    _getProjecTreportIndex();

    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    _dataRequestFilter =
        eventBus.on<GetRequestFilterToTabEventBus>().listen((event) {
      switch (event.numberTabFilter) {
        case OverviewPlanScreen.TAB_PLAN:
          request = event.request;
          _getProjecTreportIndex();
          break;
      }
    });
  }

  _getProjecTreportIndex() async {
    await _repository.getProjecTreportIndex(
        OverviewPlanScreen.TAB_PLAN, request);
    // String path = ;
    // String localPath = await FileUtils.instance.downloadFileAndOpen(
    //     path.substring(path.lastIndexOf("/"), path.length), path, context,
    //     isOpenFile: false);
    Image image = Image.network(_repository.dataOverView?.urlSaleTarget);
    image.image.resolve(new ImageConfiguration()).addListener(
        ImageStreamListener((ImageInfo info, bool synchronousCall) {
      if (info != null)
        setState(() {
          height = MediaQuery.of(context).size.width *
              info.image.height /
              info.image.width;
        });
    }));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, OverViewRepository _repository1, child) {
          return Scaffold(
            body: NestedScrollView(
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    toolbarHeight: _repository.dataOverView == null ||
                            _repository.dataOverView?.urlSaleTarget == null
                        ? 0
                        : height,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(bottom: 50),
                        child: _repository.dataOverView == null ||
                                _repository.dataOverView?.urlSaleTarget == null
                            ? Container()
                            : CachedNetworkImage(
                                imageUrl:
                                    _repository.dataOverView?.urlSaleTarget ??
                                        '',
                                imageBuilder: (context, imageProvider) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      // shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.fill),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    title: Container(
                      height: height,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(),
                            flex: 2,
                          ),
                          Text(
                              'KẾ HOẠCH DOANH SỐ ${getCurrentDate(Constant.yyyy)}',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.red)),
                          Expanded(
                            child: Container(),
                            flex: 1,
                          ),
                          GradientText(
                            '${_repository.dataOverView?.businessTargetMoney ?? 0} Tỷ' ??
                                '0 Tỷ',
                            gradient: LinearGradient(colors: [
                              Colors.red,
                              Colors.orange,
                            ]),
                          ),
                          Expanded(
                            child: Container(),
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                    pinned: true,
                    floating: true,
                    forceElevated: innerBoxIsScrolled,
                    bottom: TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      tabs: myTabs,
                    ),
                  ),
                ];
              },
              body: DefaultTabController(
                length: myTabs.length,
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          OverviewPlanScreen(
                            statusTab: OverviewPlanScreen.TAB_PLAN,
                            dataOverView: _repository.dataOverView,
                          ),
                          OverviewPlanScreen(
                            statusTab: OverviewPlanScreen.TAB_QUATER,
                            dataOverView: _repository.dataOverView,
                          ),
                          OverviewPlanScreen(
                            statusTab: OverviewPlanScreen.TAB_BRANCH,
                            dataOverView: _repository.dataOverView,
                          ),
                          OverviewPlanScreen(
                            statusTab: OverviewPlanScreen.TAB_DEPT,
                            dataOverView: _repository.dataOverView,
                          ),
                          OverviewPlanScreen(
                            statusTab: OverviewPlanScreen.TAB_CUSTOM,
                            dataOverView: _repository.dataOverView,
                          ),
                          OverviewPlanScreen(
                            statusTab: OverviewPlanScreen.TAB_MARKETING,
                            dataOverView: _repository.dataOverView,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

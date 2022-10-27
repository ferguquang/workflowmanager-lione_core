import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/expected_plan_response.dart';

import '../../../../../main.dart';
import 'expected_plan_repository.dart';

// doanh thu dự kiến - theo kế hoạch
class ExpectedPlanScreen extends StatefulWidget {
  int statusTab = 0;

  static const int TAB_EXPECTED_PLAN = 73;

  ExpectedPlanScreen(this.statusTab); // theo kế hoạch

  @override
  _ExpectedPlanScreenState createState() => _ExpectedPlanScreenState();
}

class _ExpectedPlanScreenState extends State<ExpectedPlanScreen> {
  var _repository = ExpectedPlanRepository();
  OverViewRequest request = OverViewRequest();
  StreamSubscription _dataRequestFilter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getExpectedPlan();

    if (isNotNullOrEmpty(_dataRequestFilter)) _dataRequestFilter.cancel();
    _dataRequestFilter =
        eventBus.on<GetRequestFilterToTabEventBus>().listen((event) {
      if (event.numberTabFilter == ExpectedPlanScreen.TAB_EXPECTED_PLAN) {
        setState(() {
          request = event.request;
          _getExpectedPlan();
        });
      }
    });
  }

  _getExpectedPlan() {
    _repository.getExpectedPlan(ExpectedPlanScreen.TAB_EXPECTED_PLAN, request);
    setState(() {});
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
        builder: (context, ExpectedPlanRepository _repository1, child) {
          return Scaffold(
            body: isNullOrEmpty(_repository.dataExpectedPlan?.projectPlans)
                ? EmptyScreen()
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount:
                        _repository.dataExpectedPlan?.projectPlans?.length ?? 0,
                    itemBuilder: (context, index) {
                      ExpectedProjectPlans item =
                          _repository.dataExpectedPlan?.projectPlans[index];
                      return ItemExpectedPlan(item);
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

class ItemExpectedPlan extends StatelessWidget {
  ExpectedProjectPlans item;

  ItemExpectedPlan(this.item);

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
          _rowIconAndText(Icons.access_time_rounded,
              ' Ngày ký hợp đồng dự kiến: ${convertTimeStampToHumanDate(item?.startDate, Constant.ddMMyyyy)}'),
          _rowIconAndText(Icons.timer, ' Giá trị (VND): ${item?.totalMoney}'),
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
                  url: '${_getRoot()}',
                  height: 20,
                  width: 20,
                ),
                Text(
                  ' ${item?.seller?.name ?? ''}',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowIconAndText(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.grey,
            size: 15,
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Future<String> _getRoot() async {
    String root = await SharedPreferencesClass.getRoot();
    return root + item?.seller?.avatar;
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/filter/list_select_screen.dart';
import 'package:workflow_manager/procedures/widgets/select_value_widget.dart';
import 'package:workflow_manager/shopping_management/request/report_shopping_dash_board_request.dart';
import 'package:workflow_manager/shopping_management/response/shopping_dashboard_response.dart';

class FilterShoppingScreen extends StatefulWidget {

  void Function(ReportShoppingDashBoardRequest) onDoneFilter;

  ReportShoppingDashBoardData reportShoppingDashBoardData;

  ReportShoppingDashBoardRequest originalRequest;

  FilterShoppingScreen(this.reportShoppingDashBoardData, this.originalRequest, {this.onDoneFilter});

  @override
  State<StatefulWidget> createState() {
    return _FilterShoppingState();
  }
}

class _FilterShoppingState extends State<FilterShoppingScreen> {
  ReportShoppingDashBoardRequest filterRequest =
      ReportShoppingDashBoardRequest();

  @override
  void initState() {
    super.initState();
    if (this.widget.originalRequest != null) {
      filterRequest = ReportShoppingDashBoardRequest.fromJson(
          this.widget.originalRequest.toJson());

      // DateTime now = new DateTime.now();
      // filterRequest.year.iD = now.year;
      // filterRequest.year.name = "${now.year}";
      // filterRequest.quarter = getQuarter(now);
    }
  }

  Quarters getQuarter(DateTime now) {
    Quarters quarters = Quarters();
    if (now.month == 1 || now.month == 2 || now.month == 3) {
      quarters.iD = 1;
      quarters.name = "Quý 1";
      return quarters;
    } else if (now.month == 4 || now.month == 5 || now.month == 6) {
      quarters.iD = 2;
      quarters.name = "Quý 2";
      return quarters;
    } else if (now.month == 7 || now.month == 8 || now.month == 9) {
      quarters.iD = 3;
      quarters.name = "Quý 3";
      return quarters;
    } else if (now.month == 10 || now.month == 11 || now.month == 12) {
      quarters.iD = 4;
      quarters.name = "Quý 4";
      return quarters;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lọc"),
        leading: GestureDetector(
          onTap: () {
            /* Write listener code here */
          },
          child: BackIconButton(),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Xoá",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              this.setState(() {
                this.filterRequest = ReportShoppingDashBoardRequest();
              });
              this.widget.originalRequest = ReportShoppingDashBoardRequest();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: SingleChildScrollView(child: _filterWidget())),
            Padding(
              padding: EdgeInsets.all(16),
              child: SaveButton(
                title: "Áp dụng".toUpperCase(),
                onTap: () {
                  this.widget.onDoneFilter(filterRequest);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterWidget() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: SelectValueWidget(
            "Chọn phòng ban",
            value: filterRequest.dept?.name ?? "",
            onPressed: () {
              pushPage(
                  context,
                  ListSelectScreen(
                    title: "Phòng ban",
                    arraySelectModel:
                        widget.reportShoppingDashBoardData.searchParam.dept,
                    currentSelect: filterRequest.dept,
                    isShowSearchWidget: true,
                    onSelected: (modelSelected) {
                      setState(() {
                        filterRequest.dept = modelSelected;
                      });
                    },
                  ));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: SelectValueWidget(
            "Chọn năm",
            value: filterRequest.year?.name ?? "",
            onPressed: () {
              pushPage(
                  context,
                  ListSelectScreen(
                    title: "Chọn năm",
                    arraySelectModel:
                        widget.reportShoppingDashBoardData.searchParam.years,
                    currentSelect: filterRequest.year,
                    isShowSearchWidget: true,
                    onSelected: (modelSelected) {
                      setState(() {
                        filterRequest.year = modelSelected;
                      });
                    },
                  ));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: SelectValueWidget(
            "Chọn quý",
            value: filterRequest.quarter?.name ?? "",
            onPressed: () {
              pushPage(
                  context,
                  ListSelectScreen(
                    title: "Chọn quý",
                    arraySelectModel:
                        widget.reportShoppingDashBoardData.searchParam.quarters,
                    currentSelect: filterRequest.quarter,
                    isShowSearchWidget: true,
                    onSelected: (modelSelected) {
                      setState(() {
                        filterRequest.quarter = modelSelected;
                      });
                    },
                  ));
            },
          ),
        )
      ],
    );
  }
}

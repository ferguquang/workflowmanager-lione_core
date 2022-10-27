import 'dart:async';

import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/over_view_request.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/expected_revenue/expected_plan/expected_plan_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/expected_revenue/expected_year/expected_year_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/by_time/revenue_time_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/overview/by_plan/overview_plan_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/phased/revenue_phased_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/revenue/statistics_detail/statistic_according_dept/statistic_according_dept_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/statistic_bonus/bonus_by_dept/bonus_by_dept_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/statistic_bonus/bonus_top_personal/bonus_top_personal_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/statistics_contract/list_contract/list_contract_screen.dart';
import 'package:workflow_manager/businessManagement/screen/statistics/statistics_contract/top_contract/top_contract_screen.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

import '../../../../main.dart';
import 'bottom_sheet_quarter.dart';
import 'filter_category/filter_category_screen.dart';
import 'filter_month/filter_month_screen.dart';
import 'filter_seller/filter_seller_screen.dart';

class FilterStatisticScreen extends StatefulWidget {
  GetListDataFilterStatisticEventBus dataFilter;

  FilterStatisticScreen(this.dataFilter);

  @override
  _FilterStatisticScreenState createState() => _FilterStatisticScreenState();
}

class _FilterStatisticScreenState extends State<FilterStatisticScreen> {
  double _aspectRatio = 4.0, _crossAxisSpacing = 5.2, _mainAxisSpacing = 10.2;

  bool isShowDept = false;
  bool isShowSeller = false;
  bool isShowYear = false;
  bool isShowStartDate = false;
  bool isShowEndDate = false;
  bool isShowTypeReport = false;
  bool isShowMonth = false;
  bool isShowQuarter = false;

  OverViewRequest request = OverViewRequest();

  var startDateController = TextEditingController();
  var endDateController = TextEditingController();
  var deptController = TextEditingController();
  var yearController = TextEditingController();
  var typeReportController = TextEditingController();
  var sellerController = TextEditingController();

  int numberTabFilter;
  SearchParam searchParam;

  List<Categories> listCheckDept = [];
  List<Seller> listCheckSeller = [];
  List<DateTypes> listYear = [];
  List<DateTypes> listCheckYear = [];
  List<DateTypes> listCheckMonth = [];
  List<DateTypes> listCheckQuarter = [];
  List<DateTypes> listCheckDateTypes = [];
  GetListDataFilterStatisticEventBus data;

  bool isSingleYear = false; // false chọn nhiều, true chọn 1
  String titleDept = 'Chọn phòng ban';

  StreamSubscription _dataSearchParams;

  @override
  void initState() {
    super.initState();

    _dataSearchParams =
        eventBus.on<GetListDataFilterStatisticEventBus>().listen((event) {
      setState(() {
        // if (event.numberTabFilter != null) {
        // print('EVENTBUS_SEARCH_STATISTIC_QLKD');
        this.numberTabFilter = event.numberTabFilter;
        this.searchParam = event.searchParam;
        _showWidgetForTab();
        // }
      });
    });

    this.numberTabFilter = widget.dataFilter?.numberTabFilter ?? 0;
    this.searchParam = widget.dataFilter?.searchParam;

    _showWidgetForTab();
  }

  @override
  void dispose() {
    super.dispose();
    if (isNotNullOrEmpty(_dataSearchParams)) _dataSearchParams.cancel();
  }

  _showWidgetForTab() {
    switch (this.numberTabFilter) {
      //doanh thu - Tổng quan - theo kế hoạch, quý, chi nhánh, theo phòng ban, theo nguồn khách hàng, theo chiến dịch marketing
      case OverviewPlanScreen.TAB_PLAN:
      case OverviewPlanScreen.TAB_QUATER:
      case OverviewPlanScreen.TAB_BRANCH:
      case OverviewPlanScreen.TAB_DEPT:
      case OverviewPlanScreen.TAB_CUSTOM:
      case OverviewPlanScreen.TAB_MARKETING:
        _checkShowWidget(
            isShowSeller: true, isShowYear: true, isShowTypeReport: true);
        isSingleYear = true;
        break;

      //doanh thu - thống kê chi tiết - theo phòng ban
      case StatisticAccordingDeptScreen.TAB_DEPT:
        _checkShowWidget(
            isShowDept: true, isShowYear: true, isShowTypeReport: true);
        break;

      //doanh thu - thống kê chi tiết - theo seller
      case StatisticAccordingDeptScreen.TAB_SELLER:
        _checkShowWidget(
            isShowSeller: true, isShowYear: true, isShowTypeReport: true);
        break;

      //doanh thu - thống kê chi tiết - theo tình thành (vùng)
      case StatisticAccordingDeptScreen.TAB_AREA:
        _checkShowWidget(
            isShowDept: true, isShowYear: true, isShowTypeReport: true);
        titleDept = 'Chọn tỉnh/thành phố';
        break;

      //doanh thu - thống kê chi tiết - theo khách hàng
      case StatisticAccordingDeptScreen.TAB_CUSTOM:
        _checkShowWidget(
            isShowDept: true, isShowYear: true, isShowTypeReport: true);
        titleDept = 'Chọn khách hàng';
        break;

      //doanh thu - theo thời gian
      case RevenueTimeScreen.TAB_BY_TIME:
        _checkShowWidget(
            isShowSeller: true, isShowYear: true, isShowTypeReport: true);
        break;

      //doanh thu - theo giai đoạn
      case RevenuePhasedScreen.TAB_REVENUE_PHASED:
        _checkShowWidget(isShowSeller: true, isShowYear: true);
        isSingleYear = true;
        break;

      // hợp đồng - top Hợp đồng
      case TopContractScreen.TAB_TOP_CONTRACT:
      // hợp đồng - danh sách Hợp đồng
      case ListContractScreen.TAB_LIST_CONTRACT:
        _checkShowWidget(
            isShowSeller: true, isShowYear: true, isShowTypeReport: true);
        isSingleYear = true;
        break;

      // thưởng - theo phòng ban
      case BonusByDeptScreen.TAB_BONUS_DEPT:
      // thưởng - theo chi nhánh
      case BonusByDeptScreen.TAB_BONUS_BRANCH:
        _checkShowWidget(isShowYear: true, isShowQuarter: true);
        isSingleYear = true;
        break;

      // thưởng - top thưởng cá nhân
      case BonusTopPersonalScreen.TAB_BONUS_TOP_PERSONAL:
        _checkShowWidget(
            isShowSeller: true, isShowYear: true, isShowQuarter: true);
        isSingleYear = true;
        break;

      // // doanh thu dự kiến - các năm gần đây
      case ExpectedYearScreen.TAB_EXPECTED_REVENUE:
        _checkShowWidget(isShowSeller: true);
        isSingleYear = null;
        break;
      // // doanh thu dự kiến - theo quý
      case ExpectedYearScreen.TAB_EXPECTED_QUARTER:
      // // doanh thu dự kiến - theo tháng
      case ExpectedYearScreen.TAB_EXPECTED_MONTH:
        _checkShowWidget(isShowSeller: true, isShowYear: true);
        break;

      // doanh thu dự kiến - theo kế hoạch
      case ExpectedPlanScreen.TAB_EXPECTED_PLAN:
        _checkShowWidget(
            isShowSeller: true, isShowStartDate: true, isShowEndDate: true);
        isSingleYear = null;
        break;
    }

    if (isNotNullOrEmpty(searchParam)) {
      // phòng ban
      if (isNotNullOrEmpty(searchParam?.categories)) {
        searchParam?.categories?.forEach((element) {
          if (element.isSelected) listCheckDept?.add(element);
        });
        stringTextDept();
      }
      //seller
      if (isNotNullOrEmpty(searchParam?.seller)) {
        searchParam?.seller?.forEach((element) {
          if (element.isSelected) listCheckSeller?.add(element);
        });
        stringTextSeller();
      }
      // năm
      if (searchParam.listYear.length > 0) {
        listYear = searchParam?.listYear;
        listYear.forEach((element) {
          if (element.isSelected) listCheckYear?.add(element);
        });
      } else {
        // tạo list year mới
        if (isNotNullOrEmpty(this.searchParam) &&
            isNotNullOrEmpty(this.searchParam?.years)) {
          listYear.clear();
          this.searchParam.years.forEach((element) {
            listYear.add(new DateTypes(
                text: element.toString(), value: element, isSelected: false));
          });
        }

        // check true cho listYear
        if (isSingleYear != null) {
          listCheckYear.clear();
          if (isSingleYear) {
            yearController.text = getCurrentDate(Constant.yyyy);
            listCheckYear = listYear
                .where((element) =>
                    element.value == int.parse(yearController.text))
                .toList();
          } else {
            int iYear = int.parse(getCurrentDate(Constant.yyyy));
            listYear.forEach((element) {
              if (element.value == iYear || element.value == (iYear - 1))
                listCheckYear.add(element);
            });
            String year = listCheckYear.map((e) => e.text).toList().toString();
            year = year.replaceAll('[', '').replaceAll(']', '');
            yearController.text = year;
          }
        }
      }
      stringTextYears();
      // tháng
      if (isNotNullOrEmpty(searchParam?.months)) {
        searchParam?.months?.forEach((element) {
          if (element.isSelected) listCheckMonth?.add(element);
        });
      }
      // quý
      if (isNotNullOrEmpty(searchParam?.quarters)) {
        searchParam?.quarters?.forEach((element) {
          if (element.isSelected) listCheckQuarter?.add(element);
        });
      }
      // loại báo cáo
      if (isNotNullOrEmpty(searchParam?.dateTypes)) {
        searchParam?.dateTypes?.forEach((element) {
          if (element.isSelected) {
            listCheckDateTypes?.add(element);
            stringTextTypeData();
          }
        });
      }
      // ngày bắt đầu
      if (isNotNullOrEmpty(startDateController.text)) {
        searchParam?.startDate = startDateController.text;
      }
      // ngày kết thúc
      if (isNotNullOrEmpty(endDateController.text)) {
        searchParam?.endDate = endDateController.text;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bộ lọc'.toUpperCase()),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Xoá",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              // print('refresh');
              setState(() {
                _eventClickRefresh();
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child: _showFilterStatisticWidget(),
      ),
    );
  }

  Widget _showFilterStatisticWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: isShowDept,
                    child: TagLayoutWidget(
                      horizontalPadding: 0,
                      title: titleDept,
                      value: deptController.text,
                      openFilterListener: () {
                        if (isNotNullOrEmpty(this.searchParam))
                          _eventCallBackDept();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  Visibility(
                    visible: isShowSeller,
                    child: TagLayoutWidget(
                      horizontalPadding: 0,
                      title: "Chọn seller",
                      value: sellerController.text,
                      openFilterListener: () {
                        if (isNotNullOrEmpty(this.searchParam))
                          _eventCallBackSeller();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  Visibility(
                    visible: isShowYear,
                    child: TagLayoutWidget(
                      horizontalPadding: 0,
                      title: "Chọn năm",
                      value: yearController.text,
                      openFilterListener: () {
                        if (isNotNullOrEmpty(this.searchParam))
                          _eventCallBackYear();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  Visibility(
                    visible: isShowStartDate,
                    child: TagLayoutWidget(
                      horizontalPadding: 0,
                      title: "Chọn ngày bắt đầu",
                      value: startDateController.text,
                      icon: Icons.date_range,
                      openFilterListener: () {
                        if (isNotNullOrEmpty(this.searchParam))
                          DateTimePickerWidget(
                              format: Constant.ddMMyyyy2,
                              context: context,
                              onDateTimeSelected: (valueDate) {
                                setState(() {
                                  startDateController.text = valueDate;
                                });
                              }).showOnlyDatePicker();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  Visibility(
                    visible: isShowEndDate,
                    child: TagLayoutWidget(
                      horizontalPadding: 0,
                      title: "Chọn ngày kết thúc",
                      value: endDateController.text,
                      icon: Icons.date_range,
                      openFilterListener: () {
                        if (isNotNullOrEmpty(this.searchParam))
                          DateTimePickerWidget(
                              format: Constant.ddMMyyyy2,
                              context: context,
                              onDateTimeSelected: (valueDate) {
                                setState(() {
                                  endDateController.text = valueDate;
                                });
                              }).showOnlyDatePicker();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  Visibility(
                    visible: isShowTypeReport,
                    child: TagLayoutWidget(
                      horizontalPadding: 0,
                      title: "Loại báo cáo",
                      value: typeReportController.text,
                      openFilterListener: () {
                        if (isNotNullOrEmpty(this.searchParam))
                          _eventCallBackTypeReport();
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  Visibility(
                    visible: isShowMonth,
                    child: Column(
                      children: [
                        InkWell(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Chọn tháng',
                              style: TextStyle(
                                  color: getColor("#555555"), fontSize: 14),
                            ),
                            margin: EdgeInsets.only(top: 4),
                          ),
                          onTap: () {
                            if (isNotNullOrEmpty(this.searchParam))
                              _eventCallBackMonth();
                          },
                        ),
                        _girdViewMonth(
                          listCheckMonth,
                          onData: (data) {
                            listCheckMonth.remove(data);
                          },
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isShowQuarter,
                    child: Column(
                      children: [
                        InkWell(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 8, bottom: 12),
                            child: Text(
                              'Chọn quý',
                              style: TextStyle(
                                  color: getColor("#555555"), fontSize: 14),
                            ),
                            margin: EdgeInsets.only(top: 4),
                          ),
                          onTap: () {
                            if (isNotNullOrEmpty(this.searchParam))
                              _eventCallBackQuarter();
                          },
                        ),
                        _girdViewMonth(
                          listCheckQuarter,
                          onData: (data) {
                            listCheckQuarter.remove(data);
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SaveButton(
            margin: EdgeInsets.only(top: 8),
            title: 'ÁP DỤNG',
            onTap: () {
              _eventClickSaveFilter();
            },
          ),
        ],
      ),
    );
  }

  // phòng ban
  _eventCallBackDept() {
    pushPage(
        context,
        FilterCategoryScreen(
          searchParam?.categories,
          true,
          listCheckDept,
          titleDept,
          onListSelected: (listSelected) {
            setState(() {
              listCheckDept = listSelected;
              stringTextDept();
            });
          },
        ));
  }

  stringTextDept() {
    String sDept = listCheckDept.map((e) => e.name).toList().toString();
    sDept = sDept.replaceAll('[', '').replaceAll(']', '');
    deptController.text = sDept;
  }

  // seller
  _eventCallBackSeller() {
    pushPage(
        context,
        FilterSellerScreen(
          searchParam?.seller,
          true,
          listCheckSeller,
          onListSelected: (listSelected) {
            setState(() {
              listCheckSeller = listSelected;
              stringTextSeller();
            });
          },
        ));
  }

  stringTextSeller() {
    String seller = listCheckSeller.map((e) => e.name).toList().toString();
    seller = seller.replaceAll('[', '').replaceAll(']', '');
    sellerController.text = seller;
  }

  // năm
  _eventCallBackYear() {
    if (isNullOrEmpty(searchParam.years)) {
      ToastMessage.show("Không có dữ liệu", ToastStyle.error);
      return;
    }

    ChoiceDialog choiceDialog = ChoiceDialog<DateTypes>(
      context,
      listYear,
      title: 'Chọn năm',
      selectedObject: listCheckYear,
      getTitle: (data) => data.text,
      isSingleChoice: isSingleYear,
      hintSearchText: "Tìm kiếm theo năm",
      onAccept: (List<DateTypes> selected) {
        setState(() {
          listCheckYear = selected;
          stringTextYears();
        });
      },
      choiceButtonText: 'Chọn năm',
    );
    choiceDialog.showChoiceDialog();
  }

  stringTextYears() {
    String year = listCheckYear.map((e) => e.text).toList().toString();
    year = year.replaceAll('[', '').replaceAll(']', '');
    yearController.text = year;
  }

  // tháng
  _eventCallBackMonth() {
    if (isNullOrEmpty(searchParam.months)) {
      ToastMessage.show("Không có dữ liệu", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        FilterMonthScreen(
          searchParam.months,
          true,
          listCheckMonth,
          'Chọn tháng',
          onListSelected: (listSelected) {
            setState(() {
              listCheckMonth = listSelected;
            });
          },
        ));
  }

  // chọn quý
  _eventCallBackQuarter() {
    pushPage(
        context,
        FilterMonthScreen(
          searchParam.quarters,
          true,
          listCheckQuarter,
          'Chọn quý',
          onListSelected: (listSelected) {
            setState(() {
              listCheckQuarter = listSelected;
            });
          },
        ));
  }

  // loại báo cáo
  _eventCallBackTypeReport() {
    searchParam?.dateTypes?.forEach((element) {
      listCheckDateTypes.forEach((element1) {
        if (element.value == element1.value) {
          element.isSelected = true;
        }
      });
    });
    showModalBottomSheet(
        isScrollControlled: true,
        context: this.context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Wrap(
            children: [
              BottomSheetQuarterScreen(
                searchParam.dateTypes,
                false,
                'Loại báo cáo',
                onListSelected: (listSelected) {
                  setState(() {
                    listCheckDateTypes = listSelected;
                    // hiện tại class này chỉ đang chọn 1 lên fix cứng  = 0
                    stringTextTypeData();
                  });
                },
              ),
            ],
          );
        });
  }

  stringTextTypeData() {
    typeReportController.text = listCheckDateTypes[0].text;
    if (listCheckDateTypes[0].value == 1) {
      // báo cáo quý (show view qúy)
      isShowQuarter = true;
      isShowMonth = false;
      listCheckMonth.clear();
    } else if (listCheckDateTypes[0].value == 2) {
      // báo cáo tháng (show view tháng)
      isShowMonth = true;
      isShowQuarter = false;
      listCheckQuarter.clear();
    } else {
      // clear 2 view trên
      isShowQuarter = false;
      isShowMonth = false;
      listCheckQuarter.clear();
      listCheckMonth.clear();
    }
  }

  Widget _girdViewMonth(List<DateTypes> listData,
      {Function(DateTypes data) onData}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: listData.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: _aspectRatio,
          crossAxisSpacing: _crossAxisSpacing,
          mainAxisSpacing: _mainAxisSpacing,
        ),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (BuildContext context, int index) {
          DateTypes item = listData[index];
          return InkWell(
            onTap: () {
              setState(() {
                onData(item);
              });
            },
            child: UnconstrainedBox(
              alignment: Alignment.centerLeft,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(width: 1, color: Colors.grey)),
                child: Row(
                  children: [
                    Text(
                      '${item?.text} ' ?? ' ',
                      style: TextStyle(fontSize: 12),
                    ),
                    Icon(
                      Icons.clear,
                      color: Colors.grey,
                      size: 12,
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _eventClickSaveFilter() {
    String dept = listCheckDept.map((e) => e.iD).toList().toString();
    dept = dept.replaceAll(', ', ',').replaceAll('[', '').replaceAll(']', '');

    String year = listCheckYear.map((e) => e.value).toList().toString();
    year = year.replaceAll(', ', ',').replaceAll('[', '').replaceAll(']', '');

    String typeReport =
        listCheckDateTypes.map((e) => e.value).toList().toString();
    typeReport = typeReport
        .replaceAll(', ', ',')
        .replaceAll('[', '')
        .replaceAll(']', '');

    String month = listCheckMonth.map((e) => e.value).toList().toString();
    month = month.replaceAll(', ', ',').replaceAll('[', '').replaceAll(']', '');

    String quarter = listCheckQuarter.map((e) => e.value).toList().toString();
    quarter =
        quarter.replaceAll(', ', ',').replaceAll('[', '').replaceAll(']', '');

    String seller = listCheckSeller.map((e) => e.iD).toList().toString();
    seller =
        seller.replaceAll(', ', ',').replaceAll('[', '').replaceAll(']', '');

    switch (numberTabFilter) {
      //doanh thu - Tổng quan - theo kế hoạch, quý, chi nhánh, theo phòng ban, theo nguồn khách hàng, theo chiến dịch marketing
      case OverviewPlanScreen.TAB_PLAN:
      case OverviewPlanScreen.TAB_QUATER:
      case OverviewPlanScreen.TAB_BRANCH:
      case OverviewPlanScreen.TAB_DEPT:
      case OverviewPlanScreen.TAB_CUSTOM:
      case OverviewPlanScreen.TAB_MARKETING:
        request.iDSellers = seller;
        request.year = year;
        request.dateType = typeReport;
        request.quarters = quarter;
        request.months = month;
        break;

      // doanh thu - thống kê chi tiết - theo phòng ban
      case StatisticAccordingDeptScreen.TAB_DEPT:
        request.iDCenter = dept;
        request.years = year;
        request.dateType = typeReport;
        request.quarters = quarter;
        request.months = month;
        break;

      // doanh thu - thống kê chi tiết - theo seller
      case StatisticAccordingDeptScreen.TAB_SELLER:
        request.iDSellers = seller;
        request.years = year;
        request.dateType = typeReport;
        request.quarters = quarter;
        request.months = month;
        break;

      //doanh thu - thống kê chi tiết - theo tình thành (vùng)
      case StatisticAccordingDeptScreen.TAB_AREA:
        request.provinces = dept;
        request.years = year;
        request.dateType = typeReport;
        request.quarters = quarter;
        request.months = month;
        break;

      //doanh thu - thống kê chi tiết - theo khách hàng
      case StatisticAccordingDeptScreen.TAB_CUSTOM:
        request.iDCustomers = dept;
        request.years = year;
        request.dateType = typeReport;
        request.quarters = quarter;
        request.months = month;
        break;

      //doanh thu - theo thời gian
      case RevenueTimeScreen.TAB_BY_TIME:
        request.iDSellers = seller;
        request.years = year;
        request.type = typeReport;
        request.quarters = quarter;
        request.months = month;
        break;

      //doanh thu - theo giai đoạn
      case RevenuePhasedScreen.TAB_REVENUE_PHASED:
        if (listCheckSeller.length == 1)
          request.iDSeller = seller;
        else
          request.iDSellers = seller;
        request.year = year;
        break;

      // hợp đồng - top Hợp đồng
      case TopContractScreen.TAB_TOP_CONTRACT:
      // hợp đồng - danh sách Hợp đồng
      case ListContractScreen.TAB_LIST_CONTRACT:
        request.iDSellers = seller;
        request.year = year;
        request.dateType = typeReport;
        request.quarters = quarter;
        request.months = month;
        break;

      // thưởng - theo phòng ban
      case BonusByDeptScreen.TAB_BONUS_DEPT:
      // thưởng - theo chi nhánh
      case BonusByDeptScreen.TAB_BONUS_BRANCH:
        request.year = year;
        request.quarters = quarter;
        break;

      // thưởng - top thưởng cá nhân
      case BonusTopPersonalScreen.TAB_BONUS_TOP_PERSONAL:
        request.iDSellers = seller;
        request.year = year;
        request.quarters = quarter;
        break;

      // doanh thu dự kiến - các năm gần đây
      case ExpectedYearScreen.TAB_EXPECTED_REVENUE:
        request.iDSellers = seller;
        break;
      // doanh thu dự kiến - theo quý
      case ExpectedYearScreen.TAB_EXPECTED_QUARTER:
      // doanh thu dự kiến - theo tháng
      case ExpectedYearScreen.TAB_EXPECTED_MONTH:
        request.iDSellers = seller;
        request.years = year;
        break;

      // doanh thu dự kiến - theo kế hoạch
      case ExpectedPlanScreen.TAB_EXPECTED_PLAN:
        request.iDSellers = seller;
        request.startSignDate = startDateController.text;
        request.endSignDate = endDateController.text;
        break;
    }

    eventBus.fire(GetRequestFilterToTabEventBus(
        numberTabFilter: numberTabFilter, request: request));
    if (isNotNullOrEmpty(searchParam)) {
      // phòng ban
      if (isNotNullOrEmpty(searchParam?.categories)) {
        searchParam?.categories?.forEach((element) {
          element.isSelected = false;
          if (listCheckDept.length > 0) {
            listCheckDept?.forEach((element1) {
              if (element?.iD == element1?.iD) element.isSelected = true;
            });
          }
        });
      }
      //seller
      if (isNotNullOrEmpty(searchParam?.seller)) {
        searchParam?.seller?.forEach((element) {
          element.isSelected = false;
          if (listCheckSeller.length > 0) {
            listCheckSeller?.forEach((element1) {
              if (element?.iD == element1?.iD) element.isSelected = true;
            });
          }
        });
      }
      // năm
      if (listYear.length > 0) {
        listYear.forEach((element) {
          element.isSelected = false;
          if (listCheckYear.length > 0) {
            listCheckYear?.forEach((element1) {
              if (element?.value == element1?.value) element.isSelected = true;
            });
          }
        });
        searchParam?.listYear = listYear;
      }
      // tháng
      if (isNotNullOrEmpty(searchParam?.months)) {
        searchParam?.months?.forEach((element) {
          element.isSelected = false;
          if (listCheckMonth.length > 0) {
            listCheckMonth?.forEach((element1) {
              if (element?.value == element1?.value) element.isSelected = true;
            });
          }
        });
      }
      // quý
      if (isNotNullOrEmpty(searchParam?.quarters)) {
        searchParam?.quarters?.forEach((element) {
          element.isSelected = false;
          if (listCheckQuarter.length > 0) {
            listCheckQuarter?.forEach((element1) {
              if (element?.value == element1?.value) element.isSelected = true;
            });
          }
        });
      }
      // loại báo cáo
      if (isNotNullOrEmpty(searchParam?.dateTypes)) {
        searchParam?.dateTypes?.forEach((element) {
          element.isSelected = false;
          if (listCheckDateTypes.length > 0) {
            listCheckDateTypes?.forEach((element1) {
              if (element?.value == element1?.value) element.isSelected = true;
            });
          }
        });
      }
      // ngày bắt đầu
      if (isNotNullOrEmpty(startDateController.text)) {
        searchParam?.startDate = startDateController.text;
      }
      // ngày kết thúc
      if (isNotNullOrEmpty(endDateController.text)) {
        searchParam?.endDate = endDateController.text;
      }
    }

    Navigator.of(context).pop();
  }

  _eventClickRefresh() {
    if (isNotNullOrEmpty(searchParam)) {
      startDateController = TextEditingController();
      endDateController = TextEditingController();
      deptController = TextEditingController();
      yearController = TextEditingController();
      typeReportController = TextEditingController();
      sellerController = TextEditingController();

      listCheckDept = [];
      listCheckSeller = [];
      listCheckYear = [];
      listCheckMonth = [];
      listCheckQuarter = [];
      listCheckDateTypes = [];

      isShowQuarter = false;
      isShowMonth = false;
    }
  }

  _checkShowWidget(
      {bool isShowDept = false,
      bool isShowSeller = false,
      bool isShowYear = false,
      bool isShowStartDate = false,
      bool isShowEndDate = false,
      bool isShowTypeReport = false,
      bool isShowMonth = false,
      bool isShowQuarter = false}) {
    this.isShowDept = isShowDept;
    this.isShowSeller = isShowSeller;
    this.isShowYear = isShowYear;
    this.isShowStartDate = isShowStartDate;
    this.isShowEndDate = isShowEndDate;
    this.isShowTypeReport = isShowTypeReport;
    this.isShowMonth = isShowMonth;
    this.isShowQuarter = isShowQuarter;
  }
}

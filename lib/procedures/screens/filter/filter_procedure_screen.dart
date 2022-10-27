import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/params/filter_request.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/models/response/search_procedure_model.dart';
import 'package:workflow_manager/procedures/widgets/select_value_widget.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'list_select_screen.dart';
import 'package:workflow_manager/base/utils/palette.dart';
import 'package:workflow_manager/base/extension/string.dart';

enum FilterProcedureType {
  TERM,
  START_DATE,
  END_DATE,
  YEAR,
  STATE, // trạng thái
  TYPE, // loại thủ tục
  SERVICE, // thủ tục
  PRIORITY, // mức độ
  STATUS, // tình trạng hồ sơ

  // tab giải quyết sẽ thêm các trường này
  USER_REGISTER, // người đăng ký
  DEPT, // Phòng ban
  FROM_EXPECTED, // hạn từ ngày
  TO_EXPECTED, // hạn đến ngày
}

enum FilterRootType { REGISTER, RESOLVE, REPORT }

class FilterProcedureScreen extends StatefulWidget {
  void Function(FilterRequest) onDoneFilter;

  SearchProcedureModel searchProcedureModel;

  FilterRequest originalRequest;

  List<FilterProcedureType> arrayTypeItem;

  FilterRootType rootType;

  bool isDelete = true;

  FilterProcedureScreen(
      {this.searchProcedureModel,
      this.originalRequest,
      this.arrayTypeItem,
      this.onDoneFilter,
      this.rootType,
      this.isDelete = true});

  @override
  _FilterProcedureScreenState createState() => _FilterProcedureScreenState();
}

class _FilterProcedureScreenState extends State<FilterProcedureScreen> {
  FilterRequest filterRequest = FilterRequest();

  List<Services> listServices = List();

  List<UserRegister> listUserRegisters = List();

  TextEditingController termController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (this.widget.originalRequest != null) {
      filterRequest =
          FilterRequest.fromJson(this.widget.originalRequest.toJson());
      termController.text = filterRequest.term;
    }

    if (isNotNullOrEmpty(widget.searchProcedureModel.listServices)) {
      listServices.addAll(widget.searchProcedureModel.listServices);
    }

    if (isNotNullOrEmpty(widget.searchProcedureModel.listUserRegisters)) {
      listUserRegisters.addAll(widget.searchProcedureModel.listUserRegisters);
    }

    if (isNotNullOrEmpty(filterRequest.typeResolve.iD)) {
      _filterService(filterRequest.typeResolve.iD);
    }

    if (isNotNullOrEmpty(widget.searchProcedureModel.listStates) &&
        isNotNullOrEmpty(filterRequest.filterState)) {
      FilterStates filterStates = widget.searchProcedureModel.listStates
          .firstWhere(
              (element) => element.state == filterRequest.filterState.state,
              orElse: () => null);
      filterRequest.filterState = filterStates;
    }
  }

  //Lọc thủ tục theo loại thủ tục
  _filterService(int typeResolveId) {
    listServices.clear();
    listServices.addAll(widget.searchProcedureModel.listServices);
    setState(() {
      listServices =
          listServices.where((item) => item.iDType == typeResolveId).toList();
    });
  }

  //Lọc người đăng ký theo phòng ban
  _filterRegister(int iDDept) {
    listUserRegisters.clear();
    listUserRegisters.addAll(widget.searchProcedureModel.listUserRegisters);
    setState(() {
      listUserRegisters =
          listUserRegisters.where((item) => item.iDDept == iDDept).toList();
    });
  }

  _resetDate(int year) {
    setState(() {
      filterRequest.startDate = "01/01/${year}";
      filterRequest.endDate = "31/12/${year}";
    });
  }

  _delete() {
    this.termController.text = "";
    listServices.clear();
    listUserRegisters.clear();
    this.setState(() {
      if (isNotNullOrEmpty(widget.searchProcedureModel.listUserRegisters)) {
        listUserRegisters.addAll(widget.searchProcedureModel.listUserRegisters);
      }
      if (isNotNullOrEmpty(widget.searchProcedureModel.listServices)) {
        listServices.addAll(widget.searchProcedureModel.listServices);
      }
      this.filterRequest = FilterRequest();
    });
    this.widget.originalRequest = FilterRequest();
  }

  String _getTitleStartDate() {
    switch (widget.rootType) {
      case FilterRootType.REGISTER:
        return "Đăng ký từ ngày";
        break;
      case FilterRootType.RESOLVE:
        return "Thời gian gửi từ ngày";
        break;
    }
    return 'Từ ngày';
  }

  String _getTitleFilterUser() {
    switch (widget.rootType) {
      case FilterRootType.REPORT:
        return "Người giải quyết";
        break;
    }
    return "Người đăng ký";
  }

  String _getTitleEndDate() {
    switch (widget.rootType) {
      case FilterRootType.REGISTER:
        return "Đăng ký đến ngày";
        break;
      case FilterRootType.RESOLVE:
        return "Thời gian gửi đến ngày";
        break;
    }
    return 'Đến ngày';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lọc"),
        leading: BackIconButton(),
        actions: <Widget>[
          Opacity(
            opacity: widget.isDelete ? 1 : 0,
            child: FlatButton(
              child: Text(
                "Xoá",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                _delete();
              },
            ),
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
        Visibility(
          visible: widget.arrayTypeItem.contains(FilterProcedureType.TERM),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: termController,
              onChanged: (value) {
                filterRequest.term = value;
              },
              style: TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: "Tìm theo tên",
                enabledBorder: new UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Palette.borderEditText.toColor())),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue)),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 8),
        ),
        Visibility(
            visible:
                widget.arrayTypeItem.contains(FilterProcedureType.START_DATE),
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SelectValueWidget(
                _getTitleStartDate(),
                value: filterRequest.startDate ?? "",
                icon: Icons.date_range,
                onPressed: () {
                  DateTimePickerWidget(
                      context: context,
                      format: Constant.ddMMyyyy,
                      onDateTimeSelected: (dateValue) {
                        setState(() {
                          filterRequest.startDate = dateValue;
                        });
                      }).showOnlyDatePicker();
                },
              ),
            )),
        Visibility(
            visible:
                widget.arrayTypeItem.contains(FilterProcedureType.END_DATE),
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SelectValueWidget(
                _getTitleEndDate(),
                value: filterRequest.endDate ?? "",
                icon: Icons.date_range,
                onPressed: () {
                  DateTimePickerWidget(
                      context: context,
                      format: Constant.ddMMyyyy,
                      onDateTimeSelected: (dateValue) {
                        setState(() {
                          filterRequest.endDate = dateValue;
                        });
                      }).showOnlyDatePicker();
                },
              ),
            )),
        Visibility(
            visible: widget.arrayTypeItem.contains(FilterProcedureType.YEAR),
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SelectValueWidget(
                "Năm",
                value: filterRequest.filterYear.name ?? "",
                icon: Icons.date_range,
                onPressed: () {
                  pushPage(
                      context,
                      ListSelectScreen(
                        title: "Năm",
                        arraySelectModel: widget.searchProcedureModel.listYears,
                        currentSelect: filterRequest.filterYear,
                        onSelected: (modelSelected) {
                          setState(() {
                            filterRequest.filterYear = modelSelected;
                            _resetDate(int.parse(modelSelected.name));
                          });
                        },
                      ));
                },
              ),
            )),
        Visibility(
          visible:
              widget.arrayTypeItem.contains(FilterProcedureType.USER_REGISTER),
          child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SelectValueWidget(
                _getTitleFilterUser(),
                value: filterRequest.filterUserRegister?.name ?? "",
                onPressed: () {
                  pushPage(
                      context,
                      ListSelectScreen(
                        title: _getTitleFilterUser(),
                        arraySelectModel: listUserRegisters,
                        currentSelect: filterRequest.filterUserRegister,
                        onSelected: (modelSelected) {
                          setState(() {
                            filterRequest.filterUserRegister = modelSelected;
                          });
                        },
                        isShowSearchWidget: true,
                      ));
                },
              )),
        ),
        Visibility(
          visible: widget.arrayTypeItem.contains(FilterProcedureType.STATE),
          child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SelectValueWidget(
                "Trạng thái",
                value: filterRequest.filterState?.name ?? "",
                onPressed: () {
                  pushPage(
                      context,
                      ListSelectScreen(
                        title: "Trạng thái",
                        arraySelectModel:
                            widget.searchProcedureModel.listStates,
                        currentSelect: filterRequest.filterState,
                        onSelected: (modelSelected) {
                          setState(() {
                            filterRequest.filterState = modelSelected;
                          });
                        },
                      ));
                },
              )),
        ),
        Visibility(
          visible: widget.arrayTypeItem.contains(FilterProcedureType.TYPE),
          child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SelectValueWidget(
                "Loại thủ tục",
                value: filterRequest.typeResolve.name ?? "",
                onPressed: () {
                  pushPage(
                      context,
                      ListSelectScreen(
                        title: "Loại thủ tục",
                        arraySelectModel:
                            widget.searchProcedureModel.listTypeResolves,
                        currentSelect: filterRequest.typeResolve,
                        onSelected: (modelSelected) {
                          setState(() {
                            filterRequest.typeResolve = modelSelected;
                          });
                          _filterService(filterRequest.typeResolve.iD);
                        },
                        isShowSearchWidget: true,
                      ));
                },
              )),
        ),
        Visibility(
          visible: widget.arrayTypeItem.contains(FilterProcedureType.SERVICE),
          child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SelectValueWidget(
                "Thủ tục",
                value: filterRequest.service?.name ?? "",
                onPressed: () {
                  pushPage(
                      context,
                      ListSelectScreen(
                        title: "Thủ tục",
                        arraySelectModel: listServices,
                        currentSelect: filterRequest.service,
                        onSelected: (modelSelected) {
                          setState(() {
                            filterRequest.service = modelSelected;
                          });
                        },
                        isShowSearchWidget: true,
                      ));
                },
              )),
        ),
        Visibility(
          visible: widget.arrayTypeItem.contains(FilterProcedureType.PRIORITY),
          child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SelectValueWidget(
                "Mức độ",
                value: filterRequest.filterPriority.name ?? "",
                onPressed: () {
                  pushPage(
                      context,
                      ListSelectScreen(
                        title: "Mức độ",
                        arraySelectModel:
                            widget.searchProcedureModel?.listPriorities,
                        currentSelect: filterRequest.filterPriority,
                        onSelected: (modelSelected) {
                          setState(() {
                            filterRequest.filterPriority = modelSelected;
                          });
                        },
                      ));
                },
              )),
        ),
        Visibility(
          visible: widget.arrayTypeItem.contains(FilterProcedureType.STATUS),
          child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SelectValueWidget(
                "Tình trạng hồ sơ",
                value: filterRequest.filterStatusRecord?.name ?? "",
                onPressed: () {
                  pushPage(
                      context,
                      ListSelectScreen(
                        title: "Tình trạng hồ sơ",
                        arraySelectModel:
                            widget.searchProcedureModel?.listStatusRecords,
                        currentSelect: filterRequest.filterStatusRecord,
                        onSelected: (modelSelected) {
                          setState(() {
                            filterRequest.filterStatusRecord = modelSelected;
                          });
                        },
                      ));
                },
              )),
        ),
        Visibility(
          visible: widget.arrayTypeItem.contains(FilterProcedureType.DEPT),
          child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SelectValueWidget(
                "Phòng ban",
                value: filterRequest.filterDept?.name ?? "",
                onPressed: () {
                  pushPage(
                      context,
                      ListSelectScreen(
                        title: "Phòng ban",
                        arraySelectModel:
                            widget.searchProcedureModel?.listDepts,
                        currentSelect: filterRequest.filterDept,
                        onSelected: (modelSelected) {
                          setState(() {
                            filterRequest.filterDept = modelSelected;
                          });
                          _filterRegister(filterRequest.filterDept.iD);
                        },
                        isShowSearchWidget: true,
                      ));
                },
              )),
        ),
        Visibility(
            visible: widget.arrayTypeItem
                .contains(FilterProcedureType.FROM_EXPECTED),
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SelectValueWidget(
                "Hạn từ ngày",
                value: filterRequest.fromExpectedDate ?? "",
                icon: Icons.date_range,
                onPressed: () {
                  DateTimePickerWidget(
                      context: context,
                      format: Constant.ddMMyyyy,
                      onDateTimeSelected: (dateValue) {
                        setState(() {
                          filterRequest.fromExpectedDate = dateValue;
                        });
                      }).showOnlyDatePicker();
                },
              ),
            )),
        Visibility(
            visible:
                widget.arrayTypeItem.contains(FilterProcedureType.TO_EXPECTED),
            child: Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: SelectValueWidget(
                "Hạn đến ngày",
                value: filterRequest.toExpectedDate ?? "",
                icon: Icons.date_range,
                onPressed: () {
                  DateTimePickerWidget(
                      context: context,
                      format: Constant.ddMMyyyy,
                      onDateTimeSelected: (dateValue) {
                        setState(() {
                          filterRequest.toExpectedDate = dateValue;
                        });
                      }).showOnlyDatePicker();
                },
              ),
            )),
      ],
    );
  }
}

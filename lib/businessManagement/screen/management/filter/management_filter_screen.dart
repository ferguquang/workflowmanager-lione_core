import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/event_bus_buniness_management.dart';
import 'package:workflow_manager/businessManagement/model/request/list_plans_request.dart';
import 'package:workflow_manager/businessManagement/model/response/project_plan_index_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/filter/select_param_screen.dart';
import 'package:workflow_manager/businessManagement/screen/management/filter/select_phases_screen.dart';
import 'package:workflow_manager/businessManagement/screen/management/filter/select_sellers_screen.dart';
import 'package:workflow_manager/procedures/widgets/select_value_widget.dart';

import '../../../../main.dart';

class ManagementFilterScreen extends StatefulWidget {
  SearchParamListManage searchParam;

  ListPlansRequest plansRequest;

  ManagementFilterScreen({this.searchParam, this.plansRequest});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ManagementFilterScreen();
  }
}

class _ManagementFilterScreen extends State<ManagementFilterScreen> {
  ListPlansRequest _plansRequest = ListPlansRequest();
  TextEditingController _yearTextController = TextEditingController();
  StreamSubscription _dataSearchManageParams;
  SearchParamListManage searchParam;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.plansRequest == null) widget.plansRequest = ListPlansRequest();
    _plansRequest = widget.plansRequest;
    if (widget.searchParam == null)
      widget.searchParam = SearchParamListManage();
    searchParam = widget.searchParam;
    _getDataStauts();

    if (isNotNullOrEmpty(_dataSearchManageParams))
      _dataSearchManageParams.cancel();
    _dataSearchManageParams =
        eventBus.on<GetListDataFilterManagerEventBus>().listen((event) {
      setState(() {
        searchParam = event?.searchParam;
        _plansRequest = event?.plansRequest;
        _getDataStauts();
      });
    });
  }

  _getDataStauts() {
    if (searchParam == null) return;
    if (_plansRequest?.issFirst) {
      if (isNotNullOrEmpty(searchParam) &&
          isNotNullOrEmpty(searchParam?.statuss)) {
        searchParam?.statuss?.forEach((element) {
          if (element?.isSelected != null && element?.isSelected) {
            _plansRequest?.statuss.add(element);
          }
        });
        _plansRequest?.issFirst = false;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (isNotNullOrEmpty(_dataSearchManageParams))
      _dataSearchManageParams.cancel();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Bộ lọc"),
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
              resetFilter();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onPanDown: (_) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: _filterWidget(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: SaveButton(
                title: "Áp dụng".toUpperCase(),
                onTap: () {
                  _plansRequest?.year = _yearTextController.text == ""
                      ? int.parse(getCurrentDate(Constant.yyyy))
                      : int.parse(_yearTextController.text);
                  eventBus.fire(GetRequestFilterToManagerEventBus(
                      plansRequest: _plansRequest));
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
      children: <Widget>[
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "AM (Sale)",
              value: getNameSellersParams(_plansRequest?.idSellers),
              onPressed: () {
                pushPage(
                    context,
                    SelectSellersScreen(
                      data: searchParam?.sellers,
                      selected: _plansRequest?.idSellers,
                      listSelected: (sellers) {
                        setState(() {
                          _plansRequest?.idSellers = [];
                          _plansRequest?.idSellers = sellers;
                        });
                      },
                    ));
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Phòng ban phụ trách",
              value: getNameParams(_plansRequest?.idCenter),
              onPressed: () {
                pushPage(
                  context,
                  SelectParamScreen(
                    title: "Chọn chi nhánh",
                    data: searchParam?.centers,
                    selected: _plansRequest?.idCenter,
                    listSelected: (dataSelected) {
                      print("${dataSelected.length}");
                      setState(() {
                        _plansRequest?.idCenter = [];
                        _plansRequest?.idCenter.addAll(dataSelected);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Loại dự án",
              value: getNameParams(_plansRequest?.idTypeProject),
              onPressed: () {
                pushPage(
                    context,
                    SelectParamScreen(
                      title: "Chọn loại dự án",
                      data: searchParam?.typeProjects,
                      selected: _plansRequest?.idTypeProject,
                      listSelected: (dataSelected) {
                        print("${dataSelected.length}");
                        setState(() {
                          _plansRequest?.idTypeProject = [];
                          _plansRequest?.idTypeProject.addAll(dataSelected);
                        });
                      },
                    ));
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Loại hình doanh nghiệp",
              value: getNameParams(_plansRequest?.idTypeBusiness),
              onPressed: () {
                pushPage(
                    context,
                    SelectParamScreen(
                      title: "Chọn loại hình doanh nghiệp",
                      data: searchParam?.typeBusiness,
                      selected: _plansRequest?.idTypeBusiness,
                      listSelected: (dataSelected) {
                        setState(() {
                          bool isContains = false;
                          for (int i = 0; i < dataSelected.length; i++) {
                            TypeProjects item = dataSelected[i];
                            if (_plansRequest?.idTypeBusiness
                                    .where((element) => element.iD == item.iD)
                                    .length >
                                0) {
                              isContains = true;
                            }
                          }
                          if (!isContains) {
                            _plansRequest?.idPhases = [];
                          }
                          _plansRequest?.idTypeBusiness = [];
                          _plansRequest?.idTypeBusiness.addAll(dataSelected);
                        });
                      },
                    ));
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Giai đoạn",
              value: getNameParams(_plansRequest?.idPhases),
              onPressed: () {
                pushPage(
                    context,
                    SelectPhasesScreen(
                      data: searchParam?.typeBusiness,
                      selected: _plansRequest?.idPhases,
                      typeBussinessSelected: _plansRequest?.idTypeBusiness,
                      listSelected: (dataSelected) {
                        _plansRequest?.idPhases = [];
                        _plansRequest?.idPhases.addAll(dataSelected);
                      },
                    ));
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Trạng thái",
              value: getNameParams(_plansRequest?.statuss),
              onPressed: () {
                pushPage(
                    context,
                    SelectParamScreen(
                      title: "Chọn trạng thái",
                      data: searchParam?.statuss,
                      selected: _plansRequest?.statuss,
                      listSelected: (dataSelected) {
                        print("${dataSelected.length}");
                        setState(() {
                          _plansRequest?.statuss = [];
                          _plansRequest?.statuss.addAll(dataSelected);
                        });
                      },
                    ));
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Quý",
              value: getNameParams(_plansRequest?.quaters),
              onPressed: () {
                pushPage(
                    context,
                    SelectParamScreen(
                      title: "Chọn quý",
                      data: searchParam?.quarters,
                      selected: _plansRequest?.quaters,
                      listSelected: (dataSelected) {
                        print("${dataSelected.length}");
                        setState(() {
                          _plansRequest?.quaters = [];
                          _plansRequest?.quaters.addAll(dataSelected);
                        });
                      },
                    ));
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Column(
            children: <Widget>[
              Container(
                height: 40,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                    ),
                    Expanded(child: Text('Năm')),
                    Container(
                      width: 150,
                      child: TextFormField(
                        controller: _yearTextController,
                        onChanged: (value) {
                          print("value 1: $value");
                          if (value.length > 0) {
                            print("value 2: $value");
                            if (!isNumeric(value)) {
                              print("value 3: $value");
                              _yearTextController.text = "2021";
                            }
                          }
                        },
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        textAlign: TextAlign.right,
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding:
                              EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                          labelText: '${_plansRequest?.year}',
                          hintText: 'Nhập năm',
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 8),
                    ),
                    Icon(
                      Icons.date_range,
                      color: Colors.grey,
                      size: 16.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 16),
                    ),
                  ],
                ),
              ),
              Divider(color: getColor('DDDDDD')),
            ],
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Nguồn khách hàng",
              value: getNameParams(_plansRequest?.sources),
              onPressed: () {
                pushPage(
                    context,
                    SelectParamScreen(
                      title: "Chọn nguồn khách hàng",
                      data: searchParam?.sources,
                      selected: _plansRequest?.sources,
                      listSelected: (dataSelected) {
                        print("${dataSelected.length}");
                        setState(() {
                          _plansRequest?.sources = [];
                          _plansRequest?.sources.addAll(dataSelected);
                        });
                      },
                    ));
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Tỉnh, thành phố",
              value: getNameParams(_plansRequest?.provinces),
              onPressed: () {
                pushPage(
                    context,
                    SelectParamScreen(
                      title: "Chọn tỉnh, thành phố",
                      data: searchParam?.provinces,
                      selected: _plansRequest?.provinces,
                      listSelected: (dataSelected) {
                        print("${dataSelected.length}");
                        setState(() {
                          _plansRequest?.provinces = [];
                          _plansRequest?.provinces.addAll(dataSelected);
                        });
                      },
                    ));
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Mức độ tiềm năng",
              value: getNameParams(_plansRequest?.potentialTypes),
              onPressed: () {
                pushPage(
                    context,
                    SelectParamScreen(
                      title: "Chọn mức độ tiềm năng",
                      data: searchParam?.potentialTypes,
                      selected: _plansRequest.potentialTypes,
                      listSelected: (dataSelected) {
                        print("${dataSelected.length}");
                        setState(() {
                          _plansRequest?.potentialTypes = [];
                          _plansRequest?.potentialTypes.addAll(dataSelected);
                        });
                      },
                    ));
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Chiến dịch Marketing",
              value: getNameParams(_plansRequest?.campaignTypes),
              onPressed: () {
                pushPage(
                    context,
                    SelectParamScreen(
                      title: "Chọn chiến dịch Marketing",
                      data: searchParam?.campaignTypes,
                      selected: _plansRequest.campaignTypes,
                      listSelected: (dataSelected) {
                        setState(() {
                          _plansRequest?.campaignTypes = [];
                          _plansRequest?.campaignTypes.addAll(dataSelected);
                        });
                      },
                    ));
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Từ ngày ký hợp đồng dự kiến",
              value: _plansRequest?.startDate ?? "",
              onPressed: () {
                DateTimePickerWidget(
                    // minTime: DateTime.now(),
                    format: Constant.ddMMyyyy2,
                    context: context,
                    onDateTimeSelected: (valueDate) {
                      setState(() {
                        _plansRequest?.startDate = valueDate;
                      });
                      // print(valueDate);
                    }).showOnlyDatePicker();
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Đến ngày ký hợp đồng dự kiến",
              value: _plansRequest?.endDate ?? "",
              onPressed: () {
                DateTimePickerWidget(
                    // minTime: DateTime.now(),
                    format: Constant.ddMMyyyy2,
                    context: context,
                    onDateTimeSelected: (valueDate) {
                      setState(() {
                        _plansRequest?.endDate = valueDate;
                      });
                      // print(valueDate);
                    }).showOnlyDatePicker();
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Từ ngày cập nhật",
              value: _plansRequest.startDateUpdated ?? "",
              onPressed: () {
                DateTimePickerWidget(
                    // minTime: DateTime.now(),
                    format: Constant.ddMMyyyy2,
                    context: context,
                    onDateTimeSelected: (valueDate) {
                      setState(() {
                        _plansRequest?.startDateUpdated = valueDate;
                      });
                      // print(valueDate);
                    }).showOnlyDatePicker();
              },
            ),
          ),
        ),
        Visibility(
          visible: true,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: SelectValueWidget(
              "Đến ngày cập nhật",
              value: _plansRequest?.endDateUpdated ?? "",
              onPressed: () {
                DateTimePickerWidget(
                    // minTime: DateTime.now(),
                    format: Constant.ddMMyyyy2,
                    context: context,
                    onDateTimeSelected: (valueDate) {
                      setState(() {
                        _plansRequest?.endDateUpdated = valueDate;
                        // dateSignContract = valueDate;
                      });
                      // print(valueDate);
                    }).showOnlyDatePicker();
              },
            ),
          ),
        ),
      ],
    );
  }

  String getNameParams(List<TypeProjects> datas) {
    String name = "";
    if (isNotNullOrEmpty(datas)) {
      datas.forEach((element) {
        name += "${element.name}, ";
      });
    }
    return name;
  }

  String getNamePhaseParams(List<TypeBusiness> datas) {
    String name = "";
    if (isNotNullOrEmpty(datas)) {
      datas.forEach((element) {
        name += "${element.name}, ";
      });
    }
    return name;
  }

  String getNameSellersParams(List<Sellers> datas) {
    String name = "";
    if (isNotNullOrEmpty(datas)) {
      datas.forEach((element) {
        name += "${element.name}, ";
      });
    }
    return name;
  }

  resetFilter() {
    setState(() {
      _plansRequest = ListPlansRequest();
    });
  }
}

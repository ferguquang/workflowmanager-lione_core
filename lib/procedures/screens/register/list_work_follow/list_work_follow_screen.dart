import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/register/choice_type_procedure/choice_type_procedure_screen.dart';
import 'package:workflow_manager/procedures/screens/register/display_row_text_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/info_work_follow_screen.dart';
import 'package:workflow_manager/procedures/screens/register/list_work_follow/list_work_follow_repository.dart';
import 'package:workflow_manager/procedures/screens/register/list_work_follow/list_work_follow_screen.dart';
import 'package:workflow_manager/procedures/screens/register/step_widget.dart';
import 'package:workflow_manager/procedures/models/params/list_work_follow_request.dart';
import 'package:workflow_manager/procedures/models/response/RegisterServiceResponse.dart';
import 'package:workflow_manager/workflow/screens/details/flow_chart.dart';

class ListWorkFollowScreen extends StatefulWidget {
  int idType;

  ListWorkFollowScreen(this.idType);

  @override
  State<StatefulWidget> createState() {
    return _ListWorkFollowScreenState();
  }
}

class _ListWorkFollowScreenState extends State<ListWorkFollowScreen>
    with TickerProviderStateMixin {
  ListWorkFollowRepository _listWorkFollowRepository =
      ListWorkFollowRepository();
  GlobalKey _stepKey = GlobalKey();
  bool isShowSearch = false;
  TextEditingController _searchController = TextEditingController();

  RefreshController _refreshController = RefreshController();

  @override
  void initState() {
    ListWorkFollowRequest request = ListWorkFollowRequest();
    request.idType = widget.idType;
    _listWorkFollowRepository.loadDataRequest = request;
    _listWorkFollowRepository.refreshData();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _searchController.addListener(() {
        _listWorkFollowRepository.onTextChanged(_searchController.text);
      });
    });
    super.initState();
  }

  backAll(data) {
    (_stepKey.currentState as StepWidgetState).backAll(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đăng ký hồ sơ"),
      ),
      body: ChangeNotifierProvider.value(
        value: _listWorkFollowRepository,
        child: Consumer(
          builder: (context, ListWorkFollowRepository listWorkFollowRepository,
              child) {
            return Column(
              children: [
                StepWidget(1, _stepKey),
                Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 16),
                      color: getColor("#F2F2F2"),
                      child: Row(
                        children: [
                          PopupMenuButton(
                            offset: Offset(0, 10),
                            onSelected: (value) {
                              if (value == 0) {
                                _listWorkFollowRepository.featureType = 1;
                                _listWorkFollowRepository.refreshData();
                              } else {
                                _listWorkFollowRepository.featureType = null;
                                _listWorkFollowRepository.refreshData();
                              }
                            },
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  value: 0,
                                  child: Text("Thường dùng"),
                                ),
                                PopupMenuItem(
                                  value: 1,
                                  child: Text("Tất cả"),
                                )
                              ];
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 16, top: 4, bottom: 4, right: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(100))),
                              child: Row(
                                children: [
                                  Text(_listWorkFollowRepository.featureType ==
                                          null
                                      ? "Tất cả"
                                      : "Thường dùng"),
                                  Icon(Icons.arrow_drop_down_outlined)
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          IconButton(
                            icon: RotatedBox(
                              quarterTurns:isShowSearch? 2:0,
                                child: Icon(Icons.filter_list_rounded)),
                            onPressed: () {
                              setState(() {
                                isShowSearch = !isShowSearch;
                                if (!isShowSearch) {
                                  _listWorkFollowRepository.setStartDate(null);
                                  _listWorkFollowRepository.setEndDate(null);
                                  _searchController.text = "";
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: isShowSearch,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintText: "Tìm kiếm nhanh",
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: InkWell(
                                        child: Text(_listWorkFollowRepository
                                            .startDate),
                                        onTap: () {
                                          DateTimePickerWidget(
                                              format: Constant.ddMMyyyy,
                                              context: context,
                                              onDateTimeSelected: (valueDate) {
                                                _listWorkFollowRepository
                                                    .setStartDate(valueDate);

                                                // print(valueDate);
                                              }).showDateTimePicker();
                                        },
                                      )),
                                      Expanded(
                                          child: InkWell(
                                        child: Text(
                                            _listWorkFollowRepository.endDate),
                                        onTap: () {
                                          DateTimePickerWidget(
                                              format: Constant.ddMMyyyy,
                                              context: context,
                                              onDateTimeSelected: (valueDate) {
                                                _listWorkFollowRepository
                                                    .setEndDate(valueDate);
                                                // print(valueDate);
                                              }).showDateTimePicker();
                                        },
                                      )),
                                      Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: getColor("#62A2FE"),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 4),
                                        child: InkWell(
                                          onTap: () {
                                            _listWorkFollowRepository
                                                .refreshData();
                                          },
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 4),
                                                child: Icon(
                                                  Icons.search,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                              Text("Tìm kiếm",
                                                  style: TextStyle(
                                                      color: Colors.white)),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            height: 8,
                            color: getColor("#F2F2F2"),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Expanded(
                    child: (listWorkFollowRepository
                                    ?.registerServices?.length ??
                                0) ==
                            0
                        ? Center(
                            child: Text("Không có kết quả tìm kiếm"),
                          )
                        : SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropHeader(),
                            footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                if (mode == LoadStatus.idle) {
                                } else if (mode == LoadStatus.loading) {
                                  body = CupertinoActivityIndicator();
                                } else if (mode == LoadStatus.failed) {
                                } else if (mode == LoadStatus.canLoading) {
                      } else {}
                      return Container(
                        height: 55.0,
                        child: Center(
                          child: body,
                        ),
                      );
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: () async {
                    await _listWorkFollowRepository.refreshData();
                    _refreshController.refreshCompleted();
                  },
                  onLoading: () async {
                    await _listWorkFollowRepository.loadMore();
                    _refreshController.loadComplete();
                  },
                      child: ListView.builder(
                              itemCount: listWorkFollowRepository
                                      ?.registerServices?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                RegisterServices registerServices =
                                    listWorkFollowRepository
                                        ?.registerServices[index];
                                return InkWell(
                                  onTap: () {
                                    pushPage(
                                        context,
                                        InfoWorkFollowScreen(
                                            registerServices.iD, false, false, false));
                        },
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 16, right: 16, left: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(bottom: 4),
                                          child: Text(
                                            registerServices.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                        DisplayRowTextWidget(
                                          leftIconData: Icons.flag,
                                          label: "Loại thủ tục",
                                          content: registerServices.typeName,
                                        ),
                                        DisplayRowTextWidget(
                                          leftIconData: Icons.code,
                                          label: "Mã thủ tục",
                                          content: registerServices.code,
                                        ),
                                        DisplayRowTextWidget(
                                          leftIconData: Icons.access_time_sharp,
                                          label: "Ngày tạo",
                                          content: registerServices.created
                                              .toString()
                                              .toDateFormat(),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(top: 4),
                                        ),
                                        Row(
                                          children: [
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                    color: getColor("#63A2F5")),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.edit,
                                                      size: 16,
                                                      color: Colors.white,
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 4),
                                                    ),
                                                    Text(
                                                      "Đăng ký",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                )),
                                            InkWell(
                                              onTap: () async {
                                                pushPage(
                                                    context,
                                                    FlowChart(await SharedPreferencesClass
                                                            .get(
                                                                SharedPreferencesClass
                                                                    .ROOT_KEY) +
                                                        registerServices
                                                            .urlFlowChart +
                                                        "&Token=${await SharedPreferencesClass.getToken()}"));
                                              },
                                              child: Container(
                                                  margin:
                                                      EdgeInsets.only(left: 8),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  100)),
                                                      color:
                                                          getColor("#73A947")),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.remove_red_eye,
                                                        size: 16,
                                                        color: Colors.white,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 4),
                                                      ),
                                                      Text(
                                                        "Lưu đồ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ],
                                                  )),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                    height: 24,
                                    width: 24,
                                    margin: EdgeInsets.only(right: 16),
                                    child: SVGImage(
                                      svgName: registerServices.isFeatured
                                          ? "register_bookmark_full"
                                          : "register_bookmark",
                                      onTap: () {
                                        listWorkFollowRepository.changeFeature(
                                            registerServices.iD, index);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16),
                              color: Colors.grey.withAlpha(70),
                              height: 1,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ))
              ],
            );
          },
        ),
      ),
    );
  }
}

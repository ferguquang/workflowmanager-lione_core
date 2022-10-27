import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/ui/bottom_sheet_dialog.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/params/get_List_task_group_request.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/repository/column_group_repository.dart';
import 'package:workflow_manager/workflow/screens/group_job/shared_search_screen/shared_search_screen.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

// ignore: must_be_immutable
class FilterColumnGroupScreen extends StatefulWidget {
  int idGroupJob;

  final void Function(GetListColumnGroupRequest) onDoneFilter;

  GetListColumnGroupRequest originRequest;

  FilterColumnGroupScreen(
      {this.idGroupJob, this.originRequest, this.onDoneFilter});

  @override
  State<StatefulWidget> createState() {
    return _FilterColumnGroupScreenState();
  }
}

class _FilterColumnGroupScreenState extends State<FilterColumnGroupScreen> {
  final ColumnGroupRepository _columnGroupRepository = ColumnGroupRepository();

  TextEditingController searchTextController = TextEditingController();

  GetListColumnGroupRequest request;

  @override
  void initState() {
    super.initState();
    if (this.widget.originRequest != null) {
      request = GetListColumnGroupRequest.fromJson(
          this.widget.originRequest.toJson());
    }
    searchTextController.text = request.jobName;
    _columnGroupRepository.getListFilterColumn();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openSearchFilterScreen(
      int type, String hint, SharedSearchModel modelSelected) async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["Type"] = type;
    params["IDGroupJob"] = this.widget.idGroupJob;

    SharedSearchModel model =
        await Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
      return SharedSearchScreen(
        AppUrl.getListUserColumnGroup,
        'Tìm kiếm $hint',
        params: params,
        modelSelected: modelSelected,
        onSharedSearchSelected: (value) {},
      );
    }));
    if (type == _columnGroupRepository.filterColumnGroupData.createdType) {
      setState(() {
        request.idCreatedBy = !model.isCheck
            ? UserItem(name: '-')
            : UserItem(iD: model?.iD ?? null, name: model?.name ?? '-');
      });
    } else if (type ==
        _columnGroupRepository.filterColumnGroupData.executerType) {
      setState(() {
        request.idExecute = !model.isCheck
            ? UserItem(name: '-')
            : UserItem(iD: model?.iD ?? null, name: model?.name ?? '-');
      });
    } else if (type ==
        _columnGroupRepository.filterColumnGroupData.supervisorType) {
      setState(() {
        request.idSupervisor = !model.isCheck
            ? UserItem(name: '-')
            : UserItem(iD: model?.iD ?? null, name: model?.name ?? '-');
      });
    } else if (type ==
        _columnGroupRepository.filterColumnGroupData.coExecuter) {
      setState(() {
        request.idCoExecute = !model.isCheck
            ? UserItem(name: '-')
            : UserItem(iD: model?.iD ?? null, name: model?.name ?? '-');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _columnGroupRepository,
      child: Consumer(
        builder: (context, ColumnGroupRepository repository, _) {
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
                    setState(() {
                      this.searchTextController.text = "";
                      this.setState(() {
                        this.request = GetListColumnGroupRequest();
                      });
                      this.widget.originRequest = GetListColumnGroupRequest();
                    });
                  },
                )
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        this._buildSearchView(),
                        TagLayoutWidget(
                          isShowClearText: true,
                          title: "Ngày bắt đầu",
                          value: isNotNullOrEmpty(request.startDate)
                              ? request.startDate
                              : "",
                          icon: Icons.date_range,
                          openFilterListener: () {
                            DatePicker.showDatePicker(context,
                                locale: LocaleType.vi, onConfirm: (date) {
                              this.setState(() {
                                request.startDate =
                                    DateFormat('dd-MM-yyyy').format(date);
                              });
                            });
                          },
                          openRemoveDataListener: () {
                            request.startDate = "";
                          },
                        ),
                        TagLayoutWidget(
                          isShowClearText: true,
                          title: "Ngày kết thúc",
                          value: isNotNullOrEmpty(request.endDate)
                              ? request.endDate
                              : "",
                          icon: Icons.calendar_today_sharp,
                          openFilterListener: () {
                            DatePicker.showDatePicker(context,
                                locale: LocaleType.vi, onConfirm: (date) {
                              this.setState(() {
                                request.endDate =
                                    DateFormat('dd-MM-yyyy').format(date);
                              });
                            });
                          },
                          openRemoveDataListener: () {
                            request.endDate = "";
                          },
                        ),
                        TagLayoutWidget(
                          title: "Trạng thái",
                          value: isNotNullOrEmpty(request.idStatus)
                              ? request.idStatus?.name
                              : "Tất cả",
                          icon: Icons.arrow_drop_down,
                          openFilterListener: () {
                            BottomSheetDialog(
                                    context: context,
                                    onTapListener: (item) {
                                      setState(() {
                                        if (item.isSelected) {
                                          request.idStatus = UserItem(
                                              iD: item.key, name: item.value);
                                        } else {
                                          request.idStatus = null;
                                        }
                                      });
                                    })
                                .showBottomSheetDialog(
                                    repository.filterColumnGroupData.statuses);
                          },
                        ),
                        TagLayoutWidget(
                          title: "Loại công việc",
                          value: isNotNullOrEmpty(request.type)
                              ? request.type.name
                              : "Tất cả",
                          icon: Icons.arrow_drop_down,
                          openFilterListener: () {
                            BottomSheetDialog(
                                    context: context,
                                    onTapListener: (item) {
                                      setState(() {
                                        if (item.isSelected) {
                                          request.type = UserItem(
                                              iD: item.key, name: item.value);
                                        } else {
                                          request.type = null;
                                        }
                                      });
                                    })
                                .showBottomSheetDialog(
                                    repository.filterColumnGroupData.types);
                          },
                        ),
                        TagLayoutWidget(
                          title: "Mức độ ưu tiên",
                          value: isNotNullOrEmpty(request.priority)
                              ? request.priority.name
                              : "Tất cả",
                          icon: Icons.arrow_drop_down,
                          openFilterListener: () {
                            BottomSheetDialog(
                                    context: context,
                                    onTapListener: (item) {
                                      setState(() {
                                        if (item.isSelected) {
                                          request.priority = UserItem(
                                              iD: item.key, name: item.value);
                                        } else {
                                          request.priority = null;
                                        }
                                      });
                                    })
                                .showBottomSheetDialog(repository
                                    .filterColumnGroupData.priorities);
                          },
                        ),
                        TagLayoutWidget(
                          title: "Người giao việc",
                          value: isNotNullOrEmpty(request.idCreatedBy)
                              ? request.idCreatedBy.name
                              : "-",
                          icon: Icons.arrow_drop_down,
                          openFilterListener: () {
                            this.openSearchFilterScreen(
                                repository.filterColumnGroupData.createdType,
                                "Người giao việc",
                                SharedSearchModel(iD: request.idCreatedBy?.iD));
                          },
                        ),
                        TagLayoutWidget(
                          title: "Người nhận việc",
                          value: isNotNullOrEmpty(request.idExecute)
                              ? request.idExecute?.name
                              : "-",
                          icon: Icons.arrow_drop_down,
                          openFilterListener: () {
                            this.openSearchFilterScreen(
                                repository.filterColumnGroupData.executerType,
                                "Người nhận việc",
                                SharedSearchModel(iD: request.idExecute?.iD));
                          },
                        ),
                        TagLayoutWidget(
                          title: "Người giám sát",
                          value: isNotNullOrEmpty(request.idSupervisor)
                              ? request.idSupervisor?.name
                              : "-",
                          icon: Icons.arrow_drop_down,
                          openFilterListener: () {
                            this.openSearchFilterScreen(
                                repository.filterColumnGroupData.supervisorType,
                                "Người giám sát",
                                SharedSearchModel(
                                    iD: request.idSupervisor?.iD));
                          },
                        ),
                        TagLayoutWidget(
                          title: "Người phối hợp",
                          value: isNotNullOrEmpty(request.idCoExecute)
                              ? request.idCoExecute?.name
                              : "-",
                          icon: Icons.arrow_drop_down,
                          openFilterListener: () {
                            this.openSearchFilterScreen(
                                repository.filterColumnGroupData.coExecuter,
                                "Người phối hợp",
                                SharedSearchModel(iD: request.idCoExecute?.iD));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: SaveButton(
                    onTap: () {
                      this.widget.onDoneFilter(request);
                      Navigator.of(context).pop();
                    },
                    title: "Áp dụng",
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchView() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(5),
        child: TextField(
          autocorrect: false,
          controller: searchTextController,
          onChanged: (value) {
            // _searchAction.action(value);
            request.jobName = value;
          },
          decoration: InputDecoration(
            hintText: 'Tìm kiếm tên công việc',
            prefixIcon: Icon(Icons.search),
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(25.7),
            ),
          ),
        ),
      ),
    );
  }
}

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
        'T??m ki???m $hint',
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
              title: Text("L???c"),
              leading: GestureDetector(
                onTap: () {
                  /* Write listener code here */
                },
                child: BackIconButton(),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Xo??",
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
                          title: "Ng??y b???t ?????u",
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
                          title: "Ng??y k???t th??c",
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
                          title: "Tr???ng th??i",
                          value: isNotNullOrEmpty(request.idStatus)
                              ? request.idStatus?.name
                              : "T???t c???",
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
                          title: "Lo???i c??ng vi???c",
                          value: isNotNullOrEmpty(request.type)
                              ? request.type.name
                              : "T???t c???",
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
                          title: "M???c ????? ??u ti??n",
                          value: isNotNullOrEmpty(request.priority)
                              ? request.priority.name
                              : "T???t c???",
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
                          title: "Ng?????i giao vi???c",
                          value: isNotNullOrEmpty(request.idCreatedBy)
                              ? request.idCreatedBy.name
                              : "-",
                          icon: Icons.arrow_drop_down,
                          openFilterListener: () {
                            this.openSearchFilterScreen(
                                repository.filterColumnGroupData.createdType,
                                "Ng?????i giao vi???c",
                                SharedSearchModel(iD: request.idCreatedBy?.iD));
                          },
                        ),
                        TagLayoutWidget(
                          title: "Ng?????i nh???n vi???c",
                          value: isNotNullOrEmpty(request.idExecute)
                              ? request.idExecute?.name
                              : "-",
                          icon: Icons.arrow_drop_down,
                          openFilterListener: () {
                            this.openSearchFilterScreen(
                                repository.filterColumnGroupData.executerType,
                                "Ng?????i nh???n vi???c",
                                SharedSearchModel(iD: request.idExecute?.iD));
                          },
                        ),
                        TagLayoutWidget(
                          title: "Ng?????i gi??m s??t",
                          value: isNotNullOrEmpty(request.idSupervisor)
                              ? request.idSupervisor?.name
                              : "-",
                          icon: Icons.arrow_drop_down,
                          openFilterListener: () {
                            this.openSearchFilterScreen(
                                repository.filterColumnGroupData.supervisorType,
                                "Ng?????i gi??m s??t",
                                SharedSearchModel(
                                    iD: request.idSupervisor?.iD));
                          },
                        ),
                        TagLayoutWidget(
                          title: "Ng?????i ph???i h???p",
                          value: isNotNullOrEmpty(request.idCoExecute)
                              ? request.idCoExecute?.name
                              : "-",
                          icon: Icons.arrow_drop_down,
                          openFilterListener: () {
                            this.openSearchFilterScreen(
                                repository.filterColumnGroupData.coExecuter,
                                "Ng?????i ph???i h???p",
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
                    title: "??p d???ng",
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
            hintText: 'T??m ki???m t??n c??ng vi???c',
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

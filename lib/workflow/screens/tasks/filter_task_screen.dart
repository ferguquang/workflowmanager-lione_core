import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/ui/bottom_sheet_dialog.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/params/filter_task_request.dart';
import 'package:workflow_manager/workflow/models/params/list_task_request.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';
import 'package:workflow_manager/workflow/screens/search_user/search_user_screen.dart';
import 'package:workflow_manager/workflow/screens/tasks/repository/filter_task_repository.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

// ignore: must_be_immutable
class FilterTaskScreen extends StatefulWidget {
  int viewType;

  final void Function(GetListTaskRequest) onDoneFilter;

  GetListTaskRequest originRequest;

  FilterTaskScreen({this.viewType, this.originRequest, this.onDoneFilter});

  @override
  State<StatefulWidget> createState() {
    return _FilterTaskScreen();
  }
}

class _FilterTaskScreen extends State<FilterTaskScreen> {
  final FilterTaskRepository _filterTaskRepository = FilterTaskRepository();
  TextEditingController searchTextController = TextEditingController();
  GetListTaskRequest request;

  @override
  void initState() {
    super.initState();
    if (this.widget.originRequest != null) {
      request = GetListTaskRequest.fromJson(this.widget.originRequest.toJson());
    }
    searchTextController.text = request.jobName;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //lấy dữ liệu màn hình filter
      FilterTaskRequest requestFilter = FilterTaskRequest();
      requestFilter.viewType = widget.viewType;
      _filterTaskRepository.getListFilterTask(requestFilter);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _filterTaskRepository,
      child: Consumer(
        builder: (context, FilterTaskRepository repository, _) {
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
                    // this._filterTaskRepository.resetFilter();
                    setState(() {
                      //sao lại có 2 setState ở đây, chứ ý check lại
                      this.searchTextController.text = "";
                      this.setState(() {
                        this.request = GetListTaskRequest();
                      });
                      this.widget.originRequest = GetListTaskRequest();
                      // this.widget.request = GetListTaskRequest();
                    });
                  },
                )
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          this._buildSearchView(),
                          TagLayoutWidget(
                            isShowClearText: true,
                            title: "Từ ngày",
                            value: isNotNullOrEmpty(request.startDate)
                                ? request.startDate
                                : "",
                            icon: Icons.date_range,
                            openFilterListener: () {
                              DatePicker.showDatePicker(context,
                                  locale: LocaleType.vi, onConfirm: (date) {
                                this.setState(() {
                                  request.startDate =
                                      DateFormat('dd/MM/yyyy').format(date);
                                });
                              });
                            },
                            openRemoveDataListener: () {
                              request.startDate = "";
                            },
                          ),
                          TagLayoutWidget(
                            isShowClearText: true,
                            title: "Đến ngày",
                            value: isNotNullOrEmpty(request.endDate)
                                ? request.endDate
                                : "",
                            icon: Icons.date_range,
                            openFilterListener: () {
                              DatePicker.showDatePicker(context,
                                  locale: LocaleType.vi, onConfirm: (date) {
                                this.setState(() {
                                  request.endDate =
                                      DateFormat('dd/MM/yyyy').format(date);
                                });
                              });
                            },
                            openRemoveDataListener: () {
                              request.endDate = "";
                            },
                          ),
                          Visibility(
                            visible: AppStore.isViewDeadLine == 1,
                            child: TagLayoutWidget(
                              title: "Trạng thái",
                              value: isNotNullOrEmpty(request.status)
                                  ? request.status.name
                                  : "Tất cả",
                              icon: Icons.arrow_drop_down,
                              openFilterListener: () {
                                BottomSheetDialog(
                                        context: context,
                                        onTapListener: (item) {
                                          this.setState(() {
                                            request.status = UserItem(
                                                iD: item.key, name: item.value);
                                          });
                                        })
                                    .showBottomSheetDialog(this
                                        ._filterTaskRepository
                                        .taskData
                                        .statuses);
                              },
                            ),
                          ),
                          TagLayoutWidget(
                            title: "Nhóm công việc",
                            value: isNotNullOrEmpty(request.idJobGroup)
                                ? request.idJobGroup.name
                                : "Tất cả",
                            icon: Icons.arrow_drop_down,
                            openFilterListener: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SearchUserScreen(
                                        isJobGroup: true,
                                        selectUserItem: request.idJobGroup,
                                        onUserSelected: (item) {
                                          this.setState(() {
                                            request.idJobGroup =
                                                item.isSelected ? item : null;
                                          });
                                        },
                                      )));
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
                                        this.setState(() {
                                          request.type = item.isSelected
                                              ? UserItem(
                                                  iD: item.key,
                                                  name: item.value)
                                              : null;
                                        });
                                      })
                                  .showBottomSheetDialog(this
                                      ._filterTaskRepository
                                      .taskData
                                      .types);
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
                                        this.setState(() {
                                          request.priority = item.isSelected
                                              ? UserItem(
                                                  iD: item.key,
                                                  name: item.value)
                                              : null;
                                        });
                                      })
                                  .showBottomSheetDialog(this
                                      ._filterTaskRepository
                                      .taskData
                                      .priorities);
                            },
                          ),
                          Visibility(
                            visible: this.widget.viewType == 1 ||
                                this.widget.viewType == 3,
                            child: TagLayoutWidget(
                              title: "Người giao việc",
                              value: isNotNullOrEmpty(request.idCreatedBy)
                                  ? request.idCreatedBy.name
                                  : "Tất cả",
                              icon: Icons.arrow_drop_down,
                              openFilterListener: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SearchUserScreen(
                                          isJobGroup: false,
                                          selectUserItem: request.idCreatedBy,
                                          onUserSelected: (item) {
                                            this.setState(() {
                                              request.idCreatedBy =
                                                  item.isSelected ? item : null;
                                            });
                                          },
                                        )));
                              },
                            ),
                          ),
                          Visibility(
                            visible: this.widget.viewType == 2 ||
                                this.widget.viewType == 3,
                            child: TagLayoutWidget(
                              title: "Người nhận việc",
                              value: isNotNullOrEmpty(request.idExecute)
                                  ? request.idExecute.name
                                  : "Tất cả",
                              icon: Icons.arrow_drop_down,
                              openFilterListener: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SearchUserScreen(
                                          isJobGroup: false,
                                          selectUserItem: request.idExecute,
                                          onUserSelected: (item) {
                                            print(item.name);
                                            this.setState(() {
                                              request.idExecute =
                                                  item.isSelected ? item : null;
                                            });
                                          },
                                        )));
                              },
                            ),
                          ),
                          TagLayoutWidget(
                            title: "Người giám sát",
                            value: isNotNullOrEmpty(request.idSupervisor)
                                ? request.idSupervisor.name
                                : "Tất cả",
                            icon: Icons.arrow_drop_down,
                            openFilterListener: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SearchUserScreen(
                                        isJobGroup: false,
                                        selectUserItem: request.idSupervisor,
                                        onUserSelected: (item) {
                                          print(item.name);
                                          this.setState(() {
                                            request.idSupervisor =
                                                item.isSelected ? item : null;
                                          });
                                        },
                                      )));
                            },
                          ),
                          TagLayoutWidget(
                            title: "Người phối hợp",
                            value: isNotNullOrEmpty(request.idCoExecute)
                                ? request.idCoExecute.name
                                : "Tất cả",
                            icon: Icons.arrow_drop_down,
                            openFilterListener: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SearchUserScreen(
                                        isJobGroup: false,
                                        selectUserItem: request.idCoExecute,
                                        onUserSelected: (item) {
                                          print(item.name);
                                          this.setState(() {
                                            request.idCoExecute =
                                                item.isSelected ? item : null;
                                          });
                                        },
                                      )));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 48,
                    margin: EdgeInsets.all(16),
                    child: RaisedButton(
                        child: Text("Áp dụng".toUpperCase(),
                            style:
                                TextStyle(fontSize: 14, color: Colors.white)),
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {
                          this.widget.onDoneFilter(request);
                          Navigator.of(context).pop();
                        }),
                  )
                ],
              ),
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

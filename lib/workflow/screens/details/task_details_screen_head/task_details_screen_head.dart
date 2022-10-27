import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';
import 'package:workflow_manager/workflow/models/response/task_detail_response.dart';
import 'package:workflow_manager/workflow/screens/create_job/list_create_job_member_screen.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/attach_files_screen.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/file_response.dart';
import 'package:workflow_manager/workflow/screens/details/details_screen_main/task_details_screen.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/update_progress.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/vote_screen.dart';
import 'package:workflow_manager/workflow/screens/details/sub_task/sub_task_screen.dart';
import 'package:workflow_manager/workflow/screens/details/task_details_screen_head/task_details_screen_head_provider.dart';
import 'package:workflow_manager/workflow/screens/details/todo_work/todo_work_screen.dart';
import 'package:workflow_manager/workflow/screens/details/transfer/transfer_job/transfer_job_screen.dart';
import 'package:workflow_manager/workflow/screens/details/transfer/transfer_person_new_screen.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/list_column_group_tab_screen.dart';
import 'package:workflow_manager/workflow/screens/tasks/repository/list_task_repository.dart';
import 'package:workflow_manager/workflow/widgets/change_status/change_status.dart';
import 'package:workflow_manager/workflow/widgets/change_status/change_updefined_state_reponse.dart';
import 'package:workflow_manager/workflow/widgets/change_status/custom_transfer_status_job_dialog.dart';

import '../approval_extension_screen/approval_extension_screen.dart';
import '../back_detail_data.dart';
import '../details_provider.dart';
import '../flow_chart.dart';

class TaskDetailsHeader extends StatefulWidget {
  TaskDetailModel taskDetailModel;
  Function onDataChanged;

  TaskDetailsHeader(this.taskDetailModel, {this.onDataChanged});

  @override
  State<StatefulWidget> createState() {
    return _TaskDetailsHeaderState();
  }
}

enum ExtensionState { None, Add, Waiting, Approve }

class _TaskDetailsHeaderState extends State<TaskDetailsHeader> {
  double blockPadding = 20;
  TaskDetailsHeadProvider _detailsHeadProvider;
  bool visibleViewMore = false;
  GlobalKey _keyDescription = GlobalKey();
  ListTaskRepository _listTaskRepository = ListTaskRepository();
  PersistentBottomSheetController _bottomSheetController;
  double groupPadding = 16;
  int viewType;
  bool isStatusChange = false;

  @override
  void initState() {
    // eventBus.on<TaskDetailModel>().listen((event) {
    //   _detailsHeadProvider.changeTaskDetailModel(event);
    // });
    super.initState();
    viewType = widget.taskDetailModel.viewType;
    _detailsHeadProvider =
        TaskDetailsHeadProvider(widget.taskDetailModel, viewType);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        visibleViewMore = _keyDescription.currentContext.size.height ==
            _defaultJobDescriptionHeight;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _detailsHeadProvider.changeTaskDetailModel(widget.taskDetailModel);
    return ChangeNotifierProvider.value(
        value: _detailsHeadProvider,
        child: Consumer(
          builder: (context, TaskDetailsHeadProvider taskDetailsHeadProvider,
              child) {
            return SafeArea(
                child: Padding(
              padding: EdgeInsets.all(groupPadding),
              child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    MultiProvider(
                      providers: [
                        ChangeNotifierProvider<DetailsProvider>(
                            create: (context) => DetailsProvider())
                      ],
                      child: Consumer(builder:
                          (context, DetailsProvider detailsProvider, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(bottom: groupPadding),
                                child: Text(
                                    _detailsHeadProvider
                                            .taskDetailModel.job.name ??
                                        "",
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black))),
                            _getJobInfos(),
                            _getState(),
                            _getJobDescription(),
                            _getAttachFile(),
                            _getToDoWork(),
                            _getSubJob(),
                            _getLargerLine()
                          ],
                        );
                      }),
                    )
                  ]),
            ));
          },
        ));
  }

  void _getListStatus() async {
    await _listTaskRepository.getListStatus(
        _detailsHeadProvider?.taskDetailModel?.jobStatus?.key, viewType);
    if (_listTaskRepository?.statusData?.result?.length == 0) {
      ToastMessage.show('Trạng thái không được chuyển', ToastStyle.error);
      return;
    }
    // print('item: ${_detailsHeadProvider.taskDetailModel.job.iD}');
    _bottomSheetController = (context
            .findAncestorWidgetOfExactType<Scaffold>()
            .key as GlobalKey<ScaffoldState>)
        .currentState
        .showBottomSheet(
          (_) => SizedBox(
            child: Wrap(
              children: <Widget>[
                ChangeStatusView(
                  listStatus: _listTaskRepository.statusData.result,
                  onStatusSelected: (item) async {
                    if (item.isPopup) {
                      ChangeUndefinedStatusModel data =
                          await CustomTransferStatusJobDialog(context)
                              .showCustomDialog(
                                  _detailsHeadProvider.taskDetailModel.job.iD,
                                  _detailsHeadProvider
                                      .taskDetailModel.jobGroup.iD,
                              SharedSearchModel(iD: _detailsHeadProvider.taskDetailModel.job.iDExecutor,name: _detailsHeadProvider.taskDetailModel.executer),
                              _detailsHeadProvider.taskDetailModel.job?.endDate?.toDateTimeFormat(format:Constant.ddMMyyyyHHmm));
                      if (data != null) {
                        // _detailsHeadProvider.changeWhenBack(BackDetailData(
                        //     newTransferJobId: id, statusItem: item));
                        context
                            .findAncestorWidgetOfExactType<TaskDetailsScreen>()
                            .reloadData();
                        _bottomSheetController.close();
                        if (isNotNullOrEmpty(widget.onDataChanged)) {
                          widget.onDataChanged();
                        }
                      }
                    } else if (item.isRate) {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) {
                            return VoteScreen(
                              vote: 0,
                              jobId:
                                  _detailsHeadProvider.taskDetailModel.job.iD,
                              onTap: (value) {},
                              onTaskVoted: (newStatus, rate) {
                                _bottomSheetController.close();
                                // BackDetailData backData = BackDetailData(
                                //     ratings: rate, statusItem: newStatus);
                                // _detailsHeadProvider.changeWhenBack(backData);
                                context
                                    .findAncestorWidgetOfExactType<
                                        TaskDetailsScreen>()
                                    .reloadData();
                                if (isNotNullOrEmpty(widget.onDataChanged)) {
                                  widget.onDataChanged();
                                }
                              },
                            );
                          });
                    } else {
                      this._showConfirmDialog(item.key, item.value, item.key);
                    }
                  },
                )
              ],
            ),
          ),
        );
  }

  BuildContext getContext() {
    return context;
  }

  void _showConfirmDialog(int idStatus, String status, int statusKey) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content:
                new Text('Bạn muốn chuyển trạng thái công việc này không?'),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  "Đóng",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text(
                  "Xác nhận",
                ),
                onPressed: () async {
                  var statusItem = await _listTaskRepository.changeTaskStatus(
                      _detailsHeadProvider.taskDetailModel.job.iD, idStatus);
                  if (statusItem != null) {
                    // _detailsHeadProvider.changeStatus(statusItem);
                    getContext()
                        .findAncestorWidgetOfExactType<TaskDetailsScreen>()
                        .reloadData();
                    _bottomSheetController.close();
                    Navigator.of(context).pop();
                    if (isNotNullOrEmpty(widget.onDataChanged)) {
                      widget.onDataChanged();
                    }
                  }
                },
              ),
            ],
          );
        });
  }

  var textColor = TextStyle(color: "242424".toColor());
  var labelTextColor = TextStyle(color: "555555".toColor());

  showVoteDialog(double value) {
    return;
  }

  showUpdateProgress() async {
    if (viewType != 1) return;

    List<int> status = [2, 3, 6];
    if (!status.contains(_detailsHeadProvider.taskDetailModel.job.status)) {
      ToastMessage.show(
          "Bạn không thể cập nhập tiến độ của công việc này", ToastStyle.error);
      return;
    }
    showModalBottomSheet(
      isDismissible: false,
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: UpdateProgressDialog(
            progress: _detailsHeadProvider.taskDetailModel.job.percentCompleted,
            onProgressChanged: (value) async {
              bool isCompleted =
                  _detailsHeadProvider.taskDetailModel.job.percentCompleted ==
                      100;
              var response = await _detailsHeadProvider.updateProgress(
                  _detailsHeadProvider.taskDetailModel.job.iD,
                  (value * 100).toInt());
              if (response == true) {
                StatusItem statusItem;
                // if(_detailsHeadProvider.taskDetailModel.job.type==1) {
                if (value == 1) {
                  statusItem = await _listTaskRepository.changeTaskStatus(
                      _detailsHeadProvider.taskDetailModel.job.iD, 6);
                } else if (value > 0 &&
                        _detailsHeadProvider.taskDetailModel.jobStatus.key ==
                            2 ||
                    (_detailsHeadProvider.taskDetailModel.jobStatus.key == 6 &&
                        value < 1) ||
                    (value > 0 &&
                        _detailsHeadProvider.taskDetailModel.jobStatus.key ==
                            3) ||
                    (value < 1 &&
                        _detailsHeadProvider.taskDetailModel.jobStatus.key ==
                            3)) {
                  statusItem = await _listTaskRepository.changeTaskStatus(
                      _detailsHeadProvider.taskDetailModel.job.iD, 3);
                }
                if (statusItem != null) {
                  _detailsHeadProvider.changeStatus(statusItem);
                  if (widget.onDataChanged != null) {
                    widget.onDataChanged();
                  }
                }
                // }
                Navigator.pop(context);
              }
            },
          )),
    );
  }

  showChangeStatus() async {
    _getListStatus();
  }

  Widget _getJobInfos() {
    return Column(children: [
      _buildRow(Icons.clear_all, "Độ ưu tiên", "",
          contentWidget: _getPriorityText(
              _detailsHeadProvider.taskDetailModel.job.priority)),
      _buildRow(
          Icons.access_time_rounded,
          "",
          _detailsHeadProvider.taskDetailModel.job.startDate
                  .toDateTimeFormat() +
              " - " +
              _detailsHeadProvider.taskDetailModel.job.endDate
                  .toDateTimeFormat(),
          rightWidget: Visibility(
            visible: widget.taskDetailModel.jobStatus.key != 6 &&
                widget.taskDetailModel.jobStatus.key !=
                    7, // trạng thái công việc không phải hoàn thanh hoặc xác nhận đã đóng
            child: Text(
              _detailsHeadProvider.extensionState == ExtensionState.None
                  ? ""
                  : (_detailsHeadProvider.extensionState ==
                          ExtensionState.Approve
                      ? "Duyệt gia hạn"
                      : _detailsHeadProvider.extensionState ==
                              ExtensionState.Add
                          ? "Xin gia hạn"
                          : "Chờ phê duyệt"),
              style: TextStyle(color: "00689D".toColor()),
            ),
          ), onExtendTap: () async {
        if (viewType == 3) return;
        BackDetailData data = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ApprovalExtensionScreen(
                viewType,
                _detailsHeadProvider.taskDetailModel.job.iD,
                jobExtension: _detailsHeadProvider.taskDetailModel.jobExtension,
                startDate: _detailsHeadProvider.taskDetailModel.job.startDate,
              ),
            ));
        if (data != null) {
          context
              .findAncestorWidgetOfExactType<TaskDetailsScreen>()
              .reloadData();
        }
      }),
      _buildRow(null, "Người giao việc",
          _detailsHeadProvider.taskDetailModel.assigner,
          imagePath: "assets/images/ic-person.png"),
      _buildRow(Icons.how_to_reg_rounded, "Người nhận việc",
          _detailsHeadProvider.taskDetailModel.executer,
          rightWidget: InkWell(
            child: Visibility(
              visible: _detailsHeadProvider?.taskDetailModel?.viewType == 2 &&
                  _detailsHeadProvider.canChangeExecuter(),
              child: Icon(
                Icons.edit,
                size: 16,
                color: "939BA2".toColor(),
              ),
            ),
            onTap: () async {
              Job jobData = _detailsHeadProvider?.taskDetailModel?.job;
              List<int> listStatus1 = [3, 6];
              List<int> listStatus2 = [2, 4, 5, 8];
              if (listStatus1.contains(jobData.status)) {
                String sID = jobData.iD.toString();
                String sIDCoexecutor = jobData.iDCoexecutor.toString();
                String sIDSupervisor = jobData.iDSupervisor.toString();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransferJobScreen(
                          sID,
                          sIDCoexecutor,
                          sIDSupervisor,
                          _detailsHeadProvider?.taskDetailModel?.executer ??
                              '--',
                          _detailsHeadProvider.taskDetailModel.jobGroup.iD),
                    ));
              } else if (listStatus2.contains(jobData.status)) {
                var backData = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransferPersonNewScreen(
                          jobData.iD,
                          jobData.iDCoexecutor.toString(),
                          jobData.iDSupervisor.toString(),
                          _detailsHeadProvider.taskDetailModel.jobGroup.iD),
                    ));
                if (backData != null) {
                  TaskDetailsScreen screen = context
                      .findAncestorWidgetOfExactType<TaskDetailsScreen>();
                  screen.taskId = backData.newTransferJobId;
                  screen.reloadData();
                }
              }
            },
          )),
      _buildRow(
        Icons.remove_red_eye,
        "Người giám sát",
        _convertListArrayToString(
            _detailsHeadProvider?.taskDetailModel?.supervisors),
        showUpdate: _detailsHeadProvider?.taskDetailModel?.isEdit,
        onUpdateCoExecAndSup: () {
          this._eventClickMultipleUser(true, []);
        },
      ),
      _buildRow(
        Icons.person_add_alt_1_sharp,
        "Người phối hợp",
        _convertListArrayToString(
            _detailsHeadProvider.taskDetailModel?.coExcuters),
        showUpdate: _detailsHeadProvider.taskDetailModel.isEdit,
        onUpdateCoExecAndSup: () {
          this._eventClickMultipleUser(false, []);
        },
      ),
      _buildRow(Icons.people_outline_sharp, "", "",
          contentWidget: RichText(
            text: TextSpan(children: [
              TextSpan(text: "Nhóm công việc: ", style: labelTextColor),
              TextSpan(
                text:
                    _detailsHeadProvider?.taskDetailModel?.jobGroup?.name ?? "--",
                style: TextStyle(
                    decoration: isNotNullOrEmpty(
                            _detailsHeadProvider?.taskDetailModel?.jobGroup?.name)
                        ? TextDecoration.underline
                        : null,
                    decorationColor: isNotNullOrEmpty(
                            _detailsHeadProvider?.taskDetailModel?.jobGroup?.name)
                        ? Colors.blue
                        : null,
                    color: isNotNullOrEmpty(
                            _detailsHeadProvider?.taskDetailModel?.jobGroup?.name)
                        ? Colors.blue
                        : getColor('#242424'),
                    fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    if (isNotNullOrEmpty(
                            _detailsHeadProvider?.taskDetailModel?.jobGroup) &&
                        isNotNullOrEmpty(_detailsHeadProvider
                            ?.taskDetailModel?.jobGroup?.iD) &&
                        _detailsHeadProvider?.taskDetailModel?.jobGroup?.iD !=
                            0) {
                      pushPage(
                          this.context,
                          ListColumnGroupTabScreen(
                            idGroup: _detailsHeadProvider
                                .taskDetailModel.jobGroup.iD,
                            nameGroupJob: _detailsHeadProvider
                                .taskDetailModel.jobGroup.name,
                          ));
                    }
                  },
              )
            ]),
          )),
      Visibility(
        visible: isNotNullOrEmpty(_detailsHeadProvider?.taskDetailModel?.kanbanName),
        child: _buildRow(
          Icons.email,
          "Cột kanban",
          "${_detailsHeadProvider?.taskDetailModel?.kanbanName ?? "--"}",
          imagePath: 'assets/images/kanban.png',
        ),
      ),
      _buildRow(
        Icons.email,
        "Loại công việc",
        "${_detailsHeadProvider?.taskDetailModel?.job?.type == 1 ? "Thông thường" : "Theo quy trình"}",
        imagePath: 'assets/images/type_job.png',
      ),
      Visibility(
          visible: (_detailsHeadProvider?.taskDetailModel?.job?.type ?? 1) == 2,
          child: _buildRow(Icons.insert_chart_outlined, "", null,
              contentWidget: InkWell(
                child: Text("Lưu đồ", style: TextStyle(color: Colors.blue)),
                onTap: () async {
                  if (isNotNullOrEmpty(
                      _detailsHeadProvider?.taskDetailModel?.urlJobFlow)) {
                    String url =
                        "${_detailsHeadProvider?.taskDetailModel?.urlJobFlow}&Token=${await SharedPreferencesClass.getToken()}";
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FlowChart(url),
                        ));
                  }
                },
              ))),
      _buildRow(
          Icons.access_time_rounded,
          "Ngày bắt đầu thực tế",
          isNullOrEmpty(_detailsHeadProvider.taskDetailModel.job.started
                  .toDateTimeFormat())
              ? "--"
              : _detailsHeadProvider.taskDetailModel.job.started
                  .toDateTimeFormat()),
      Visibility(
          visible: [6, 7, 11]
              .contains(_detailsHeadProvider?.taskDetailModel?.jobStatus?.key),
          child: _buildRow(
              Icons.access_time_rounded,
              "Ngày kết thúc thực tế",
              isNullOrEmpty(_detailsHeadProvider.taskDetailModel.job.finished
                      .toDateTimeFormat())
                  ? "--"
                  : _detailsHeadProvider.taskDetailModel.job.finished
                      .toDateTimeFormat())),
    ]);
  }

  Widget _getState() {
    double padding = 8;
    double titlePadding = 10;
    double height = 40;

    return Row(
      children: [
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(
                    top: groupPadding,
                    right: groupPadding,
                    bottom: groupPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Trạng thái"),
                    Padding(
                        padding: EdgeInsets.only(top: titlePadding),
                        child: InkWell(
                            onTap: () {
                              if (viewType == 3) return;
                              showChangeStatus();
                            },
                            child: Container(
                                height: height,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: _detailsHeadProvider
                                        ?.taskDetailModel?.jobStatus?.color
                                        ?.toColor(),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: Text(
                                  (_detailsHeadProvider?.taskDetailModel
                                              ?.jobStatus?.value ??
                                          "--")
                                      .toUpperCase(),
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.white),
                                ))))
                  ],
                ))),
        Expanded(
            child: Padding(
                padding: EdgeInsets.only(
                    top: groupPadding,
                    right: groupPadding,
                    bottom: groupPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Tiến độ"),
                    Padding(
                      padding: EdgeInsets.only(top: titlePadding),
                      child: InkWell(
                        onTap: () {
                          showUpdateProgress();
                        },
                        child: Stack(alignment: Alignment.center, children: [
                          Container(
                            height: height,
                            child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                child: LinearProgressIndicator(
                                  backgroundColor: "D9EEE8".toColor(),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      "28A745".toColor()),
                                  value: _detailsHeadProvider.taskDetailModel
                                          .job.percentCompleted /
                                      100,
                                )),
                          ),
                          Text(
                            "${_detailsHeadProvider.taskDetailModel.job.percentCompleted.toInt()}%",
                            style: TextStyle(color: Colors.black),
                          ),
                        ]),
                      ),
                    )
                  ],
                ))),
        Expanded(
            child: InkWell(
                // onTap: () {
                //   showVoteDialog(_detailsHeadProvider.taskDetailModel.job.rating);
                // },
                child: Padding(
                    padding: EdgeInsets.only(
                        top: groupPadding, bottom: groupPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Đánh giá"),
                        Padding(
                            padding: EdgeInsets.only(top: titlePadding),
                            child: Container(
                                height: height,
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: "DDDDDD".toColor()),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),
                                child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        child: FittedBox(
                                            child: RatingBar.builder(
                                          ignoreGestures: true,
                                          // custom gì thì custom hết ở đây
                                          initialRating: _detailsHeadProvider
                                              .taskDetailModel.job.rating
                                              .toDouble(),
                                          itemCount: 5,
                                          allowHalfRating: true,
                                          itemPadding: EdgeInsets.all(0),
                                          direction: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            );
                                          },
                                        ))))))
                      ],
                    )))),
      ],
    );
  }

  double _defaultJobDescriptionHeight = 100;

  double _jobDescriptionheight = 100;
  bool expand = false;

  Widget _getJobDescription() {
    var document =
        parse(_detailsHeadProvider.taskDetailModel.job.describe.trim())
            .body
            .text; // dùng để xóa thẻ html
    return Padding(
        padding: EdgeInsets.symmetric(vertical: blockPadding),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _getBlockTitle("Mô tả công việc", null),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // AnimateContent(key:_jobDescriptionKey,expand: expand, child: ,minHeight: 100,),
            Container(
                constraints: BoxConstraints(maxHeight: _jobDescriptionheight),
                child: Text(document ?? ""),
                key: _keyDescription),
            Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      expand = !expand;
                      // (_jobDescriptionKey.currentWidget as AnimateContent)
                      //     .toggle();
                      _jobDescriptionheight =
                          _jobDescriptionheight != _defaultJobDescriptionHeight
                              ? _defaultJobDescriptionHeight
                              : double.infinity;
                    });
                  },
                  child: Visibility(
                    visible: visibleViewMore,
                    child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(expand ? "Thu gọn" : "Xem thêm")),
                  ),
                ))
          ])
        ]));
  }

  double oneRowPadding = 18;

  _attachFile() {}

  Widget _getAttachFile() {
    return _getOneRow(
        "Tệp Đính kèm",
        "Danh sách file đính kèm",
        _detailsHeadProvider.taskDetailModel.totalJobFile,
        _attachFile, () async {
      List<FileModel> data = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AttachFilesScreen(AttachFileType.task_detail,
            id: _detailsHeadProvider.taskDetailModel.job.iD,
            taskType: viewType),
      ));
      if (data != null) {
        context.findAncestorWidgetOfExactType<TaskDetailsScreen>().reloadData();
      }
    });
  }

  Widget _getToDoWork() {
    return _getOneRow("Công việc cần làm", "Danh sách công việc cần làm",
        _detailsHeadProvider.taskDetailModel.totalJobDetail, () {
      ToastMessage.show("Tạo công việc cần làm", ToastStyle.error);
    }, () async {
      BackDetailData data = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ToDoWorkScreen(
            _detailsHeadProvider.taskDetailModel.job.iD, viewType),
      ));
      if (data != null) {
        context.findAncestorWidgetOfExactType<TaskDetailsScreen>().reloadData();
      }
    });
  }

  Widget _getSubJob() {
    return _getOneRow("Công việc con", "Danh sách công việc con",
        _detailsHeadProvider.taskDetailModel.totalChildrenJob, () {
      ToastMessage.show("Tạo công việc con", ToastStyle.error);
    }, () async {
      print(
          'ID công việc chaaaaaaaaaaaa _ ${_detailsHeadProvider?.taskDetailModel?.job?.parent}');
      BackDetailData data = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SubTaskScreen(
            _detailsHeadProvider.taskDetailModel.job.iD,
            viewType,
            _detailsHeadProvider.taskDetailModel.job.iDGroupJob,
            _detailsHeadProvider.taskDetailModel.job.iDGroupJobCol,
            _detailsHeadProvider.taskDetailModel.job.parent),
      ));
      if (data != null) {
        context.findAncestorWidgetOfExactType<TaskDetailsScreen>().reloadData();
      }
    });
  }

  Widget _getOneRow(String title, String content, int count,
      GestureTapCallback onTap, GestureTapCallback onListTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _getLargerLine(),
        // _getBlockTitle(title, onTap),
        InkWell(
            onTap: onListTap,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: oneRowPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Text(content,
                              style: TextStyle(color: "00689D".toColor())),
                          Container(
                            margin: EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                color: "DFEAFB".toColor(),
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 10),
                                child: Text("$count")),
                          )
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: "939BA2".toColor(),
                      size: 15,
                    ),
                  ],
                )))
      ],
    );
  }

  Widget _getBlockTitle(String text, GestureTapCallback onTap) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _getLargerLine(),
              Padding(
                  padding: EdgeInsets.only(top: blockPadding),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Text(text.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                ))),
                        // Visibility(
                        //     visible: onTap != null && taskType != 2,
                        //     child: InkWell(
                        //       onTap: onTap,
                        //       child: Icon(Icons.add),
                        //     ))
                      ]))
            ],
          ),
        ),
      ],
    );
  }

  Widget _getLargerLine() {
    return Container(
      color: "E9ECEF".toColor(),
      height: 4,
    );
  }

  Widget _buildRow(
    IconData icon,
    String label,
    String content, {
    String rightContent,
    contentWidget,
    GestureTapCallback onExtendTap,
    Widget rightWidget,
    String imagePath,
    bool showUpdate,
    GestureTapCallback onUpdateCoExecAndSup,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: groupPadding, top: 4, bottom: 4),
          child: imagePath == null
              ? Icon(
                  icon ?? Icons.email,
                  size: 18,
                  color: "939BA2".toColor(),
                )
              : Image.asset(
                  imagePath,
                  width: 18,
                  height: 18,
                ),
        ),
        Text(
          isNullOrEmpty(label) ? "" : label + ": ",
          style: labelTextColor,
        ),
        Expanded(
            child: contentWidget ??
                Text(
                  content ?? "",
                  style: textColor,
                )),
        InkWell(
          child: rightWidget ?? Text(rightContent ?? ""),
          onTap: onExtendTap,
        ),
        Visibility(
          visible: showUpdate == true ? true : false,
          child: InkWell(
            child: Icon(
              Icons.edit,
              size: 16,
              color: "939BA2".toColor(),
            ),
            onTap: onUpdateCoExecAndSup,
          ),
        ),
      ],
    );
  }

  Widget _getPriorityText(int priority) {
    switch (priority) {
      case 1:
        return Text("Thấp");
      case 2:
        return Text("Trung bình");
      default:
        return Text("Cao", style: TextStyle(color: Colors.red.withAlpha(180)));
    }
  }

  String _convertListArrayToString(List<String> listUsers) {
    String results = "";
    results = listUsers.join(", ");
    return results;
  }

  // người giám sát, người phối hợp
  _eventClickMultipleUser(
      bool isType, List<SharedSearchModel> listSelected) async {
    FocusScope.of(context).unfocus();

    List<SharedSearchModel> selectedUsers = new List<SharedSearchModel>();

    if (isType) {
      for (int i = 0;
          i < _detailsHeadProvider.taskDetailModel.supervisors.length;
          i++) {
        SharedSearchModel model = new SharedSearchModel();
        model.iD = _detailsHeadProvider.taskDetailModel.idSupervisors[i];
        model.name = _detailsHeadProvider.taskDetailModel.supervisors[i];
        selectedUsers.add(model);
      }
    } else {
      for (int i = 0;
          i < _detailsHeadProvider.taskDetailModel.coExcuters.length;
          i++) {
        SharedSearchModel model = new SharedSearchModel();
        model.iD = _detailsHeadProvider.taskDetailModel.idCOExcuters[i];
        model.name = _detailsHeadProvider.taskDetailModel.coExcuters[i];
        selectedUsers.add(model);
      }
    }

    Map<String, dynamic> params = new Map<String, dynamic>();
    params["IDGroupJob"] = this.widget.taskDetailModel.jobGroup.iD;
    params["IDExecuter"] = this.widget.taskDetailModel?.job?.iDExecutor ?? 0;
    // =1 để bỏ chưa xác định trong list
    params["IsExclusionUDF"] = '1';

    pushPage(
        context,
        ListCreateJobMemberScreen(
          params,
          selectedUsers,
          isType,
          onSharedSearchSelected: (listCheck) async {
            // hàm isNotNullOrEmpty không dùng dc do chỉ cần check null và
            // list này không bắt buộc lên có thể length = 0
            // chạy vào setState khi nhấn button lưu
            if (listCheck != null) {
              List<String> ids = [];
              for (int i = 0; i < listCheck.length; i++) {
                ids.add("${listCheck[i].iD}");
              }
              if (ids.length == 0) {
                ids.add("0");
              }
              await this._detailsHeadProvider.changeJobCoExcuteAndSupervisors(
                  _detailsHeadProvider.taskDetailModel.job.iD, isType, ids);

              context
                  .findAncestorWidgetOfExactType<TaskDetailsScreen>()
                  .reloadData();
            }
          },
        ));
  }
}

class OnJobStatusChanged {
  int viewType;

  OnJobStatusChanged(this.viewType);
}
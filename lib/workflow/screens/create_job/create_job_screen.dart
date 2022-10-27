import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/number_group_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/workflow/models/params/create_job_request.dart';
import 'package:workflow_manager/workflow/models/params/get_data_for_create_job_request.dart';
import 'package:workflow_manager/workflow/models/params/get_data_for_edit_request.dart';
import 'package:workflow_manager/workflow/models/response/filter_task_response.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_edit_respone.dart';
import 'package:workflow_manager/workflow/screens/create_job/selected_multiple_screen/selected_multiple_screen.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/attach_files_screen.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/file_response.dart';
import 'package:workflow_manager/workflow/screens/details/transfer/transfer_job/transfer_job_screen.dart';
import 'package:workflow_manager/workflow/screens/details/transfer/transfer_person_new_screen.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/shared_search_screen/shared_search_screen.dart';
import 'package:workflow_manager/workflow/widgets/change_status/change_updefined_state_reponse.dart';
import 'package:workflow_manager/workflow/widgets/change_status/custom_transfer_status_job_dialog.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

import 'create_job_repository.dart';

class CreateJobScreen extends StatefulWidget {
  bool isCreate = true;

  // iD nhóm CV, ID column kanban, id cv cha, id cv
  int sIDJobGroup;
  int sIDJobGroupCol;
  int sIDParent;
  int sJobID;

  CreateJobScreen(this.isCreate, this.sIDJobGroup, this.sIDJobGroupCol,
      this.sIDParent, this.sJobID);

  @override
  State<StatefulWidget> createState() {
    return _CreateJobScreenState();
  }
}

class _CreateJobScreenState extends State<CreateJobScreen> {
  CreateJobRequest request;

  CreateJobRepository _createJobRepository = CreateJobRepository();

  TextEditingController nameController = TextEditingController();
  TextEditingController describeController = TextEditingController();

  List<FileModel> files = List<FileModel>();

  bool isShowColKanban = false;
  int iSizeStatus;
  bool isCheckPermission = false;

  getDataForEdit() async {
    GetDataForEditRequest requestEdit = GetDataForEditRequest();
    requestEdit.sIDJob = widget.sJobID.toString();
    isCheckPermission = await _createJobRepository.getDataForEdit(requestEdit);

    request.groupJob = _createJobRepository.jobGroups;
    request.groupJobCol = _createJobRepository.groupJobCol;
    request.executor = _createJobRepository.jobRecipient;
    request.supervisor = _createJobRepository.supervisor;
    request.coexecutor = _createJobRepository.coordinator;
    nameController.text = _createJobRepository.modelEdit?.job?.name;

    describeController.text = _createJobRepository.modelEdit.job?.describe;
    request.startDate =
        getDateTime(_createJobRepository.modelEdit.job?.startDate);
    request.endDate =
        getDateTime(_createJobRepository.modelEdit.job?.endDate);
    request.priority = _createJobRepository.priorities;
    request.status = _createJobRepository.status;
    iSizeStatus = _createJobRepository.modelEdit.listStatus?.length;

    widget.sIDJobGroup = _createJobRepository.jobGroups.iD;
    widget.sIDJobGroupCol = _createJobRepository.groupJobCol.iD;
    print(
        "AAAAA2 sIDJobGroup = ${widget.sIDJobGroup} - sIDJobGroupCol = ${widget.sIDJobGroupCol}");
    if (widget.sIDJobGroup == 0) {
      isShowColKanban = false;
    } else {
      isShowColKanban = true;
    }
  }

  getDataForCreateJob() async {
    GetDataForCreateJobRequest requestCreate = GetDataForCreateJobRequest();
    requestCreate.sIDJobGroup = widget.sIDJobGroup.toString();
    requestCreate.sIDJobGroupCol = widget.sIDJobGroupCol.toString();
    isCheckPermission =
        await _createJobRepository.getDataForCreateJob(requestCreate);
    request.groupJob = _createJobRepository.jobGroups;
    request.groupJobCol = _createJobRepository.groupJobCol;
    request.executor = _createJobRepository.jobRecipient;
    request.supervisor = _createJobRepository.supervisor;
    request.coexecutor = _createJobRepository.coordinator;
  }

  @override
  void initState() {
    super.initState();
    print(
        "AAAAA sIDJobGroup = ${widget.sIDJobGroup} - sIDJobGroupCol = ${widget.sIDJobGroupCol}");
    if (widget.sIDJobGroup == 0) {
      isShowColKanban = false;
    } else {
      isShowColKanban = true;
    }
    request = CreateJobRequest();
    if (widget.isCreate) {
      request.isCreate = true;
      request.startDate = getCurrentDate(Constant.ddMMyyyyHHmm);
      // lấy list mức dộ ưu tiên
      getDataForCreateJob();
    } else {
      request.isCreate = false;
      getDataForEdit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _createJobRepository,
        child: Consumer(
          builder: (context, CreateJobRepository _createJobRepository, child) {
            return Scaffold(
              appBar: AppBar(
                toolbarHeight: widget.sIDJobGroup == 0 &&
                        widget.sIDJobGroupCol == 0 &&
                        widget.sIDParent == 0 &&
                        widget.sJobID == 0
                    ? 0
                    : 55,
                title: Text(
                  widget.isCreate ? 'Tạo công việc' : 'Sửa công việc',
                ),
              ),
              body: SafeArea(
                  child: isCheckPermission
                      ? _allWidget()
                      : EmptyScreen(
                          message: _createJobRepository.messageError)),
            );
          },
        ));
  }

  Widget _allWidget() {
    return Column(
      children: [
        Expanded(
            child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanDown: (_) {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                // tên công việc
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text("Tên công việc"),
                          Text(
                            "*",
                            style: TextStyle(color: Colors.red),
                          )
                        ],
                      ),
                      TextField(
                        controller: nameController,
                        style: TextStyle(fontSize: 14),
                      )
                    ],
                  ),
                ),
                // mô tả
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, bottom: 8, right: 16),
                  child: TextField(
                    // textInputAction: TextInputAction.done,
                    // keyboardType: TextInputType.multiline,
                    controller: describeController,
                    maxLines: null,
                    decoration: InputDecoration(
                      labelText: 'Mô tả',
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300])),
                    ),
                  ),
                ),
                //startDate
                TagLayoutWidget(
                  title: "Từ ngày",
                  value: isNotNullOrEmpty(request.startDate)
                      ? request.startDate
                      : "",
                  icon: Icons.date_range,
                  openFilterListener: () {
                    FocusScope.of(context).unfocus();
                    DateTimePickerWidget(
                        format: Constant.ddMMyyyyHHmm,
                        context: context,
                        onDateTimeSelected: (valueDate) {
                          setState(() {
                            request.startDate = valueDate;
                          });
                          // print(valueDate);
                        }).showDateTimePicker();
                  },
                ),
                //EndDate
                TagLayoutWidget(
                  isShowClearText: true,
                  title: "Đến ngày",
                  value:
                      isNotNullOrEmpty(request.endDate) ? request.endDate : "",
                  icon: Icons.date_range,
                  openFilterListener: () {
                    FocusScope.of(context).unfocus();
                    DateTimePickerWidget(
                        format: Constant.ddMMyyyyHHmm,
                        context: context,
                        onDateTimeSelected: (valueDate) {
                          setState(() {
                            request.endDate = valueDate;
                          });
                          // print(valueDate);
                        }).showDateTimePicker();
                  },
                  openRemoveDataListener: () {
                    request.endDate = '';
                  },
                ),
                //mức độ
                TagLayoutWidget(
                  title: "Mức độ ưu tiên",
                  isShowValidate: true,
                  value: isNotNullOrEmpty(request.priority?.value)
                      ? request.priority?.value
                      : "",
                  icon: Icons.arrow_drop_down,
                  openFilterListener: () {
                    _eventClickPriorities();
                  },
                ),
                // trạng thái
                Visibility(
                  visible: !widget.isCreate,
                  child: TagLayoutWidget(
                    title: "Trạng thái",
                    value: isNotNullOrEmpty(request.status?.value)
                        ? request.status?.value
                        : "",
                    icon: iSizeStatus == null || iSizeStatus == 0
                        ? null
                        : Icons.arrow_drop_down,
                    openFilterListener: () {
                      if (iSizeStatus != null || iSizeStatus > 0) {
                        if (request.status.key == 1) {
                          _eventStatusUndefined();
                        } else {
                          _eventClickStatus();
                        }
                      }
                    },
                  ),
                ),
                // nhóm công việc
                Opacity(
                  opacity: !widget.isCreate ? 0.5 : 1,
                  child: TagLayoutWidget(
                    title: "Nhóm công việc",
                    value: isNotNullOrEmpty(request.groupJob?.name)
                        ? request.groupJob?.name ?? ""
                        : "",
                    icon: widget.isCreate ? Icons.arrow_drop_down : null,
                    openFilterListener: () {
                      if (widget.isCreate) {
                        _eventClickGroupJob();
                      }
                    },
                  ),
                ),
                //cột kanban
                Visibility(
                  visible: isShowColKanban,
                  child: TagLayoutWidget(
                    title: "Cột Kanban",
                    isShowValidate: true,
                    value: isNotNullOrEmpty(request.groupJobCol?.name)
                        ? request.groupJobCol?.name
                        : "",
                    icon: Icons.arrow_drop_down,
                    openFilterListener: () {
                      _eventClickKanban();
                    },
                  ),
                ),
                // người nhận việc
                TagLayoutWidget(
                  title: "Người nhận việc",
                  value: isNotNullOrEmpty(request.executor?.name)
                      ? request.executor?.name ?? ""
                      : "",
                  icon: Icons.arrow_drop_down,
                  openFilterListener: () {
                    _eventClickSingleUser(); // default
                  },
                ),
                //người giám sát
                InkWell(
                  onTap: () {
                    List<SharedSearchModel> supervisor = request.supervisor;
                    _eventClickMultipleUser(true, supervisor);
                  },
                  child: _numberMember(
                    title: "Người giám sát",
                    count: request.supervisor?.length ?? 0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  height: 1,
                  color: getColor('#E9ECEF'),
                ),
                //người phối hợp
                InkWell(
                  onTap: () {
                    List<SharedSearchModel> coexecutor = request.coexecutor;
                    _eventClickMultipleUser(false, coexecutor);
                  },
                  child: _numberMember(
                    title: "Người phối hợp",
                    count: request.coexecutor?.length ?? 0,
                  ),
                ),
                Container(
                  height: 4,
                  color: getColor('#E9ECEF'),
                ),
                //danh sách file đính kèm
                Visibility(
                  visible: widget.isCreate,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: NumberGroupWidget(
                      title: "Danh sách file đính kèm",
                      count: files?.length,
                      onPressed: () {
                        if (widget.isCreate) {
                          _eventClickFile();
                        }
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.isCreate,
                  child: Container(
                    height: 4,
                    color: getColor('#E9ECEF'),
                  ),
                ),
              ],
            ),
          ),
        )),
        // button lưu
        Padding(
          padding: const EdgeInsets.all(16),
          child: SaveButton(
            title: widget.isCreate
                ? 'Tạo công việc'.toUpperCase()
                : 'Lưu'.toUpperCase(),
            onTap: () {
              _eventClickCreateJob();
            },
          ),
        ),
      ],
    );
  }

  Widget _numberMember({String title, int count}) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(color: '#555555'.toColor()),
            ),
            Container(
              margin: EdgeInsets.only(left: 4),
              padding: EdgeInsets.only(left: 4, top: 2, right: 4, bottom: 2),
              child: Text(
                "$count",
                style: TextStyle(color: Colors.blue),
              ),
              decoration: BoxDecoration(
                  color: "#DFEAFB".toColor(),
                  borderRadius: BorderRadius.circular(8)),
            ),
            Expanded(
              child: Container(
                height: 20,
                alignment: Alignment.centerRight,
                child: Icon(
                  Icons.navigate_next_rounded,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ));
  }

  // mức độ ưu tiên
  _eventClickPriorities() {
    FocusScope.of(context).unfocus();
    List<Priorities> prioritiesList = _createJobRepository.prioritiesList;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          prioritiesList.forEach((element) {
            element.isSelected = false;
          });

          if (request.priority != null) {
            for (int i = 0; i < prioritiesList.length; i++) {
              if (request.priority.key == prioritiesList[i].key) {
                prioritiesList[i].isSelected = true;
              } else {
                prioritiesList[i].isSelected = false;
              }
            }
          }

          return SizedBox(
            // ignore: null_aware_before_operator
            height: prioritiesList?.length * 80.0,
            child: Container(
              color: Colors.white,
              child: ListView.separated(
                itemCount: prioritiesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: ListTile(
                      title: Row(
                        children: [
                          Expanded(child: Text(prioritiesList[index].value)),
                          Visibility(
                            visible: prioritiesList[index].isSelected ?? false,
                            child: Icon(
                              Icons.check,
                              color: Colors.blue,
                            ),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        int keySelected = prioritiesList[index].key;
                        for (int i = 0; i < prioritiesList.length; i++) {
                          if (prioritiesList[i].key == keySelected) {
                            if (prioritiesList[i].isSelected) {
                              prioritiesList[i].isSelected = false;
                            } else {
                              prioritiesList[i].isSelected = true;
                            }
                          } else {
                            prioritiesList[i].isSelected = false;
                          }
                        }

                        if (prioritiesList[index].isSelected) {
                          request.priority = prioritiesList[index];
                        } else {
                          request.priority = null;
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
          );
        });
  }

  // trạng thái
  _eventClickStatus() {
    FocusScope.of(context).unfocus();
    List<ListStatus> statusList = _createJobRepository.modelEdit.listStatus;

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return SizedBox(
            // ignore: null_aware_before_operator
            height: statusList?.length * 80.0,
            child: Container(
              color: Colors.white,
              child: ListView.separated(
                itemCount: statusList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: ListTile(
                      title: Text(statusList[index].value),
                    ),
                    onTap: () {
                      setState(() {
                        request.status = statusList[index];
                      });
                      Navigator.of(context).pop();
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
            ),
          );
        });
  }

  // nhóm công việc
  _eventClickGroupJob() {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["IsCreateJob"] = 'true'; // default

    pushPage(
        context,
        SharedSearchScreen(
            AppUrl.getCreateJobGroupForSearch, 'Tìm kiếm nhóm công việc',
            params: params,
            modelSelected: request.groupJob, onSharedSearchSelected: (item) {
          this.setState(() {
            request.groupJob = item;
            request.groupJobCol = SharedSearchModel();
            request.executor = SharedSearchModel();
            request.supervisor = [];
            request.coexecutor = [];
            if (isNullOrEmpty(request.groupJob) || request.groupJob?.iD == 0) {
              isShowColKanban = false;
            } else {
              isShowColKanban = true;
            }
          });
        }));
  }

  // cột kanban
  _eventClickKanban() {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["IDGroupJob"] =
        request.groupJob?.iD == null ? 0 : request.groupJob?.iD;
    pushPage(
        context,
        SharedSearchScreen(AppUrl.getListGroupJobCol, 'Tìm kiếm cột kanban',
            params: params,
            modelSelected: request.groupJobCol, onSharedSearchSelected: (item) {
          this.setState(() {
            request.groupJobCol = item;
          });
        }));
  }

  // người nhận việc
  _eventClickSingleUser() async {
    //TẠO CÔNG VIỆC và trạng thái chưa xác định và chưa xử lý
    if (widget.isCreate || request.status.key == 1) {
      FocusScope.of(context).unfocus();
      String iIDCoExecuter, iIDSupervisor;
      if (widget.isCreate) {
        iIDCoExecuter = '0';
        iIDSupervisor = '0';
      } else {
        iIDCoExecuter = _convertListToStringID(request.coexecutor) ?? "0";
        iIDSupervisor = _convertListToStringID(request.supervisor) ?? "0";
      }
      int iIDGroupJob = request.groupJob?.iD;
      Map<String, dynamic> params = new Map<String, dynamic>();
      params["IDGroupJob"] = iIDGroupJob;
      params["IDExecuter"] = 0;
      params["IDCoExecuter"] = iIDCoExecuter.toString();
      params["IDSupervisor"] = iIDSupervisor.toString();

      pushPage(
          context,
          SharedSearchScreen(
              AppUrl.getUserForCreateJob, 'Tìm kiếm người nhận việc',
              params: params,
              modelSelected: request.executor, onSharedSearchSelected: (item) {
            this.setState(() {
              request.executor = item;
              request.supervisor = [];
              request.coexecutor = [];
            });
          }));
    } else if (request.status.key == 8 ||
        request.status.key == 2 ||
        request.status.key == 4 ||
        request.status.key == 5) {
      // trạng thái hủy(ID:8), chưa xử lý(ID:2), từ chối(ID:4), tạm dừng(ID:5)
      int iDJob = widget.sJobID;
      String sIDCoexecutor = request.iDOldCoExecuter;
      String sIDSupervisor = request.iDOldSupervisor;
      int idGroup = request.groupJob?.iD;
      var backData = await pushPage(
          context,
          TransferPersonNewScreen(
              iDJob, sIDCoexecutor, sIDSupervisor, idGroup));
      if (backData != null) {
        getDataForEdit();
      }
    } else if (request.status.key == 3) {
      //trạng thái: đang xử lý(ID:3)
      String sID = widget.sJobID.toString();
      String sIDCoexecutor = request.iDOldCoExecuter;
      String sIDSupervisor = request.iDOldSupervisor;
      String name = request.executor?.name ?? '--';
      int idGroup = request.groupJob?.iD;
      int number = await pushPage(context,
          TransferJobScreen(sID, sIDCoexecutor, sIDSupervisor, name, idGroup));
      if (number == 1) {
        getDataForEdit();
      }
    } else {
      // đã đóng(ID:7), hoành thành(ID:6) không có gì
    }
  }

  // người giám sát, người phối hợp
  _eventClickMultipleUser(
      bool isType, List<SharedSearchModel> listSelected) async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["IDGroupJob"] = request.groupJob?.iD ?? 0;
    params["IDExecuter"] = request.executor?.iD ?? 0;
    params["IDCoExecuter"] = '0';
    params["IDSupervisor"] = '0';
    // =1 để bỏ chưa xác định trong list
    params["IsExclusionUDF"] = '1';

    pushPage(
        context,
        SelectMultipleScreen(AppUrl.getUserForCreateJob,
            'Tìm kiếm ${isType ? 'người giám sát' : 'người phối hợp'}',
            listSelected: listSelected,
            params: params, onSharedSearchSelected: (item) {
          this.setState(() {
            if (isType) {
              request.supervisor = item;
            } else {
              request.coexecutor = item;
            }
          });
        }));
  }

  _eventClickFile() async {
    FocusScope.of(context).unfocus();
    List<FileModel> files = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AttachFilesScreen(AttachFileType.task_detail,
              taskType: 2, files: this.files)),
    );
    setState(() {
      this.files = files;
    });
  }

  // save and edit
  _eventClickCreateJob() async {
    FocusScope.of(context).unfocus();
    if (nameController.text == null || nameController.text.length == 0) {
      ToastMessage.show('Tên công việc' + textNotLeftBlank, ToastStyle.error);
      return;
    }
    if (request.startDate == null) {
      ToastMessage.show('Ngày bắt đầu' + textNotLeftBlank, ToastStyle.error);
      return;
    }
    if (request.priority?.key == null) {
      ToastMessage.show('Mức độ ưu tiên' + textNotLeftBlank, ToastStyle.error);
      return;
    }

    if (!widget.isCreate && request.status?.key == null ||
        request.status?.key == 0 &&
            request.status?.key != 1 &&
            request.status?.key != 2) {
      ToastMessage.show('Người nhận việc' + textNotLeftBlank, ToastStyle.error);
      return;
    }
    if (request.groupJobCol == null) {
      ToastMessage.show('Cột Kanban' + textNotLeftBlank, ToastStyle.error);
      return;
    }

    request.sName = nameController.text;
    request.describe = describeController.text;
    request.sJobID = widget.sJobID.toString();

    if (widget.isCreate) {
      request.sIDParent = widget.sIDParent.toString();
      request.sFileName = FileUtils.instance.getStringFileName(files);
      request.sFilePath = FileUtils.instance.getStringFilePath(files);

      int iStatus = await _createJobRepository.getCreateJob(request);
      if (iStatus == 1) {
        if (widget.sIDParent == 0) {
          request = CreateJobRequest();
          nameController = TextEditingController();
          describeController = TextEditingController();

          request.executor = SharedSearchModel();
          request.supervisor = [];
          request.coexecutor = [];
          request.groupJobCol = SharedSearchModel();
          request.groupJob = SharedSearchModel();

          files.clear();
          request.startDate = getCurrentDate(Constant.ddMMyyyyHHmm);
        } else {
          Navigator.of(context).pop();
        }
      }
    } else {
      request.iDOldCoExecuter = '[' +
          _convertListToStringID(
              _createJobRepository.modelEdit.jobCombination) +
          ']';
      request.iDOldSupervisor = '[' +
          _convertListToStringID(
              _createJobRepository.modelEdit.jobSupervisors) +
          ']';

      int iStatus = await _createJobRepository.getSaveDetailJob(request);
      if (iStatus == 1) {
        Navigator.of(context).pop();
      }
    }
  }

  _eventStatusUndefined() async {
    //Chuyển trạng thái công việc
    ChangeUndefinedStatusModel data =
        await CustomTransferStatusJobDialog(context).showCustomDialog(
            widget.sJobID,
            request.groupJob?.iD ?? 0,
            request.executor,
            request.endDate);
    if (data != null) {
      getDataForEdit();
    }
  }

  // chuyển list thành 1,2,3
  String _convertListToStringID(List<SharedSearchModel> model) {
    List<String> listID = [];
    if (isNullOrEmpty(model) || model.length == 0) return '';
    model.forEach((element) {
      listID.add(element.iD.toString());
    });
    return FileUtils.instance.getListStringConvertString(listID);
  }
}

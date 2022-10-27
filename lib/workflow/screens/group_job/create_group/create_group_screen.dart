import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/bottom_sheet_dialog.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/number_group_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/workflow/models/event/create_group_event.dart';
import 'package:workflow_manager/workflow/models/params/create_group_request.dart';
import 'package:workflow_manager/workflow/models/params/edit_group_request.dart';
import 'package:workflow_manager/workflow/models/response/filter_task_response.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_edit_respone.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/attach_files_screen.dart';
import 'package:workflow_manager/workflow/screens/details/attach_files/file_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_job_detail_main/group_job_detail_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_job_member_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/repository/group_task_repository.dart';
import 'package:workflow_manager/workflow/screens/group_job/repository/member_repository.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

import '../list_member_screen.dart';

// ignore: must_be_immutable
class CreateGroupScreen extends StatefulWidget {
  int idGroup;

  bool isCreateScreen = true;

  GroupJobDetailModel groupJobDetailModel;

  CreateGroupScreen(this.isCreateScreen, {this.groupJobDetailModel});

  @override
  State<StatefulWidget> createState() {
    return _CreateGroupScreenState();
  }
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  TextEditingController nameGroupController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  GroupTaskRepository _groupTaskRepository = GroupTaskRepository();

  CreateGroupRequest _createGroupRequest = CreateGroupRequest();

  EditGroupRequest _editGroupRequest = EditGroupRequest();

  List<GroupJobMemberModel> arrayMember = List();

  List<FileModel> files = List();

  // get data khi tạo nhóm
  void getDataNewGroup() async {
    await _groupTaskRepository.getDataNewGroup();
    ListStatus listStatus = await _groupTaskRepository.getDefaultStatus();
    _createGroupRequest.status =
        UserItem(iD: listStatus.key, name: listStatus.value);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isCreateScreen) {
      //Màn hình tạo group
      getDataNewGroup();
    } else {
      this.nameGroupController.text = widget.groupJobDetailModel.name;
      var document = parse(
          widget.groupJobDetailModel.describe ?? ""); // dùng để xóa thẻ html
      this.descriptionController.text = document.body.text;

      _editGroupRequest.name = widget.groupJobDetailModel.name;
      _editGroupRequest.description = document.body.text;
      _editGroupRequest.startDate =
          widget.groupJobDetailModel.startDate?.toDateFormat();
      _editGroupRequest.endDate =
          widget.groupJobDetailModel.endDate?.toDateFormat();
      _editGroupRequest.idJobGroup = widget.groupJobDetailModel.iD;

      _editGroupRequest.status = UserItem();
      _editGroupRequest.status.iD =
          widget.groupJobDetailModel.currentStatus.key;
      _editGroupRequest.status.name =
          widget.groupJobDetailModel.currentStatus.value;

      _editGroupRequest.priority = UserItem();
      _editGroupRequest.priority.iD =
          widget.groupJobDetailModel.currentPriority.key;
      _editGroupRequest.priority.name =
          widget.groupJobDetailModel.currentPriority.value;
      loadByListMember();
    }
  }

  loadByListMember() async {
    MemberRepository _memberRepository = MemberRepository();
    if (widget.groupJobDetailModel?.iD != null &&
        // ignore: null_aware_before_operator
        widget.groupJobDetailModel?.totalMember > 0) {
      await _memberRepository.loadById(widget.groupJobDetailModel?.iD);
      arrayMember = _memberRepository.arrayMember;
    }
  }

  // display ngày bắt đầu
  String fetchDataForStartDate() {
    if (widget.isCreateScreen) {
      return _createGroupRequest.startDate ?? "";
    } else {
      return _editGroupRequest.startDate ?? "";
    }
  }

  // display ngày kết thúc
  String fetchDataForEndDate() {
    if (widget.isCreateScreen) {
      return _createGroupRequest.endDate ?? "";
    } else {
      return _editGroupRequest.endDate ?? "";
    }
  }

  // Lấy trạng thái hiện tai
  String getCurrentStatus() {
    if (widget.isCreateScreen) {
      return _createGroupRequest.status?.name;
    } else {
      return _editGroupRequest.status?.name;
    }
  }

  // Lấy mức độ ưu tiên hiện tại
  String getCurrentPriority() {
    return widget.isCreateScreen
        ? _createGroupRequest.priority?.name
        : _editGroupRequest.priority?.name;
  }

  // get danh sách mức độ ưu tiên
  List<Priorities> getListPriority() {
    return widget.isCreateScreen
        ? _groupTaskRepository.newGroupData.listPriority
        : widget.groupJobDetailModel.listPriority;
  }

  // get danh sách trạng thái
  List<ListStatus> getListStatus() {
    return widget.isCreateScreen
        ? _groupTaskRepository.newGroupData.listStatus
        : widget.groupJobDetailModel.listStatus;
  }

  // tạo mới hoặc chỉnh sửa group
  void createNewOrEditGroup() async {
    FocusScope.of(context).unfocus();
    if (isNullOrEmpty(arrayMember) || arrayMember == 0) {
      ToastMessage.show(
          'Danh sách thành viên' + textNotLeftBlank, ToastStyle.error);
      return;
    }

    if (widget.isCreateScreen) {
      _createGroupRequest.name = nameGroupController.text;
      _createGroupRequest.description = descriptionController.text;

      if (isNullOrEmpty(_createGroupRequest.name)) {
        ToastMessage.show(
            'Tên nhóm công việc' + textNotLeftBlank, ToastStyle.error);
        return;
      }
      if (isNullOrEmpty(_createGroupRequest.priority?.iD)) {
        ToastMessage.show(
            'Mức độ ưu tiên' + textNotLeftBlank, ToastStyle.error);
        return;
      }
      if (isNullOrEmpty(_createGroupRequest.status?.name)) {
        ToastMessage.show('Trạng thái' + textNotLeftBlank, ToastStyle.error);
        return;
      }

      _groupTaskRepository.createNewGroup(_createGroupRequest).then((value) => {
            if (value)
              {
                eventBus.fire(
                    CreateGroupEvent(status: _createGroupRequest.status.iD)),
                Navigator.pop(context)
              }
          });
    } else {
      _editGroupRequest.name = nameGroupController.text;
      _editGroupRequest.description = descriptionController.text;

      if (isNullOrEmpty(_editGroupRequest.name)) {
        ToastMessage.show(
            'Tên nhóm công việc' + textNotLeftBlank, ToastStyle.error);
        return;
      }
      // if (isNullOrEmpty(_editGroupRequest.startDate)) {
      //   ToastMessage.show('Ngày bắt đầu' + textNotLeftBlank, ToastStyle.error);
      //   return;
      // }
      // if (isNullOrEmpty(_editGroupRequest.endDate)) {
      //   ToastMessage.show('Ngày kết thúc' + textNotLeftBlank, ToastStyle.error);
      //   return;
      // }
      if (isNullOrEmpty(_editGroupRequest.priority?.iD)) {
        ToastMessage.show(
            'Mức độ ưu tiên' + textNotLeftBlank, ToastStyle.error);
        return;
      }
      if (isNullOrEmpty(_editGroupRequest.status?.name)) {
        ToastMessage.show('Trạng thái' + textNotLeftBlank, ToastStyle.error);
        return;
      }

      bool isCheckEdit =
          await _groupTaskRepository.editGroup(_editGroupRequest);
      if (isCheckEdit) {
        Navigator.pop(context, 1);
      }
    }
  }

  void checkEnableStatus(String date) {
    if (compareDate(date, getCurrentDate(Constant.ddMMyyyy)) > 0) {
      ListStatus item = _groupTaskRepository.newGroupData.listStatus[0];
      setState(() {
        _createGroupRequest.status = UserItem(iD: item.key, name: item.value);
      });
    } else {
      ListStatus item = _groupTaskRepository.newGroupData.listStatus[1];
      setState(() {
        _createGroupRequest.status = UserItem(iD: item.key, name: item.value);
      });
    }
  }

  int getCountListMember() {
    if (widget.isCreateScreen) {
      return arrayMember.length;
    } else {
      if (arrayMember.length > 0) {
        return arrayMember.length;
      } else {
        return widget.groupJobDetailModel.totalMember ?? 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _groupTaskRepository,
      child: Consumer(
        builder: (context, GroupTaskRepository repository, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                widget.isCreateScreen
                    ? 'Tạo nhóm công việc'
                    : 'Sửa nhóm công việc',
              ),
            ),
            body: SafeArea(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanDown: (_) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("Tên nhóm"),
                                Text("*", style: TextStyle(color: Colors.red),)
                              ],
                            ),
                            TextField(
                              controller: nameGroupController,
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, bottom: 8, right: 16),
                        child: TextField(
                          maxLines: null,
                          controller: descriptionController,
                          decoration: InputDecoration(labelText: 'Mô tả'),
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      TagLayoutWidget(
                        title: "Từ ngày",
                        value: fetchDataForStartDate(),
                        icon: Icons.date_range,
                        openFilterListener: () {
                          DateTimePickerWidget(
                              format: Constant.ddMMyyyy,
                              context: context,
                              currentTime: _createGroupRequest.startDate,
                              onDateTimeSelected: (valueDate) {
                                setState(() {
                                  if (widget.isCreateScreen) {
                                    _createGroupRequest.startDate = valueDate;
                                  } else {
                                    _editGroupRequest.startDate = valueDate;
                                  }
                                });
                                checkEnableStatus(valueDate);
                              }).showOnlyDatePicker();
                        },
                      ),
                      TagLayoutWidget(
                        title: "Đến ngày",
                        value: fetchDataForEndDate(),
                        icon: Icons.date_range,
                        openFilterListener: () {
                          DateTimePickerWidget(
                              format: Constant.ddMMyyyy,
                              context: context,
                              currentTime: _createGroupRequest.endDate,
                              onDateTimeSelected: (valueDate) {
                                setState(() {
                                  if (widget.isCreateScreen) {
                                    _createGroupRequest.endDate = valueDate;
                                  } else {
                                    _editGroupRequest.endDate = valueDate;
                                  }
                                });
                                // print(valueDate);
                              }).showOnlyDatePicker();
                        },
                      ),
                      TagLayoutWidget(
                        title: "Mức độ ưu tiên",
                        isShowValidate: true,
                        value: getCurrentPriority() ?? "",
                        icon: Icons.arrow_drop_down,
                        openFilterListener: () {
                          BottomSheetDialog(
                              context: context,
                              onTapListener: (item) {
                                this.setState(() {
                                  if (widget.isCreateScreen) {
                                    if (item.isSelected) {
                                      _createGroupRequest.priority = UserItem(iD: item.key, name: item.value, isSelected: item.isSelected);
                                    } else {
                                      _createGroupRequest.priority = UserItem(iD: 0, name: "", isSelected: item.isSelected);
                                    }
                                  } else {
                                    if (item.isSelected) {
                                      _editGroupRequest.priority = UserItem(iD: item.key, name: item.value, isSelected: item.isSelected);
                                    } else {
                                      _editGroupRequest.priority = UserItem(iD: 0, name: "", isSelected: item.isSelected);
                                    }
                                  }
                                });
                              }).showBottomSheetDialog(getListPriority());
                        },
                      ),
                      TagLayoutWidget(
                        title: "Trạng thái",
                        value: getCurrentStatus() ?? "",
                        icon: Icons.arrow_drop_down,
                        enable: _createGroupRequest.startDate.isNullOrEmpty,
                        openFilterListener: () {
                          BottomSheetDialog(
                              context: context,
                              onTapListener: (item) {
                                this.setState(() {
                                  if (widget.isCreateScreen) {
                                    _createGroupRequest.status = UserItem(
                                        iD: item.key, name: item.value);
                                  } else {
                                    _editGroupRequest.status = UserItem(
                                        iD: item.key, name: item.value);
                                  }
                                });
                              }).showBottomSheetDialog(getListStatus());
                        },
                      ),
                      Divider(
                        thickness: 4.0,
                        color: "#E9ECEF".toColor(),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: NumberGroupWidget(
                          title: "Danh sách thành viên",
                          isShowValidate: true,
                          count: getCountListMember(),
                          onPressed: () async {
                            List<GroupJobMemberModel> arrayMember =
                                await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ListMemberScreen(
                                        widget.isCreateScreen
                                            ? ListMemberScreen.admin
                                            : widget.groupJobDetailModel.role,
                                        groupId: widget.groupJobDetailModel?.iD,
                                        arrayMember: this.arrayMember,
                                      )),
                            );
                            this.setState(() {
                              this.arrayMember = arrayMember;
                            });
                            _createGroupRequest.idEmps =
                                repository.getListIdMember(arrayMember);
                            _createGroupRequest.roles =
                                repository.getListRoleMember(arrayMember);
                          },
                        ),
                      ),
                      Divider(
                        thickness: 4.0,
                        color: "#E9ECEF".toColor(),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: NumberGroupWidget(
                          title: "Danh sách file đính kèm",
                          count: widget.isCreateScreen
                              ? files.length
                              : widget.groupJobDetailModel.totalFile,
                          onPressed: () async {
                            List<FileModel> files = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AttachFilesScreen(
                                        AttachFileType.group_job_detail,
                                        role: AttachFilesScreen.admin,
                                        id: widget.groupJobDetailModel?.iD,
                                        files: this.files,
                                      )),
                            );
                            setState(() {
                              this.files = files;
                            });
                            _createGroupRequest.fileName =
                                FileUtils.instance.getStringFileName(files);
                            _createGroupRequest.filePath =
                                FileUtils.instance.getStringFilePath(files);
                          },
                        ),
                      ),
                      Divider(
                        thickness: 4.0,
                        color: "#E9ECEF".toColor(),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: SaveButton(
                          title: "Lưu",
                          onTap: () {
                            // call api create new group
                            createNewOrEditGroup();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

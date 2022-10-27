import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/workflow/models/response/pair_reponse.dart';
import 'package:workflow_manager/workflow/screens/group_job/add_member_screen/add_member_repository.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_request/search_group_user_request.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_job_member_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/search_dept_screen/search_dept_screen.dart';
import 'package:workflow_manager/workflow/screens/group_job/shared_search_screen/shared_search_screen.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/bottom_sheet_dialog.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/title_dialog.dart';

class AddMemberScreen extends StatefulWidget {
  int iDGroupJob;
  List<int> userList;
  void Function(GroupJobMemberModel) onMemberCreated;

  AddMemberScreen(this.iDGroupJob, this.userList, {this.onMemberCreated});

  @override
  State<StatefulWidget> createState() {
    return _AddMemberScreenState();
  }
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  AddMemberRepository _addMemberRepository = AddMemberRepository();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _addMemberRepository,
      child: Consumer(
        builder: (context, AddMemberRepository addMemberRepository, child) {
          return Wrap(children: [
            TitleDialog(
              "Thêm thành viên",
              padding: 16,
            ),
            Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TagLayoutWidget(
                        title: "Phòng ban",
                        value: addMemberRepository?.dept?.name ?? "",
                        icon: Icons.arrow_drop_down,
                        openFilterListener: () {
                          eventChooseDept();
                        },
                      ),
                      TagLayoutWidget(
                        title: "Thành viên",
                        value: addMemberRepository?.groupUserModel?.name ?? "",
                        icon: Icons.arrow_drop_down,
                        openFilterListener: () {
                          eventChooseUser(_addMemberRepository?.dept?.iD);
                        },
                      ),
                      TagLayoutWidget(
                        title: "Chức vụ",
                        value:
                            addMemberRepository?.groupUserModel?.position ?? "",
                        icon: null,
                        openFilterListener: () {},
                      ),
                      TagLayoutWidget(
                        title: "Email",
                        value: addMemberRepository?.groupUserModel?.email ?? "",
                        icon: null,
                        openFilterListener: () {},
                      ),
                      TagLayoutWidget(
                        title: "Vai trò",
                        value: _addMemberRepository.role == 2
                            ? "Thành viên"
                            : "Quản trị viên",
                        icon: Icons.arrow_drop_down,
                        openFilterListener: () {
                          eventChooseRole();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, top: 16, right: 16, bottom: 32),
                        child: SaveButton(
                          title: "Thêm",
                          onTap: () {
                            addMember();
                          },
                        ),
                      )
                    ],
                  ),
                ))
          ]);
        },
      ),
    );
  }

  void eventChooseUser(deptId) {
    if (deptId == null) {
      // showToastNormal("Chưa chọn phòng bạn.");
      return;
    }
    SearchGroupUserRequest searchGroupUserRequest = SearchGroupUserRequest();
    searchGroupUserRequest.iDDept = deptId;
    searchGroupUserRequest.userList = widget.userList;
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SharedSearchScreen(
              AppUrl.getGroupTaskGetListUserByDeptAPI,
              "Tìm kiếm nhân viên",
              params: searchGroupUserRequest.getParamsNoneNull(),
              onSharedSearchSelected: (item) async {
                await _addMemberRepository.getUserById(item.iD);
              },
            )));
  }

  void addMember() async {
    if (_addMemberRepository.dept == null) {
      ToastMessage.show("Phòng ban không được để trống", ToastStyle.error);
      return;
    }
    if (_addMemberRepository.groupUserModel == null) {
      ToastMessage.show("Thành viên không được để trống", ToastStyle.error);
      return;
    }
    GroupJobMemberModel memberModel;
    if (widget.iDGroupJob != null) {
      memberModel = await _addMemberRepository.addMember(widget.iDGroupJob,
          _addMemberRepository.groupUserModel.id, _addMemberRepository.role);
    } else {
      memberModel = GroupJobMemberModel();
      memberModel.role = _addMemberRepository.role;
      memberModel.email = _addMemberRepository.groupUserModel.email;
      memberModel.positionName = _addMemberRepository.groupUserModel.position;
      memberModel.deptName = _addMemberRepository.dept.name;
      memberModel.name = _addMemberRepository.groupUserModel.name;
      memberModel.iDUser = _addMemberRepository.groupUserModel.id;
    }
    if (widget.onMemberCreated != null) {
      widget.onMemberCreated(memberModel);
      Navigator.pop(context);
    }
  }

  void eventChooseDept() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SearchDeptScreen(
          deptSelected: _addMemberRepository.dept,
          onDeptSelected: (item) {
            if (item.isSelected) {
              _addMemberRepository.changeDept(item);
            } else {
              _addMemberRepository.changeDept(null);
            }
          },
        )
    ));
  }

  void eventChooseRole() {
    BottomSheetDialog bottomSheetDialog = BottomSheetDialog(
      context: context,
      onTapListener: (item) async {
        _addMemberRepository.changeRole(item.key);
      },
    );
    List<Pair> list = [
      Pair(key: 2, value: "Thành viên"),
      Pair(key: 1, value: "Quản trị viên")
    ];
    bottomSheetDialog.showBottomSheetDialog(list);
  }
}

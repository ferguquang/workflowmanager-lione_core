import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/bottom_sheet_dialog.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';
import 'package:workflow_manager/workflow/models/response/pair_reponse.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_job_member_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/repository/member_repository.dart';

import 'add_member_screen/add_member_screen.dart';

class ListMemberScreen extends StatefulWidget {
  static int admin = 1;
  int groupId;
  int role;
  bool editable = false;
  List<GroupJobMemberModel> arrayMember;

  ListMemberScreen(this.role, {this.groupId, this.arrayMember}) {
    editable = role == 1;
  }

  @override
  State<StatefulWidget> createState() {
    return _ListMemberScreenState();
  }
}

class _ListMemberScreenState extends State<ListMemberScreen> {
  MemberRepository _memberRepository = MemberRepository();
  User user = User();

  @override
  void initState() {
    super.initState();
    if (widget.groupId != null) _memberRepository.loadById(widget.groupId);
    if (widget.arrayMember != null) {
      _memberRepository.setMemberList(widget.arrayMember);
    }
    isCheckIDUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _memberRepository.arrayMember);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Thành viên"),
          actions: [
            InkWell(
              onTap: () {
                showAddMember();
              },
              child: Visibility(
                child: Container(
                    margin: EdgeInsets.all(8), child: Icon(Icons.add)),
                visible: widget.editable,
              ),
            )
          ],
        ),
        body: ChangeNotifierProvider.value(
          value: _memberRepository,
          child: Consumer(
            builder: (context, MemberRepository memberRepository, child) {
              return Padding(
                  padding: EdgeInsets.all(16),
                  child: memberRepository.arrayMember.length == 0
                      ? EmptyScreen()
                      : Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                              itemCount: memberRepository.arrayMember.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Container(
                                        //   margin: EdgeInsets.only(top: 4),
                                        //   alignment: Alignment.center,
                                        //   padding: EdgeInsets.symmetric(
                                        //       vertical: 4, horizontal: 4),
                                        //   decoration: BoxDecoration(
                                        //       color: "D9EFFA".toColor(),
                                        //       borderRadius: BorderRadius.all(
                                        //           Radius.circular(12))),
                                        //   child:
                                        CachedNetworkImage(
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.account_circle,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                          placeholder: (context, url) => Icon(
                                            Icons.account_circle,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                          imageUrl: memberRepository
                                                  .arrayMember[index].avatar ??
                                              "",
                                          imageBuilder:
                                              (context, imageProvider) {
                                            return Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover),
                                              ),
                                            );
                                          },
                                          // ),,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _buildRow(
                                                  "Phòng ban",
                                                  memberRepository
                                                          ?.arrayMember[index]
                                                          ?.deptName ??
                                                      ""),
                                              _buildRow(
                                                  "Thành viên",
                                                  memberRepository
                                                          ?.arrayMember[index]
                                                          ?.name ??
                                                      ""),
                                              _buildRow(
                                                  "Chức vụ",
                                                  memberRepository
                                                          ?.arrayMember[index]
                                                          ?.positionName ??
                                                      ""),
                                              _buildRow(
                                                  "Email",
                                                  memberRepository
                                                          ?.arrayMember[index]
                                                          ?.email ??
                                                      ""),
                                              Visibility(
                                                visible: widget.groupId != null,
                                                child: _buildRow(
                                                    "Trạng thái",
                                                    memberRepository
                                                            ?.arrayMember[index]
                                                            ?.statusName ??
                                                        ""),
                                              ),
                                              _buildRow(
                                                  "Vai trò",
                                                  (memberRepository
                                                                  ?.arrayMember[
                                                                      index]
                                                                  ?.role ??
                                                              2) ==
                                                          1
                                                      ? "Quản trị viên"
                                                      : "Thành viên"),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          child: getPopupMenu(_memberRepository
                                              .arrayMember[index]),
                                          visible: isCheckPermission(
                                              _memberRepository
                                                  .arrayMember[index].iDUser),
                                        )
                                      ],
                                    )
                                  ],
                                );
                              },
                            ))
                          ],
                        ));
            },
          ),
        ),
      ),
    );
  }

  isCheckPermission(int idUser) {
    if (widget.editable) {
      if (user?.iDUserDocPro == idUser) {
        return false;
      }
      return true;
    } else {
      return false;
    }
  }

  Widget getPopupMenu(GroupJobMemberModel member) {
    return PopupMenuButton(
      child: Container(child: Icon(Icons.more_vert)),
      onSelected: (value) async {
        switch (value) {
          case 0: //chỉnh sửa
            {
              BottomSheetDialog bottomSheetDialog = BottomSheetDialog(
                context: context,
                onTapListener: (item) async {
                  if (widget.groupId != null) {
                    await _memberRepository.editMember(
                        widget.groupId, member.iD, item.key);
                  } else {
                    _memberRepository.editMemberLocal(member.iD, item.key);
                  }
                },
              );
              List<Pair> list = [
                Pair(
                    key: member.role == 2 ? 1 : 2,
                    value: member.role == 2 ? "Quản trị viên" : "Thành viên")
              ];
              bottomSheetDialog.showBottomSheetDialog(list);
              break;
            }
          case 1:
            {
              //xóa
              ConfirmDialogFunction confirmDialogFunction =
                  ConfirmDialogFunction(
                context: context,
                content: "Bạn có muốn xóa thành viên này không?",
                onAccept: () {
                  if (widget.groupId != null) {
                    _memberRepository.deleteMember(widget.groupId, member.iD);
                  } else {
                    _memberRepository.removeMemberLocalByUserID(member.iDUser);
                  }
                },
              );
              confirmDialogFunction.showConfirmDialog();
              break;
            }
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: 0,
            child: _buildMenu("Chỉnh sửa"),
          ),
          PopupMenuItem(
            value: 1,
            child: _buildMenu("Xóa"),
          ),
        ];
      },
    );
  }

  Widget _buildMenu(String title) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(title),
    );
  }

  showAddMember() {
    showModalBottomSheet(
        context: context,
        builder: (context) => AddMemberScreen(
              widget.groupId,
              _memberRepository.arrayMember
                  ?.map(
                    (e) => e.iD,
                  )
                  ?.toList(),
              onMemberCreated: (GroupJobMemberModel member) {
                if (member != null) {
                  _memberRepository.addMember(member);
                }
              },
            ),
        backgroundColor: Colors.transparent,
        isScrollControlled: true);
  }

  Widget _buildRow(String label, String content, {Widget contentWidget}) {
    return Padding(
        padding: EdgeInsets.all(6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label + ": "),
            Expanded(
              child: contentWidget ??
                  Text(
                    content,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
            )
          ],
        ));
  }

  isCheckIDUser() async {
    user = await SharedPreferencesClass.getUser();
  }
}

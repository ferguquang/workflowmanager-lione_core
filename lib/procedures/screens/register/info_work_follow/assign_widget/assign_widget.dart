import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/handler_info.dart';
import 'package:workflow_manager/procedures/models/response/list_position_dept_selected_model.dart';
import 'package:workflow_manager/procedures/models/response/position.dart';
import 'package:workflow_manager/procedures/models/response/register_create_response.dart';
import 'package:workflow_manager/procedures/models/response/user.dart';
import 'package:workflow_manager/procedures/models/response/user_info_response.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/title_dialog.dart';

import 'assign_repository.dart';

class AssignWidget extends StatefulWidget {
  RegisterCreateModel model;
  bool isViewInOneRow;
  UserInfoModel userInfoModel;
  bool isType;
  String titleStep;

  AssignWidget(this.model, this.isViewInOneRow,
      {GlobalKey globalKey,
      this.userInfoModel,
      this.isType = false,
      this.titleStep = ''})
      : super(key: globalKey ?? GlobalKey()) {
    if ((key as GlobalKey).currentState != null) {
      ((key as GlobalKey).currentState as AssignWidgetState).reload();
    }
  }

  List<User> getSelectedUsers() {
    return _getState()._assignRepository.users;
  }

  List<HandlerInfo> getSelectedTeams() {
    return _getState()._assignRepository.teams;
  }

  List<HandlerInfo> getSelectedDepts() {
    return _getState()._assignRepository.depts;
  }

  List<ListPositionDeptSelectedModel> getSelectedPositionAndDepts() {
    return _getState()._assignRepository.positionAndDepts;
  }

  AssignWidgetState _getState() {
    if ((key as GlobalKey).currentState != null) {
      return ((key as GlobalKey).currentState as AssignWidgetState);
    }
    return null;
  }

  @override
  AssignWidgetState createState() => AssignWidgetState();
}

class AssignWidgetState extends State<AssignWidget>
    with AutomaticKeepAliveClientMixin {
  RegisterCreateModel model;
  double _padding = 8;
  double _sizeCircle = 40;
  AssignRepository _assignRepository = AssignRepository();
  String root;

  reload() {
    _assignRepository.notifyListeners();
  }

  getRootUrl() async {
    root = await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
  }

  String getAvatar(String link) {
    if (isNullOrEmpty(link)) return "";
    if (link.startsWith("http")) return link;
    return (root ?? '') + link;
  }

  @override
  void initState() {
    super.initState();
    getRootUrl();
    model = widget.model;
    if (_isShowAssign()) {
      _assignRepository.userInfoModel = widget.userInfoModel;
      if (widget.isType == false) {
        if (!widget.isViewInOneRow) _assignRepository.loadData();
      }
      List<Position> listPositionSelected =
          model.postions; // list server trả về
      List<ListPositionDeptSelectedModel> listPositionDeptSelectedModels = [];
      if (isNotNullOrEmpty(listPositionSelected)) {
        // list phòng ban - chức vụ với phòng ban là duy nhất
        List<int> listIdPositionUnique =
            listPositionSelected.map((e) => e.iD).toSet().toList();
        for (int i = 0; i < listIdPositionUnique.length; i++) {
          int idPosition = listIdPositionUnique[i];
          List<int> listIdDeptOfPosition = [];
          List<String> listNameDeptOfPosition = [];

          Position selectedPosition = null;
          bool isRemovable = true;
          for (int j = 0; j < listPositionSelected.length; j++) {
            Position position = listPositionSelected[j];
            if (position.iD == idPosition) {
              if (listPositionSelected[j].iDDept > 0) {
                listIdDeptOfPosition.add(listPositionSelected[j].iDDept);

                String name = listPositionSelected[j].name;
                List<String> nameArray = name.split("-");
                listNameDeptOfPosition.add(nameArray[1]);

                if (selectedPosition == null) {
                  selectedPosition = listPositionSelected[j];
                  selectedPosition.name = nameArray[0];
                  selectedPosition.isRemovable =
                      listPositionSelected[j].isRemovable;
                }
              } else {
                selectedPosition = listPositionSelected[j];
              }

              if (!listPositionSelected[j].isRemovable) {
                isRemovable = false;
              }
            }
          }

          List<HandlerInfo> listDeptOfPosition = [];
          for (int j = 0; j < listIdDeptOfPosition.length; j++) {
            HandlerInfo dept = HandlerInfo();
            dept.iD = listIdDeptOfPosition[j];
            dept.name = listNameDeptOfPosition[j];
            listDeptOfPosition.add(dept);
          }

          if (listIdDeptOfPosition.length > 0) {
            listPositionDeptSelectedModels.add(
                new ListPositionDeptSelectedModel(
                    positionSelected: selectedPosition,
                    isRemovable: isRemovable,
                    listDeptSelected: listDeptOfPosition));
          } else {
            listPositionDeptSelectedModels.add(
                new ListPositionDeptSelectedModel(
                    positionSelected: selectedPosition,
                    isRemovable: isRemovable));
          }
        }
      }
      _assignRepository.setData(model?.teams, model?.depts, model?.users,
          listPositionDeptSelectedModels);
    }
  }

  bool _isShowAssign() {
    return widget.model.isAssignNewExecutor == true ||
        widget.model.isParallelAssign == true;
  }

  @override
  Widget build(BuildContext context) {
    model = widget.model;
    return ChangeNotifierProvider.value(
      value: _assignRepository,
      child: Consumer(
          builder: (context, AssignRepository assignRepository, child) {
        return Visibility(
          visible: _isShowAssign(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: isNotNullOrEmpty(widget.titleStep),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Text(
                    "Chỉ định người giải quyết bước: ${widget.titleStep ?? ''}",
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              _buildHeadWidget("Nhân viên"),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 60,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildFirstIcon(0),
                    Expanded(
                        child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: assignRepository?.users?.length ?? 0,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 8),
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              CircleNetworkImage(
                                url: getAvatar(
                                    assignRepository?.users[index]?.avatar ??
                                        ""),
                                size: _sizeCircle,
                              ),
                              InkWell(
                                onTap: () {
                                  showConfirmDialog(
                                      "Bạn có muốn xóa nhân viên này?", () {
                                    assignRepository?.removeUser(index);
                                  });
                                },
                                child: Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                            alignment: Alignment.topRight,
                          ),
                        );
                      },
                    ))
                  ],
                ),
              ),
              _buildHeadWidget("Phòng ban"),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFirstIcon(1),
                    Expanded(
                        child: Wrap(
                      children: _getDeptTextWidgets(),
                    ))
                  ],
                ),
              ),
              _buildHeadWidget("Nhóm"),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFirstIcon(2),
                    Expanded(
                        child: Wrap(
                      children: _getTeamTextWidgets(),
                    ))
                  ],
                ),
              ),
              _buildHeadWidget("Chức vụ"),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildFirstIcon(3),
                    Expanded(
                        child: Wrap(
                      children: _getPositionTextWidgets(),
                    ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Divider(
                  height: 2,
                  color: getColor("#F2F2F2"),
                  thickness: 2,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  showConfirmDialog(String content, void Function() onAccept) {
    ConfirmDialogFunction confirmDialogFunction = ConfirmDialogFunction(
        context: context, content: content, onAccept: onAccept);
    confirmDialogFunction.showConfirmDialog();
  }

  List<Widget> _getDeptTextWidgets() {
    List<Widget> listWidget = [];
    if (isNotNullOrEmpty(_assignRepository?.depts))
      for (int i = 0; i < _assignRepository?.depts?.length ?? 0; i++) {
        Widget widget = Container(
            margin: EdgeInsets.only(bottom: 8, right: 8),
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                border: Border.all(color: getColor("#F2F2F2"), width: 2),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_assignRepository?.depts[i]?.name ?? ""),
                InkWell(
                  onTap: () {
                    showConfirmDialog("Bạn có muốn xóa phòng ban này?", () {
                      _assignRepository.removeDept(i);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      size: 16,
                    ),
                  ),
                )
              ],
            ));
        listWidget.add(widget);
      }
    return listWidget;
  }

  List<Widget> _getTeamTextWidgets() {
    List<Widget> listWidget = [];
    List<HandlerInfo> teams = _assignRepository?.teams;
    if (isNotNullOrEmpty(teams))
      for (int i = 0; i < teams.length ?? 0; i++) {
        Widget widget = Container(
            margin: EdgeInsets.only(bottom: 8, right: 8),
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                border: Border.all(color: getColor("#F2F2F2"), width: 2),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(teams[i]?.name ?? ""),
                InkWell(
                  onTap: () {
                    showConfirmDialog("Bạn có muốn xóa phòng ban này?", () {
                      _assignRepository.removeTeam(i);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      Icons.close,
                      size: 16,
                    ),
                  ),
                )
              ],
            ));
        listWidget.add(widget);
      }
    return listWidget;
  }

  List<Widget> _getPositionTextWidgets() {
    List<Widget> listWidget = [];
    List<ListPositionDeptSelectedModel> positionAndDepts =
        _assignRepository?.positionAndDepts;
    if (isNotNullOrEmpty(positionAndDepts))
      for (int i = 0; i < positionAndDepts.length ?? 0; i++) {
        Widget widget = InkWell(
          onTap: () {
            onAddPosition(positionAndDepts[i]);
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 8, right: 8),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
                border: Border.all(color: getColor("#F2F2F2"), width: 2),
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: Text((positionAndDepts[i]?.positionSelected?.name ??
                            "") +
                        " - " +
                        getDeptName(positionAndDepts[i]?.listDeptSelected))),
                Container(
                  padding: EdgeInsets.all(4),
                  child: InkWell(
                    onTap: () {
                      showConfirmDialog("Bạn có muốn xóa mục này?", () {
                        _assignRepository.removePositionAndDept(i);
                      });
                    },
                    child: Icon(
                      Icons.close,
                      size: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        listWidget.add(widget);
      }
    return listWidget;
  }

  Widget _buildHeadWidget(String title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            height: 2,
            color: getColor("#F2F2F2"),
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
    );
  }

  onAddEmployee() {
    if (_assignRepository.userInfoModel == null ||
        isNullOrEmpty(_assignRepository.userInfoModel.userInfo.users)) {
      showErrorToast("Không có dữ liệu");
      return;
    }
    List<User> users = _assignRepository.userInfoModel.userInfo.users;
    ChoiceDialog choiceDialog = ChoiceDialog<User>(
      context,
      users,
      selectedObject: _assignRepository.users,
      getTitle: (data) => data.name,
      itemBuilder: (data) {
        return Row(children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleNetworkImage(url: getAvatar(data.avatar), size: 25),
              Container(
                height: 4,
                width: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                  color: Colors.blue,
                ),
              )
            ],
          ),
          Expanded(
            child: Container(
              child: Text(data?.name ?? ""),
              margin: EdgeInsets.symmetric(horizontal: 8),
            ),
          )
        ]);
      },
      isSingleChoice: false,
      title: "Chọn nhân viên",
      hintSearchText: "Nhập tên nhân viên",
      onAccept: (List<User> selected) {
        _assignRepository.setUsers(selected);
      },
    );
    choiceDialog.showChoiceDialog();
  }

  onAddDept() {
    if (_assignRepository.userInfoModel == null ||
        isNullOrEmpty(_assignRepository.userInfoModel.userInfo.depts)) {
      showErrorToast("Không có dữ liệu");
      return;
    }
    List<HandlerInfo> depts = _assignRepository.userInfoModel.userInfo.depts;
    ChoiceDialog choiceDialog = ChoiceDialog<HandlerInfo>(
      context,
      depts,
      selectedObject: _assignRepository.depts,
      getTitle: (data) => data.name,
      itemBuilder: (data) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data?.name ?? "",
                style: TextStyle(fontSize: 14),
              ),
              Visibility(
                  visible: isNotNullOrEmpty(data?.describe),
                  child: Text(
                    data?.describe ?? "",
                    style: TextStyle(fontSize: 12),
                  )),
            ],
          ),
        );
      },
      isSingleChoice: false,
      title: "Chọn phòng",
      hintSearchText: "Nhập tên phòng",
      onAccept: (List<HandlerInfo> selected) {
        _assignRepository.setDepts(selected);
      },
    );
    choiceDialog.showChoiceDialog();
  }

  onAddTeam() {
    if (_assignRepository.userInfoModel == null ||
        isNullOrEmpty(_assignRepository.userInfoModel.userInfo.teams)) {
      showErrorToast("Không có dữ liệu");
      return;
    }
    List<HandlerInfo> teams = _assignRepository.userInfoModel.userInfo.teams;
    ChoiceDialog choiceDialog = ChoiceDialog<HandlerInfo>(
      context,
      teams,
      selectedObject: _assignRepository.teams,
      getTitle: (data) => data.name,
      itemBuilder: (data) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data?.name ?? "",
                style: TextStyle(fontSize: 14),
              ),
              Visibility(
                  visible: isNotNullOrEmpty(data?.describe),
                  child: Text(
                    data?.describe ?? "",
                    style: TextStyle(fontSize: 12),
                  )),
            ],
          ),
        );
      },
      isSingleChoice: false,
      title: "Chọn nhóm",
      hintSearchText: "Nhập tên nhóm",
      onAccept: (List<HandlerInfo> selected) {
        _assignRepository.setTeams(selected);
      },
    );
    choiceDialog.showChoiceDialog();
  }

  onAddPosition(ListPositionDeptSelectedModel item) {
    bool isAdd = item == null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    TitleDialog("Thêm chức vụ"),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: InkWell(
                        onTap: () {
                          if (_assignRepository.userInfoModel == null ||
                              isNullOrEmpty(_assignRepository
                                  .userInfoModel.userInfo.positions)) {
                            showErrorToast("Không có dữ liệu");
                            return;
                          }
                          List<Position> positions = _assignRepository
                              .userInfoModel.userInfo.positions;
                          ChoiceDialog choiceDialog = ChoiceDialog<Position>(
                            context,
                            positions,
                            selectedObject: [item?.positionSelected],
                            getTitle: (data) => data.name,
                            isSingleChoice: true,
                            title: "Chọn chức vụ",
                            hintSearchText: "Nhập tên chức vụ",
                            onAccept: (List<Position> selectedPosition) {
                              if (item == null)
                                item = ListPositionDeptSelectedModel();
                              item.positionSelected =
                                  selectedPosition.length == 0
                                      ? null
                                      : selectedPosition[0];
                              setState(() {});
                            },
                          );
                          choiceDialog.showChoiceDialog();
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Chức vụ"),
                            Expanded(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(item?.positionSelected?.name ??
                                        "Chọn chức vụ"),
                                    Icon(Icons.arrow_drop_down_outlined)
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_assignRepository.userInfoModel == null ||
                            isNullOrEmpty(_assignRepository
                                .userInfoModel.userInfo.depts)) {
                          showErrorToast("Không có dữ liệu");
                          return;
                        }
                        List<HandlerInfo> positions =
                            _assignRepository.userInfoModel.userInfo.depts;
                        ChoiceDialog choiceDialog = ChoiceDialog<HandlerInfo>(
                          context,
                          positions,
                          selectedObject: item?.listDeptSelected,
                          getTitle: (data) => data.name,
                          isSingleChoice: false,
                          itemBuilder: (data) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data?.name ?? "",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Visibility(
                                      visible: isNotNullOrEmpty(data?.describe),
                                      child: Text(
                                        data?.describe ?? "",
                                        style: TextStyle(fontSize: 12),
                                      )),
                                ],
                              ),
                            );
                          },
                          title: 'Chọn phòng',
                          hintSearchText: "Nhập tên phòng",
                          onAccept: (List<HandlerInfo> selectedDept) {
                            if (item == null)
                              item = ListPositionDeptSelectedModel();
                            item.listDeptSelected = selectedDept;
                            setState(() {});
                          },
                        );
                        choiceDialog.showChoiceDialog();
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Phòng ban"),
                            Padding(
                              padding: EdgeInsets.only(right: 16),
                            ),
                            Expanded(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                        child: Text(
                                            getDeptName(item?.listDeptSelected),
                                            textAlign: TextAlign.end)),
                                    Icon(Icons.arrow_drop_down_outlined)
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: SaveButton(
                        title: "Xong",
                        onTap: () {
                          if (item?.positionSelected == null) {
                            showErrorToast("Bạn chưa chọn chức vụ");
                            return;
                          }
                          if (isNullOrEmpty(item?.listDeptSelected)) {
                            showErrorToast("Bạn chưa chọn phòng ban");
                            return;
                          }
                          if (isAdd)
                            _assignRepository.addPositionAndDept(item);
                          else {
                            _assignRepository.updatePositionAndDept(item);
                          }
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  String getDeptName(List<HandlerInfo> list) {
    if (isNullOrEmpty(list)) return "Chọn phòng ban";
    return list.map((e) => e.name).toList().join(", ");
  }

  Widget _buildFirstIcon(int index) {
    return InkWell(
      onTap: () {
        FocusScopeNode focusScopeNode = FocusScope.of(context);
        focusScopeNode.unfocus();
        switch (index) {
          case 0:
            {
              onAddEmployee();
              break;
            }
          case 1:
            {
              onAddDept();
              break;
            }
          case 2:
            {
              onAddTeam();
              break;
            }
          case 3:
            {
              onAddPosition(null);
              break;
            }
        }
      },
      child: Container(
        height: _sizeCircle,
        width: _sizeCircle,
        margin:
            EdgeInsets.only(top: _padding, bottom: _padding, right: _padding),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.blue),
            borderRadius: BorderRadius.all(Radius.circular(200))),
        child: Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

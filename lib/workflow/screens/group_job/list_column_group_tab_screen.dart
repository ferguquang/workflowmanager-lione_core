import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/event/open_filter_task_group_event.dart';
import 'package:workflow_manager/workflow/models/params/list_tab_group_request.dart';
import 'package:workflow_manager/workflow/screens/create_job/create_job_screen.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_job_detail_main/group_job_details_screen.dart';
import 'package:workflow_manager/workflow/screens/group_job/repository/column_group_repository.dart';

import '../../../main.dart';
import 'list_column_group_screen.dart';

class ListColumnGroupTabScreen extends StatefulWidget {
  int idGroup;
  String nameGroupJob = '';
  int idStatus;

  ListColumnGroupTabScreen({this.idGroup, this.nameGroupJob, this.idStatus});

  @override
  State<StatefulWidget> createState() {
    return _ListColumnGroupTabScreenState();
  }
}

class _ListColumnGroupTabScreenState extends State<ListColumnGroupTabScreen>
    with TickerProviderStateMixin {
  ColumnGroupRepository _taskGroupRepository = ColumnGroupRepository();
  int role = 2;
  @override
  void initState() {
    super.initState();
    getListTabColumnGroup();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
    eventBus.on<GetRoleEventBus>().listen((event) {
      role = event.role;
      _taskGroupRepository.notifyListeners();
    });
  }

  void getListTabColumnGroup() {
    GetListTabGroupRequest request = GetListTabGroupRequest();
    request.idGroupJob = this.widget.idGroup;
    this._taskGroupRepository.getListTabColumnGroup(request);
  }

  Widget _buildMenu(IconData icon, String text) {
    return Row(children: [
      Icon(
        icon,
        color: Colors.grey,
      ),
      Text('  $text')
    ]);
  }

  _addColumn(int index) {
    TextEditingController controller = TextEditingController();
    Widget content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(labelText: "Nhập tên cột"),
          )
        ]);
    ConfirmDialogFunction confirmDialogFunction = ConfirmDialogFunction(
      title: "Thêm cột".toUpperCase(),
      context: context,
      widgetContent: content,
      onAccept: () {
        if (isNotNullOrEmpty(controller.text)) {
          _taskGroupRepository.addColumn(controller.text, widget.idGroup);
        } else {
          ToastMessage.show('Tên cột' + textNotLeftBlank, ToastStyle.error);
        }
      },
    );
    confirmDialogFunction.showConfirmDialog();
  }

  _editColumn(int index, String nameCol) {
    TextEditingController controller = TextEditingController(text: nameCol);
    Widget content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(labelText: "Nhập tên cột"),
          )
        ]);
    ConfirmDialogFunction confirmDialogFunction = ConfirmDialogFunction(
      title: "Sửa tên cột".toUpperCase(),
      context: context,
      widgetContent: content,
      onAccept: () {
        if (isNotNullOrEmpty(controller.text)) {
          _taskGroupRepository.editColumn(controller.text, widget.idGroup,
              _taskGroupRepository.arrayItemTabGroup[index].iD);
        } else {
          ToastMessage.show('Tên cột' + textNotLeftBlank, ToastStyle.error);
        }
      },
    );
    confirmDialogFunction.showConfirmDialog();
  }

  _deleteColumn(int index) {
    ConfirmDialogFunction confirmDialogFunction = ConfirmDialogFunction(
      context: context,
      content: "Bạn có muốn xóa cột này?",
      onAccept: () {
        _taskGroupRepository.deleteColumn(
            _taskGroupRepository.arrayItemTabGroup[index].iD, widget.idGroup);
      },
    );
    confirmDialogFunction.showConfirmDialog();
  }

  GlobalKey _scaffoldKey = GlobalKey();

  List<PopupMenuItem> _getListMenus() {
    List<PopupMenuItem> menus = [
      PopupMenuItem(
          value: 0, child: _buildMenu(Icons.add_box_outlined, "Chi tiết nhóm")),
      PopupMenuItem(
        value: 1,
        child: _buildMenu(Icons.add, "Tạo công việc"),
      ),
    ];
    if (role == 1) {
      menus.addAll([
        PopupMenuItem(
          value: 2,
          child: _buildMenu(Icons.add_chart, "Thêm cột"),
        ),
        PopupMenuItem(
          value: 3,
          child: _buildMenu(Icons.edit, "Sửa tên cột"),
        ),
        PopupMenuItem(
          value: 4,
          child: _buildMenu(Icons.delete_outline_sharp, "Xóa cột"),
        ),
      ]);
    }
    return menus;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _taskGroupRepository,
      child: Consumer(
        builder: (context, ColumnGroupRepository repository, _) {
          return Scaffold(
            appBar: AppBar(
                title: Text(widget.nameGroupJob), actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.filter_alt,
                  color: Colors.white,
                ),
                onPressed: () {
                  eventBus.fire(OpenFilterTaskGroupEvent());
                },
              ),
              PopupMenuButton(
                    child: Container(child: Icon(Icons.more_vert)),
                    onSelected: (value) {
                      switch (value) {
                        case 0:
                          {
                            //mở chi tiết
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    GroupJobDetailsScreen(this.widget.idGroup),
                              ),
                            );
                            break;
                          }
                        case 1: //tạo công việc
                          {
                            int index = DefaultTabController.of(
                                    _scaffoldKey.currentContext)
                                .index;
                            _eventClickCreateJob(context, this.widget.idGroup,
                                repository.arrayItemTabGroup[index].iD, index);
                            break;
                          }
                        case 2: //thêm cột
                          {
                            _addColumn(DefaultTabController.of(
                                    _scaffoldKey.currentContext)
                                .index);
                            break;
                          }
                        case 3: //sửa thêm cột
                          {
                            int index = DefaultTabController.of(
                                    _scaffoldKey.currentContext)
                                .index;
                            _editColumn(index,
                                repository.arrayItemTabGroup[index].colTitle);
                            break;
                          }
                        case 4: //xóa cột
                          {
                            _deleteColumn(DefaultTabController.of(
                                    _scaffoldKey.currentContext)
                                .index);

                            break;
                          }
                      }
                    },
                    itemBuilder: (context) {
                      return _getListMenus();
                    },
                  )
                ]),
            body: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(
                //       left: 16, top: 16, right: 16, bottom: 8),
                //   child: Text(
                //     widget.nameGroupJob,
                //     maxLines: 2,
                //     overflow: TextOverflow.ellipsis,
                //     style: TextStyle(fontSize: 20, color: Colors.black),
                //   ),
                // ),
                Expanded(
                  child: DefaultTabController(
                    length: repository.arrayItemTabGroup.length,
                    child: Scaffold(
                      key: _scaffoldKey,
                      appBar: new PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: new Container(
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: new SafeArea(
                            child: new TabBar(
                              isScrollable: true,
                              labelColor: Colors.blue,
                              unselectedLabelColor: Colors.grey,
                              labelPadding:
                                  EdgeInsets.symmetric(horizontal: 10),
                              tabs: repository.tabItem.isEmpty
                                  ? <Widget>[]
                                  : repository.tabItem,
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: repository.arrayItemTabGroup.isEmpty
                            ? <Widget>[]
                            : repository.arrayItemTabGroup.map((content) {
                                return ListColumnGroupScreen(
                                  idGroup: this.widget.idGroup,
                                  idGroupCol: content.iD,
                                  idStatus: widget.idStatus,
                                );
                              }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _eventClickCreateJob(context, iIDGroup, iIDGroupCol, index) async {
    await pushPage(context, CreateJobScreen(true, iIDGroup, iIDGroupCol, 0, 0));
    eventBus.fire(ReloadEventBus());
  }
}

class GetRoleEventBus {
  int role;

  GetRoleEventBus(this.role);
}

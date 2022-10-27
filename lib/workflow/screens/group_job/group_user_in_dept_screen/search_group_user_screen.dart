import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/workflow/models/wait_next_action.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_dept_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_user_in_dept_screen/search_group_user_repository.dart';
import 'package:workflow_manager/workflow/screens/group_job/search_dept_screen/search_cell.dart';
import 'package:workflow_manager/workflow/screens/group_job/search_dept_screen/search_dept_screen_repository.dart';
import 'package:workflow_manager/workflow/screens/search_user/cells/search_user_cell.dart';
import 'package:workflow_manager/workflow/screens/search_user/search_user_screen_repository.dart';
import 'package:workflow_manager/base/extension/string.dart';

class SearchGroupUserScreen extends StatefulWidget {
  final void Function(SharedSearchModel) onGroupUserSelected;
  int iDGroupJob;
  int iDDept;
  List<int> userList;

  SearchGroupUserScreen(this.iDGroupJob, this.iDDept, this.userList,
      {this.onGroupUserSelected});

  @override
  State<StatefulWidget> createState() {
    return _SearchDeptScreen();
  }
}

class _SearchDeptScreen extends State<SearchGroupUserScreen>
    with AutomaticKeepAliveClientMixin {
  WaitNextAction _searchAction;

  SearchGroupUserRepository _searchGroupUserRepository =
      SearchGroupUserRepository();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String name;

  searchName(String name) {
    _searchGroupUserRepository.request.search_name = name;
    _searchGroupUserRepository.page = 1;
    _searchGroupUserRepository.getUserByName(
        name, widget.iDGroupJob, widget.iDDept, widget.userList);
    this.name = name;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchAction = new WaitNextAction<String>(searchName);
    _searchGroupUserRepository.getUserByName(
        name, widget.iDGroupJob, widget.iDDept, widget.userList);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _searchGroupUserRepository,
      child: Consumer(
        builder: (context,
            SearchGroupUserRepository searchGroupUserRepository, _) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: 16, top: 8, right: 8, bottom: 8),
                          padding: EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: "F5F6FA".toColor(),
                          ),
                          child: TextField(
                            style: TextStyle(fontSize: 15 /*, height: 3*/),
                            onChanged: (value) {
                              _searchAction.action(value);
                            },
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm nhân viên',
                              hintStyle: TextStyle(fontSize: 15),
                              enabledBorder: new UnderlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white)),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              icon: Icon(
                                Icons.search,
                                color: Colors.grey,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      FlatButton(
                          minWidth: 20,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Hủy',
                            style: TextStyle(
                                fontSize: 14, color: "00689D".toColor()),
                          )),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: "778E9E".toColor(),
                  ),
                  Expanded(
                      child: SmartRefresher(
                        enablePullDown: false,
                        enablePullUp: true,
                        controller: _refreshController,
                        onLoading: _onLoading,
                        child: this
                            ._buildListView(searchGroupUserRepository.data),
                        footer: CustomFooter(
                          builder: (BuildContext context, LoadStatus mode) {
                            Widget body;
                            if (mode == LoadStatus.idle) {} else
                            if (mode == LoadStatus.loading) {
                              body = CupertinoActivityIndicator();
                            } else if (mode == LoadStatus.failed) {} else
                            if (mode == LoadStatus.canLoading) {} else {}

                        return Container(
                          child: Center(
                            child: body,
                          ),
                        );
                      },
                    ),
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(data) {
    return ListView.separated(
      itemCount: data?.length ?? 0,
      itemBuilder: (context, index) {
        SharedSearchModel _item = data[index];
        return InkWell(
          child: SearchCell(
            name: _item.name,
          ),
          onTap: () {
            this.widget.onGroupUserSelected(_item);
            Navigator.of(context).pop();
          },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  void _onLoading() async {
    _refreshController.loadComplete();
    _searchGroupUserRepository.getUserByName(
        name, widget.iDGroupJob, widget.iDDept, widget.userList);
  }
}

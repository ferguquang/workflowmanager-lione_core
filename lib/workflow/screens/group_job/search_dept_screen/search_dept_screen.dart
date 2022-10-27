import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/wait_next_action.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/group_dept_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/search_dept_screen/search_cell.dart';
import 'package:workflow_manager/workflow/screens/group_job/search_dept_screen/search_dept_screen_repository.dart';
import 'package:workflow_manager/workflow/screens/search_user/cells/search_user_cell.dart';
import 'package:workflow_manager/workflow/screens/search_user/search_user_screen_repository.dart';
import 'package:workflow_manager/base/extension/string.dart';

class SearchDeptScreen extends StatefulWidget {
  final void Function(GroupDeptModel) onDeptSelected;
  GroupDeptModel deptSelected;

  SearchDeptScreen({this.onDeptSelected, this.deptSelected});

  @override
  State<StatefulWidget> createState() {
    return _SearchDeptScreen();
  }
}

class _SearchDeptScreen extends State<SearchDeptScreen>
    with AutomaticKeepAliveClientMixin {
  WaitNextAction _searchAction;

  SearchDeptScreenRepository _searchDeptScreenRepository =
      SearchDeptScreenRepository();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String name;

  searchName(String name) {
    _searchDeptScreenRepository.request.search_name = name;
    _searchDeptScreenRepository.page = 1;
    _searchDeptScreenRepository.getDeptName(name);
    this.name = name;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchAction = new WaitNextAction<String>(searchName);
    _searchDeptScreenRepository.getDeptName(null);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _searchDeptScreenRepository,
      child: Consumer(
        builder: (context,
            SearchDeptScreenRepository searchDeptScreenRepository, _) {
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
                              hintText: 'Tìm kiếm phòng ban',
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
                        ._buildListView(searchDeptScreenRepository.deptData),
                    footer: CustomFooter(
                      builder: (BuildContext context, LoadStatus mode) {
                        Widget body;
                        if (mode == LoadStatus.idle) {
                        } else if (mode == LoadStatus.loading) {
                          body = CupertinoActivityIndicator();
                        } else if (mode == LoadStatus.failed) {
                        } else if (mode == LoadStatus.canLoading) {
                        } else {}

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

  Widget _buildListView(List<GroupDeptModel> listData) {
    if (isNullOrEmpty(listData)) {
      return EmptyScreen();
    }

    if (widget.deptSelected != null) {
      listData.forEach((element) {
        if (element.iD == widget.deptSelected.iD) {
          element.isSelected = true;
        } else {
          element.isSelected = false;
        }
      });
    }

    return ListView.separated(
      itemCount: listData?.length ?? 0,
      itemBuilder: (context, index) {
        return InkWell(
          child: Row(
            children: [
              Expanded(
                child: SearchCell(
                  name: listData[index].name,
                ),
              ),
              Visibility(
                visible: listData[index].isSelected ?? false,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.check, color: Colors.blue,),
                ),
              )
            ],
          ),
          onTap: () {
            for (int i = 0; i < listData.length; i++) {
              if (listData[index].iD == listData[i].iD) {
                if (listData[i].isSelected == true) {
                  listData[i].isSelected = false;
                } else {
                  listData[i].isSelected = true;
                }
              } else {
                listData[i].isSelected = false;
              }
            }

            this.widget.onDeptSelected(listData[index]);
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
    _searchDeptScreenRepository.getDeptName(name);
  }
}

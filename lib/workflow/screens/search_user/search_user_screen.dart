import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';
import 'package:workflow_manager/workflow/models/wait_next_action.dart';
import 'package:workflow_manager/workflow/screens/search_user/cells/search_user_cell.dart';
import 'package:workflow_manager/workflow/screens/search_user/search_user_screen_repository.dart';

class SearchUserScreen extends StatefulWidget {
  final void Function(UserItem) onUserSelected;

  bool isJobGroup;

  UserItem selectUserItem;

  SearchUserScreen({this.onUserSelected, this.isJobGroup, this.selectUserItem});

  @override
  State<StatefulWidget> createState() {
    return _SearchUserScreen();
  }
}

class _SearchUserScreen extends State<SearchUserScreen>
    with AutomaticKeepAliveClientMixin {
  WaitNextAction _searchAction;

  SearchUserScreenRepository _searchUserScreenRepository =
      SearchUserScreenRepository();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  searchName(String name) {
    _searchUserScreenRepository.request.search_name = name;
    _searchUserScreenRepository.page = 1;
    if (this.widget.isJobGroup) {
      _searchUserScreenRepository.getJobGroupForSearch();
    } else {
      _searchUserScreenRepository.getListUserName();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _searchAction = new WaitNextAction<String>(searchName);
    if (this.widget.isJobGroup) {
      _searchUserScreenRepository.getJobGroupForSearch();
    } else {
      _searchUserScreenRepository.getListUserName();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _searchUserScreenRepository,
      child: Consumer(
        builder: (context, SearchUserScreenRepository repository, _) {
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
                              hintText: this.widget.isJobGroup
                                  ? 'Tìm kiếm tên nhóm công việc'
                                  : 'Tìm kiếm họ tên',
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
                    child: isNotNullOrEmpty(repository.userData)
                        ? this._buildListView(repository.userData)
                        : EmptyScreen(),
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

  Widget _buildListView(data) {
    if (isNotNullOrEmpty(widget.selectUserItem)) {
      for (var item in data) {
        if (item.iD == widget.selectUserItem.iD) {
          item.isSelected = true;
        } else {
          item.isSelected = false;
        }
      }
    } else {
      for (var item in data) {
        item.isSelected = false;
      }
    }
    return ListView.separated(
      itemCount: data?.length ?? 0,
      itemBuilder: (context, index) {
        UserItem _item = data[index];
        return InkWell(
          child: SearchUserCell(
            user: _item,
          ),
          onTap: () {
            if (widget.selectUserItem?.iD == _item.iD) {
              _item.isSelected = false;
            } else {
              _item.isSelected = true;
            }

            this.widget.onUserSelected(_item);
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
    if (this.widget.isJobGroup) {
      _searchUserScreenRepository.getJobGroupForSearch();
    } else {
      _searchUserScreenRepository.getListUserName();
    }
  }
}

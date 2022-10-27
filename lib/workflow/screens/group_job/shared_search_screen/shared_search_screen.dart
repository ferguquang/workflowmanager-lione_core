import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/wait_next_action.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/search_dept_screen/search_cell.dart';
import 'package:workflow_manager/workflow/screens/group_job/shared_search_screen/shared_search_screen_repository.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';

class SharedSearchScreen extends StatefulWidget {
  final void Function(SharedSearchModel) onSharedSearchSelected;
  SharedSearchModel modelSelected;
  String apiLink;
  Map<String, dynamic> params;
  String hint;

  SharedSearchScreen(this.apiLink, this.hint,
      {this.onSharedSearchSelected, this.params, this.modelSelected});

  @override
  State<StatefulWidget> createState() {
    return _SearchDeptScreen();
  }
}

class _SearchDeptScreen extends State<SharedSearchScreen>
    with AutomaticKeepAliveClientMixin {
  WaitNextAction _searchAction;

  ShareSearchScreenRepository _shareSearchScreenRepository;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String name;

  searchName(String name) {
    _shareSearchScreenRepository.request.search_name = name;
    _shareSearchScreenRepository.page = 1;
    _shareSearchScreenRepository.getByName(name);
    this.name = name;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _shareSearchScreenRepository =
        ShareSearchScreenRepository(widget.apiLink, params: widget.params);
    _searchAction = new WaitNextAction<String>(searchName);
    _shareSearchScreenRepository.getByName(null);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _shareSearchScreenRepository,
      child: Consumer(
        builder: (context,
            ShareSearchScreenRepository searchDeptScreenRepository, _) {
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
                              hintText: widget.hint ?? "",
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
                    color: Colors.grey[300],
                  ),
                  Expanded(
                      child: SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    controller: _refreshController,
                    onLoading: _onLoading,
                    child: this._buildListView(
                        searchDeptScreenRepository.sharedSearchData),
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

  Widget _buildListView(List<SharedSearchModel> listData) {
    if (isNullOrEmpty(listData)) {
      return EmptyScreen();
    }

    if (widget.modelSelected != null) {
      for (int i = 0 ; i < listData.length; i++) {
        if (widget.modelSelected.iD == listData[i].iD) {
          listData[i].isCheck = true;
        } else {
          listData[i].isCheck = false;
        }
      }
    }

    return ListView.separated(
      itemCount: listData?.length ?? 0,
      itemBuilder: (context, index) {
        SharedSearchModel _item = listData[index];
        return InkWell(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SearchCell(
                  name: _item.name,
                ),
              ),
              Visibility(
                visible:  _item.isCheck,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Icon(Icons.check, color: Colors.blue,),
                ),
              )
            ],
          ),
          onTap: () {
            if (this.widget.onSharedSearchSelected != null) {
              int keySelected = listData[index].iD;
              for (int i = 0; i < listData.length; i ++) {
                if (listData[i].iD == keySelected) {
                  if (listData[i].isCheck) {
                    listData[i].isCheck = false;
                  } else {
                    listData[i].isCheck = true;
                  }
                } else {
                  listData[i].isCheck = false;
                }
              }

              if (listData[index].isCheck) {
                // request.priority = listData[index];
                this.widget.onSharedSearchSelected(listData[index]);
              } else {
                // request.priority = null;
                this.widget.onSharedSearchSelected(null);
              }
            }
            Navigator.of(context).pop(_item);
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
    _shareSearchScreenRepository.getByName(name);
  }
}

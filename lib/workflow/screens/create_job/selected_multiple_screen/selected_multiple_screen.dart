import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/workflow/models/wait_next_action.dart';
import 'package:workflow_manager/workflow/screens/create_job/selected_multiple_screen/selected_multiple_repository.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';

// ignore: must_be_immutable
class SelectMultipleScreen extends StatefulWidget {
  final void Function(List<SharedSearchModel>) onSharedSearchSelected;
  String apiLink;
  Map<String, dynamic> params;
  String hint;
  List<SharedSearchModel> listSelected;
  String messageCheckNull;

  SelectMultipleScreen(this.apiLink, this.hint,
      {this.onSharedSearchSelected,
      this.params,
      this.listSelected,
      this.messageCheckNull});

  @override
  State<StatefulWidget> createState() {
    return _SelectMultipleState();
  }
}

class _SelectMultipleState extends State<SelectMultipleScreen>
    with AutomaticKeepAliveClientMixin {
  WaitNextAction _searchAction;

  SelectMultipleRepository _shareSearchScreenRepository;

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
        SelectMultipleRepository(widget.apiLink, params: widget.params);
    _shareSearchScreenRepository.listSelected = widget.listSelected ?? [];
    _searchAction = new WaitNextAction<String>(searchName);
    _shareSearchScreenRepository.getByName(null);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _shareSearchScreenRepository,
      child: Consumer(
        builder:
            (context, SelectMultipleRepository searchDeptScreenRepository, _) {
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
                    color: "778E9E".toColor(),
                  ),
                  Expanded(
                      child: SmartRefresher(
                    enablePullDown: false,
                    enablePullUp: true,
                    controller: _refreshController,
                    onLoading: _onLoading,
                    child: this._buildListView(searchDeptScreenRepository),
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
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: SaveButton(
                      title: "Lưu",
                      onTap: () {
                        _eventClickSave(
                            _shareSearchScreenRepository.listSelected);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(SelectMultipleRepository searchDeptScreenRepository) {
    List<SharedSearchModel> data = searchDeptScreenRepository.sharedSearchData;
    return data?.length == 0
        ? EmptyScreen()
        : ListView.separated(
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemCount: data?.length ?? 0,
            itemBuilder: (context, index) {
              SharedSearchModel _item = data[index];
              return ListTile(
                onTap: () {
                  searchDeptScreenRepository.isCheckUpdateIcon(_item);
                },
                title: Text(
                  _item.name,
                  style: TextStyle(fontSize: 14),
                ),
                trailing: Icon(
                  _item.isCheck ? Icons.check : null,
                  color: Colors.grey,
                ),
              );
            },
          );
  }

  void _onLoading() async {
    _refreshController.loadComplete();
    _shareSearchScreenRepository.getByName(name);
  }

  void _eventClickSave(listData) {
    if (widget.messageCheckNull != null && listData.length == 0) {
      ToastMessage.show(widget.messageCheckNull, ToastStyle.error);
      return;
    }
    print('abcccccccLength: ${listData.length}');
    if (this.widget.onSharedSearchSelected != null)
      this.widget.onSharedSearchSelected(listData);
    Navigator.of(context).pop(listData);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/borrowPayDocument/model/request/selected_user_search_request.dart';
import 'package:workflow_manager/borrowPayDocument/model/response/borrow_auser_response.dart';
import 'package:workflow_manager/borrowPayDocument/screen/register_borrow_document/detai_register_borrow_document/select_user_single_screen/select_user_search_item.dart';
import 'package:workflow_manager/borrowPayDocument/screen/register_borrow_document/detai_register_borrow_document/select_user_single_screen/select_user_search_repository.dart';
import 'package:workflow_manager/workflow/models/wait_next_action.dart';

class SelectedUserSearchScreen extends StatefulWidget {
  final void Function(AUser user) onSharedSearchSelected;
  SelectedUserSearchRequest request;
  int idUserSelected;
  String hint;

  SelectedUserSearchScreen(
      {this.idUserSelected,
      this.request,
      this.onSharedSearchSelected,
      this.hint});

  @override
  State<StatefulWidget> createState() {
    return _SelectedUseSearchState();
  }
}

class _SelectedUseSearchState extends State<SelectedUserSearchScreen>
    with AutomaticKeepAliveClientMixin {
  WaitNextAction _searchAction;

  SelectedUserSearchRepository _selectedUserSearchRepository =
      SelectedUserSearchRepository();

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String name;

  searchName(String name) {
    _selectedUserSearchRepository.getByName(name);
    this.name = name;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _selectedUserSearchRepository.idUserSelected = widget.idUserSelected;
    _selectedUserSearchRepository.request = widget.request;
    _searchAction = new WaitNextAction<String>(searchName);
    _selectedUserSearchRepository.getByName(null);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _selectedUserSearchRepository,
      child: Consumer(
        builder: (context,
            SelectedUserSearchRepository selectedUseSearchRepository, _) {
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
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              _searchAction.action(value);
                            },
                            decoration: InputDecoration(
                              hintText:
                                  'Tìm kiếm theo tên ${widget.hint.toLowerCase()}',
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
                    child: this
                        ._buildListView(selectedUseSearchRepository.userData),
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

  Widget _buildListView(List<AUser> data) {
    return data?.length == 0
        ? EmptyScreen()
        : ListView.separated(
            itemCount: data?.length ?? 0,
            itemBuilder: (context, index) {
              AUser _item = data[index];
              return InkWell(
                child: SelectedUserSearchItem(_item),
                onTap: () {
                  if (this.widget.onSharedSearchSelected != null)
                    this.widget.onSharedSearchSelected(_item);
                  Navigator.of(context).pop(_item);
                },
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
  }
}

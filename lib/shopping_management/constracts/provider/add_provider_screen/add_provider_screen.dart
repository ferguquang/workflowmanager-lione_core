import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/commons/separator_header_widget.dart';
import 'package:workflow_manager/shopping_management/constracts/provider/add_new_provider/add_new_provider_screen.dart';
import 'package:workflow_manager/shopping_management/response/search_provider_reponse.dart';
import 'package:workflow_manager/workflow/models/wait_next_action.dart';

import 'add_provider_repository.dart';

class AddProviderScreen extends StatefulWidget {
  int providerId;
  List<int> selectedIds;

  AddProviderScreen(this.providerId, this.selectedIds);

  @override
  _AddProviderScreenState createState() => _AddProviderScreenState();
}

class _AddProviderScreenState extends State<AddProviderScreen> {
  AddProviderRepository _addProviderRepository = AddProviderRepository();
  bool isShowSearch = false;

  RefreshController _refreshController = RefreshController();
  Providers selected;
  WaitNextAction<String> _waitNextAction;

  search(String name) {
    _addProviderRepository.params.codeName = name;
    _addProviderRepository.refreshData();
  }

  @override
  void initState() {
    super.initState();
    _addProviderRepository.selectedIds = widget.selectedIds;
    _addProviderRepository.refreshController = _refreshController;
    _addProviderRepository.refreshData();
    _waitNextAction = WaitNextAction(search, duration: Duration(seconds: 1));
  }

  Widget getTitle() {
    if (isShowSearch) {
      return TextField(
        onChanged: (value) => _waitNextAction.action(value),
        style: TextStyle(
          color: Colors.white,
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(color: Colors.white),
            isDense: true,
            contentPadding: EdgeInsets.all(0),
            hintText: "Nhập tên nhà cung cấp"),
      );
    }
    return Text("Chọn nhà cung cấp".toUpperCase());
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _addProviderRepository,
      child: Consumer(
        builder: (context, AddProviderRepository addProviderRepository, child) {
          return Scaffold(
            appBar: AppBar(
              title: getTitle(),
              actions: [
                InkWell(
                    onTap: () {
                      setState(() {
                        isShowSearch = !isShowSearch;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                    ))
              ],
            ),
            floatingActionButton: Container(
              margin: EdgeInsets.only(bottom: 60),
              child: FloatingActionButton(
                onPressed: () async {
                  bool isSuccess = await pushPage(
                      context,
                      await AddNewProviderScreen(
                          widget.providerId,
                          AddNewProviderScreen.TYPE_CREATE,
                          _addProviderRepository
                              .searchProviderModel.searchParam.regions,
                          _addProviderRepository
                              .searchProviderModel.searchParam.categorys,
                          _addProviderRepository
                              .searchProviderModel.searchParam.nations));
                  if (isSuccess) {
                    _addProviderRepository.refreshData();
                  }
                },
                child: Icon(Icons.add),
              ),
            ),
            body: Column(
              children: [
                SeparatorHeaderWidget(
                    "Nếu chưa có bạn có thể thêm mới nhà cung cấp"
                        .toUpperCase()),
                Expanded(
                  child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropHeader(),
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
                            height: 55.0,
                            child: Center(
                              child: body,
                            ),
                          );
                        },
                      ),
                      controller: _refreshController,
                      onLoading: () {
                        _addProviderRepository.loadMore();
                      },
                      onRefresh: () {
                        _addProviderRepository.refreshData();
                      },
                      child: isNullOrEmpty(_addProviderRepository
                              ?.searchProviderModel?.providers)
                          ? Center(
                              child: Text("Không có dữ liệu"),
                            )
                          : ListView.builder(
                              itemCount: _addProviderRepository
                                      ?.searchProviderModel
                                      ?.providers
                                      ?.length ??
                                  0,
                              itemBuilder: (context, index) {
                                Providers provider = _addProviderRepository
                                    ?.searchProviderModel?.providers[index];
                                return InkWell(
                                  onTap: () {
                                    selected = provider;
                                    _addProviderRepository.notifyListeners();
                                  },
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(provider.name)),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        child: selected != null &&
                                                selected?.iD == provider?.iD
                                            ? Icon(
                                                Icons.radio_button_checked,
                                                color: Colors.blue,
                                                size: 20,
                                              )
                                            : Icon(
                                                Icons.radio_button_unchecked,
                                                size: 20,
                                              ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(
                                  height: 1,
                                  thickness: 1,
                                )
                              ],
                            ),
                          );
                        },
                      )),
                ),
                SaveButton(
                  title: "Chọn",
                  margin: EdgeInsets.all(16),
                  onTap: () {
                    Navigator.pop(context, selected);
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

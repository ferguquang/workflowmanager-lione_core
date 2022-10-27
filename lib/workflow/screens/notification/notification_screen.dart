import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/loading_dialog.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';
import 'package:workflow_manager/base/utils/one_signal_manager.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/workflow/models/notification_model.dart';
import 'package:workflow_manager/workflow/models/wait_next_action.dart';

import 'notification_item.dart';
import 'notification_repository.dart';
import 'package:rxdart/rxdart.dart';

class NotificationScreen extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _NotificationScreenState();
  }
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationRepository _notificationRepository = NotificationRepository();

  WaitNextAction<String> _waitNextAction;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  TextEditingController _searchController = TextEditingController();

  doAction(String term) {
    _notificationRepository.pullToRefreshData();
    _notificationRepository.getNotification(term: term, isSearch: true);
  }

  @override
  void dispose() {
    _waitNextAction.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _waitNextAction =
        WaitNextAction(doAction, duration: Duration(milliseconds: 200));
    _notificationRepository.getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => _notificationRepository,
      child: Consumer(
        builder: (context, NotificationRepository repository, _) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Thông báo'),
              actions: [
                InkWell(
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: SVGImage(
                        svgName: "check_square",
                      )),
                  onTap: () {
                    _getApiStatus();
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: "EFF0F5".toColor(),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: SVGImage(
                            svgName: "ic_search",
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 8),
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(fontSize: 14),
                              textInputAction: TextInputAction.search,
                              controller: _searchController,
                              onChanged: (value) {
                                _waitNextAction.action(value);
                              },
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                hintText: 'Tìm kiếm',
                                hintStyle: TextStyle(color: Colors.grey),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
                                  borderSide: BorderSide(
                                      color: "EFF0F5".toColor(), width: 0.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  //Add this to your code...
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(0)),
                                  borderSide: BorderSide(
                                      color: "EFF0F5".toColor(), width: 0.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _searchController.text.length > 0,
                          child: IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              icon: Icon(Icons.cancel),
                              color: Colors.grey,
                              onPressed: () {
                                _searchController.text = "";
                                _waitNextAction.action("");
                              }),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: SmartRefresher(
                        controller: _refreshController,
                    enablePullDown: true,
                    enablePullUp: true,
                    header: WaterDropHeader(),
                    child: repository.notificationList.length > 0
                        ? this._buildListView(repository.notificationList)
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
                          height: 55.0,
                          child: Center(
                            child: body,
                          ),
                        );
                      },
                    ),
                    onRefresh: () {
                      _onRefresh();
                    },
                    onLoading: () {
                      _refreshController.loadComplete();
                      _notificationRepository.getNotification();
                    },
                  )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _getApiStatus() async {
    await _notificationRepository.markNotificationReaded(null);
    _onRefresh();
    eventBus.fire(EventBusSendNumberNotificaiton(0));
  }

  Widget _buildListView(List<NotificationInfos> data) {
    return ListView.builder(
      itemCount: data?.length ?? 0,
      itemBuilder: (context, index) {
        return InkWell(
          child: NotificationItem(data[index]),
          onTap: () {
            // int type = data[index].type;
            // int iDContent = data[index].iDContent;
            NotificationInfos notificationInfos = data[index];
            OneSignalManager.instance
                .navigationTargetScreen(context, notificationInfos);
            // Đánh dấu đã đọc
            if (!notificationInfos.isReaded) {
              _notificationRepository.markNotificationReaded(data[index].iD);
              setState(() {
                data[index].isReaded = true;
                eventBus.fire(EventBusSendNumberNotificaiton(1));
              });
            }
          },
        );
      },
      // separatorBuilder: (context, index) {
      //   return Container();
      // },
    );
  }

  void _onRefresh() async {
    _refreshController.refreshCompleted();
    _notificationRepository.pullToRefreshData();
    _notificationRepository.getNotification();
  }
}

class EventBusSendNumberNotificaiton {
  int number;

  EventBusSendNumberNotificaiton(this.number);
}

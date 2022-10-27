import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/storage/screens/list_storage/list_storage_screen.dart';
import 'package:workflow_manager/storage/screens/search/search_storage_screen.dart';

import 'main_tab_storage_screen.dart';

class ItemTabStorageScreen extends StatefulWidget {
  StorageBottomTabType type;

  ItemTabStorageScreen({this.type});

  @override
  State<StatefulWidget> createState() {
    return _ItemTabStorageScreen();
  }
}

class _ItemTabStorageScreen extends State<ItemTabStorageScreen>
    with TickerProviderStateMixin {
  final List<Tab> tabs = <Tab>[
    Tab(
      child: Text(
        'Thư mục/tài liệu',
        style: TextStyle(fontSize: 14),
      ),
    ),
    Tab(
      text: 'Đã ghim',
    ),
    Tab(
      text: 'Xem gần đây',
    )
  ];

  ListStorageScreen documentScreen;

  ListStorageScreen ghimScreen;

  ListStorageScreen recentlyScreen;

  String title = 'Kho dữ liệu';

  @override
  void dispose() {
    super.dispose();
    if (documentScreen?.changeTabSubs != null)
      documentScreen.changeTabSubs.cancel();
    if (ghimScreen?.changeTabSubs != null) ghimScreen.changeTabSubs.cancel();
    if (recentlyScreen?.changeTabSubs != null)
      recentlyScreen.changeTabSubs.cancel();
  }

  @override
  void initState() {
    super.initState();
    switch (widget.type) {
      case StorageBottomTabType.DataStorage:
        title = 'Kho dữ liệu';
        break;
      case StorageBottomTabType.MyFile:
        title = 'Tài liệu cá nhân';
        break;
      case StorageBottomTabType.Shared:
        title = 'Tài liệu chia sẻ';
        break;
    }
    documentScreen = ListStorageScreen(
      typeStorage: StorageTopTabType.Document,
      type: this.widget.type,
    );

    ghimScreen = ListStorageScreen(
        typeStorage: StorageTopTabType.Pin, type: this.widget.type);

    recentlyScreen = ListStorageScreen(
        typeStorage: StorageTopTabType.Recently, type: this.widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this.appBarWidget(),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              color: Colors.white,
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new Expanded(
                      child: new Container(),
                    ),
                    new TabBar(
                      isScrollable: false,
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      tabs: this.tabs,
                      onTap: _onItemTapped,
                    )
                  ],
                ),
              ),
            ),
          ),
          body: TabBarView(
            // controller: _tabController,
            children: [
              documentScreen,
              ghimScreen,
              recentlyScreen,
            ],
          ),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
    }
  }

  // appbar
  Widget appBarWidget() {
    return AppBar(
      title: Text(title),
      leading: BackIconButton(),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            pushPage(context,
                SearchStorageScreen(StorageTopTabType.Document, widget.type));
          },
        ),
        Visibility(
          visible: false,
          child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: PopupMenuButton(
              child: Icon(Icons.more_vert),
              onSelected: (value) {
                setState(() {
                  switch (value) {
                    case 0:
                      // this._execSortBy();
                      break;
                    case 1:
                      // this._eventClickPopUpMenu(value);
                      break;
                    case 2:
                      // setState(() {
                      //   isShowAction = 1;
                      //   _listStorageRepository.listCheckDocs.clear();
                      //   _listStorageRepository.listDocs?.forEach((element) {
                      //     element?.isCheck = false;
                      //   });
                      // });
                      break;
                  }
                });
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 0,
                    child: Text("Sắp xếp theo"),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text("Chọn tất cả"),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Text("Xóa lựa chọn"),
                  ),
                ];
              },
            ),
          ),
        ),
      ],
    );
  }
}

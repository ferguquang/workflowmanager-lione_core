
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/app_store.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/storage/models/events/change_tab_event.dart';
import 'package:workflow_manager/storage/screens/tabs/item_tab_storage_screen.dart';
import 'package:workflow_manager/storage/screens/list_storage/list_storage_screen.dart';
import 'package:workflow_manager/storage/screens/search/search_storage_screen.dart';
import 'package:workflow_manager/workflow/models/event/view_mode_event.dart';

import '../../../main.dart';

class MainTabStorageScreen extends StatefulWidget {
  MainTabStorageScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MainTabStorageScreen();
  }
}

enum StorageBottomTabType {DataStorage, MyFile, Shared}

enum StorageTopTabType {Document, Pin, Recently}

class _MainTabStorageScreen extends State<MainTabStorageScreen> {

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    AppStore.currentBottomViewTypeStorage = StorageBottomTabType.DataStorage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: <Widget>[
          new ItemTabStorageScreen(type: StorageBottomTabType.DataStorage,),
          new ItemTabStorageScreen(type: StorageBottomTabType.MyFile,),
          new ItemTabStorageScreen(type: StorageBottomTabType.Shared,),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.storage), title: Text('Kho tài liệu')),
          BottomNavigationBarItem(icon: Icon(Icons.folder_shared_outlined), title: Text('Tài liệu cá nhân')),
          BottomNavigationBarItem(icon: Icon(Icons.share), title: Text('Tài liệu chia sẻ'))
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    switch (index) {
      case 0:
        AppStore.currentBottomViewTypeStorage = StorageBottomTabType.DataStorage;
        eventBus.fire(ChangeTabEvent());
        break;
      case 1:
        AppStore.currentBottomViewTypeStorage = StorageBottomTabType.MyFile;
        eventBus.fire(ChangeTabEvent());
        break;
      case 2:
        AppStore.currentBottomViewTypeStorage = StorageBottomTabType.Shared;
        eventBus.fire(ChangeTabEvent());
        break;
    }
  }
}
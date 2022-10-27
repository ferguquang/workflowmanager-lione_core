import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/borrowPayDocument/screen/statistic/statistic_tab_borrow_docments.dart';
import 'package:workflow_manager/borrowPayDocument/tab_borrow_pay_document_screen.dart';

class BorrowDocumentsTabBottomScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BorrowDocumentsTabBottomScreen();
  }
}

class _BorrowDocumentsTabBottomScreen
    extends State<BorrowDocumentsTabBottomScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Mượn trả tài liệu".toUpperCase()),
      // ),
      body: IndexedStack(
        index: _selectedIndex,
        children: <Widget>[
          StatisticTabBorrowDocuments(),
          TabBorrowPayDocumentScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          _buildBottomNavigationBarItem("assets/images/ic-duocgiao.png",
              "assets/images/ic-duocgiao-active.png", 'Thống kê'),
          _buildBottomNavigationBarItem("assets/images/ic-dagiao.png",
              "assets/images/ic-dagiao-active.png", 'Mượn trả'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  _onItemTapped(int index) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = index;
    });
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(img, imgActive, label) {
    return BottomNavigationBarItem(
      icon: Image.asset(
        img,
        width: 24,
        height: 24,
      ),
      activeIcon: Image.asset(
        imgActive,
        width: 24,
        height: 24,
      ),
      label: label,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:workflow_manager/shopping_management/management/management_shopping_screen.dart';
import 'package:workflow_manager/shopping_management/report/report_shopping_screen.dart';

class ShoppingManagementScreen extends StatefulWidget {
  @override
  _ShoppingManagementScreenState createState() => _ShoppingManagementScreenState();
}

class _ShoppingManagementScreenState extends State<ShoppingManagementScreen> {
  var bottomNavItems =  [
    BottomNavigationBarItem(icon: Icon(Icons.stacked_bar_chart), label: "Thống kê"),
    BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Quản lý"),
  ];

  var screenItem = [
    ReportShoppingScreen(),
    ManagementShoppingScreen(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý mua sắm"),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: screenItem,
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: List.of(bottomNavItems),
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped
      ),
    );
  }

  void _onItemTapped(int index) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedIndex = index;
    });
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/payment_progress/delivery/delivery_list_screen/delivery_list_screen.dart';
import 'payment/payment_progress_list_screen/payment_progress_list_screen.dart';

class MainPaymentProgressScreen extends StatefulWidget {
  @override
  _MainPaymentProgressScreenState createState() =>
      _MainPaymentProgressScreenState();
}

class _MainPaymentProgressScreenState extends State<MainPaymentProgressScreen> {
  List<ContentShoppingModel> items = [];

  @override
  void initState() {
    super.initState();
    addItems();
  }

  addItems() {
    items = [];
    items.add(ContentShoppingModel(
        title: "Quản lý tiến độ thanh toán", isNextPage: true));
    items
        .add(ContentShoppingModel(title: "Hàng về bàn giao", isNextPage: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tiến độ thực hiện"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ContentViewShoppingItem(
            model: items[index],
            position: index,
            onClick: (model, position) {
              if (position == 0) {
                pushPage(context, PaymentProgressListScreen());
              } else {
                pushPage(context, DeliveryListScreen());
              }
            },
          );
        },
      ),
    );
  }
}

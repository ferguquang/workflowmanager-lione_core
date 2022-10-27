import 'package:flutter/material.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';

class DebtLogDetailScreen extends StatelessWidget {
  ProviderDebts model;

  DebtLogDetailScreen(this.model);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết lịch sử"),
      ),
      body: SafeArea(
          child: ListView.builder(
            itemCount: getList(model).length,
            itemBuilder: (BuildContext context, int index) {
              return ContentViewShoppingItem(
                model: getList(model)[index],
              );
            },
          )
      ),
    );
  }

  List<ContentShoppingModel> getList(ProviderDebts model) {
    List<ContentShoppingModel> list = [];
    list.add(ContentShoppingModel(title: "Mã dự án", value: model.code));
    list.add(ContentShoppingModel(title: "Tên dự án", value: model.name));
    list.add(ContentShoppingModel(title: "Mã PO", value: model.pONumber));
    list.add(ContentShoppingModel(title: "Thời gian", value: model.updated));
    list.add(ContentShoppingModel(title: "Tổng cộng (VNĐ)", value: model.totalAmount));
    list.add(ContentShoppingModel(title: "Nợ NCC (VNĐ)", value: model.debtAmount));
    list.add(ContentShoppingModel(title: "Nợ còn lại (VNĐ)", value: model.remainAmount));

    list.forEach((element) {
      element.isNextPage = false;
    });
    return list;
  }
}

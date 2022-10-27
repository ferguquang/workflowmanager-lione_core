import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/debt_log/debt_log_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/history_import/history_import_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/provider_info_screen/provider_info_screen.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';

class DetailProviderMainScreen extends StatefulWidget {
  ProvidersIndex model;

  DetailProviderMainScreen({this.model});

  @override
  _DetailProviderMainScreenState createState() => _DetailProviderMainScreenState();
}

class _DetailProviderMainScreenState extends State<DetailProviderMainScreen> {
  List<ContentShoppingModel> list = [];

  @override
  void initState() {
    super.initState();
    list.add(ContentShoppingModel(key: "TTNCC", title: "Thông tin nhà cung cấp"));
    list.add(ContentShoppingModel(key: "LSNH", title: "Lịch sử nhập hàng"));
    list.add(ContentShoppingModel(key: "NCTNCC", title: "Nợ cần trả nhà cung cấp"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết nhà cung cấp"),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return ContentViewShoppingItem(
              model: list[index],
              onClick: (item, position) {
                switch (item.key) {
                  case "TTNCC":
                    pushPage(context, ProviderInfoScreen(
                      type: ProviderInfoScreen.TYPE_DETAIL,
                      model: widget.model,
                    ));
                    break;
                  case "LSNH":
                    pushPage(context, HistoryImportScreen(
                      model: widget.model,
                    ));
                    break;
                  case "NCTNCC":
                    pushPage(context, DebtLogScreen(widget.model));
                    break;
                }
              },
            );
          },
        ),
      ),
    );
  }
}

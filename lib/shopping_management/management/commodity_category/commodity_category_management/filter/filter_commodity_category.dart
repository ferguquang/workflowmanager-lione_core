import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';

class FilterCommodityCategory extends StatefulWidget {
  void Function(String, String) onFilter;
  String valueCode, valueName;

  FilterCommodityCategory({this.onFilter, this.valueName, this.valueCode});

  @override
  _FilterCommodityCategoryState createState() => _FilterCommodityCategoryState();
}

class _FilterCommodityCategoryState extends State<FilterCommodityCategory> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lọc nâng cao"), actions: [
        TextButton(
          child: Text(
            "Xóa",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            setState(() {
              widget.valueCode = "";
              widget.valueName = "";
            });
          },
        )
      ]),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  ContentViewShoppingItem(
                    model: ContentShoppingModel(
                        title: "Mã danh mục hàng hóa",
                        value: widget.valueCode ?? ""),
                    onClick: (item, position) {
                      pushPage(
                          context,
                          InputTextWidget(
                            title: "Mã danh mục hàng hóa",
                            content: widget.valueCode ?? "",
                            onSendText: (String describe) {
                              setState(() {
                                widget.valueCode = describe;
                              });
                            },
                          ));
                    },
                  ),
                  ContentViewShoppingItem(
                    model: ContentShoppingModel(
                        title: "Tên danh mục hàng hóa",
                        value: widget.valueName ?? ""
                    ),
                    onClick: (item, position) {
                      pushPage(context, InputTextWidget(
                        title: "Tên danh mục hàng hóa",
                        content: widget.valueName ?? "",
                        onSendText: (String describe) {
                          setState(() {
                            widget.valueName = describe;
                          });
                        },
                      ));
                    },
                  )
                ],
              ),
            ),
            SaveButton(
              margin: EdgeInsets.all(16),
              onTap: () async {
                widget.onFilter(widget.valueCode, widget.valueName);
                Navigator.pop(context);
              },
              title: "Áp dụng",
            )
          ],
        ),
      ),
    );
  }
}

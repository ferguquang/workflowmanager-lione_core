import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_category_management/create/createupdate_commodity_category_repository.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/response/commodity_category_response.dart';

class CreateCommodityCategoryScreen extends StatefulWidget {
  bool isUpdate;
  void Function(Categories) onCreateItem;
  void Function(Categories) onUpdateItem;

  Categories model;

  CreateCommodityCategoryScreen({this.isUpdate, this.onCreateItem, this.onUpdateItem, this.model});

  @override
  _CreateCommodityCategoryScreenState createState() => _CreateCommodityCategoryScreenState();
}

class _CreateCommodityCategoryScreenState extends State<CreateCommodityCategoryScreen> {
  String valueCode = "", valueName = "";

  CreateUpdateCommodityRepository _repository = CreateUpdateCommodityRepository();

  // ContentShoppingModel codeModel, nameModel;

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate && widget.model != null) {
      _repository.commodityCategoryUpdate(widget.model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, CreateUpdateCommodityRepository repository, Widget child) {
          if (widget.isUpdate && repository.itemUpdate != null) {
            // codeModel.value = repository.itemUpdate.code;
            // nameModel.value = repository.itemUpdate.code;

            valueCode = repository.itemUpdate.code;
            valueName = repository.itemUpdate.name;
          }

          return Scaffold(
          appBar: AppBar(
              title: Text(widget.isUpdate ? "Chỉnh sửa danh mục hàng hóa" : "Thêm mới danh mục hàng hóa")
          ),
          body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        ContentViewShoppingItem(
                          model: ContentShoppingModel(
                            title: "Mã danh mục hàng hóa",
                            value: valueCode,
                            isRequire: true,
                          ),
                          onClick: (item, position) {
                            pushPage(context, InputTextWidget(
                              title: "Mã danh mục hàng hóa",
                              content: valueCode,
                              onSendText: (String valueChange) {
                                setState(() {
                                  valueCode = valueChange;
                                  repository.itemUpdate?.code = valueChange;
                                  // codeModel.value = describe;
                                });
                              },
                            ));
                          },
                        ),
                        ContentViewShoppingItem(
                          model: ContentShoppingModel(
                            title: "Tên danh mục hàng hóa",
                            value: valueName,
                            isRequire: true,
                          ),
                          onClick: (item, position) {
                            pushPage(context, InputTextWidget(
                              title: "Tên danh mục hàng hóa",
                              content: valueName,
                              onSendText: (String valueChange) {
                                setState(() {
                                  valueName = valueChange;
                                  repository.itemUpdate?.name = valueChange;
                                  // nameModel.value = describe;
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
                      if (widget.isUpdate) {
                        Categories itemChange = await _repository.qlmsCommodityCategoryChange(widget.model.iD, valueCode, valueName);
                        if (itemChange != null) {
                          itemChange.isDelete = true;
                          itemChange.isUpdate = true;
                          widget.onUpdateItem(itemChange);
                          Navigator.pop(context);
                        }
                      } else {
                        Categories category = await _repository.commodityCategorySave(valueCode, valueName);
                        if (category != null) {
                          category.isDelete = true;
                          category.isUpdate = true;
                          widget.onCreateItem(category);
                          Navigator.pop(context);
                        }
                      }
                    },
                    title: "XONG",
                  )
                ],
              )
          ),
        );
       },
      ),
    );
  }
}

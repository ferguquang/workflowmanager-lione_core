import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/screens/resolve/list/handle_fast_list/input_text_widget.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/request/commodity_request.dart';
import 'package:workflow_manager/shopping_management/response/commodity_response.dart';

class FilterCommodityScreen extends StatefulWidget {
  SearchParamCommodity searchParamCommodity;
  CommodityRequest request;
  List<CategorySearchParams> manufactursSelected;
  List<CategorySearchParams> categorySelected;
  void Function(
          CommodityRequest /*, List<CategorySearchParams>, List<CategorySearchParams>*/)
      onFilter;

  FilterCommodityScreen(
      {this.searchParamCommodity,
      this.request,
      this.onFilter,
      this.manufactursSelected,
      this.categorySelected});

  @override
  _FilterCommodityScreenState createState() => _FilterCommodityScreenState();
}

class _FilterCommodityScreenState extends State<FilterCommodityScreen> {
  List<ContentShoppingModel> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    addList();
  }

  void addList() {
    String valueCategories = "", idValueCategories = "";
    if (widget.categorySelected != null) {
      valueCategories = widget.categorySelected
          .map((e) => "${e.name}")
          .toList()
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "");
      idValueCategories =
          widget.categorySelected.map((e) => "${e.iD}").toList().toString();
    }

    list.add(ContentShoppingModel(
        key: "DMHH",
        title: "Danh mục hàng hóa",
        selected: widget.categorySelected,
        value: valueCategories,
        idValue: idValueCategories));

    String valueManufacture = "";
    List<CategorySearchParams> quarterSelected = [];
    if (isNotNullOrEmpty(widget.request.idManufacturs) &&
        widget.request.idManufacturs != "null") {
      List<String> stringList = widget.request.idManufacturs.split(',');
      for (int i = 0; i < stringList.length; i++) {
        String idCategory = stringList[i];
        for (int j = 0;
            j < widget.searchParamCommodity.manufacturs.length;
            j++) {
          String id = "${widget.searchParamCommodity.manufacturs[j].iD}";
          if (idCategory.contains(id)) {
            quarterSelected.add(widget.searchParamCommodity.manufacturs[j]);
          }
        }
      }
    }
    list.add(ContentShoppingModel(
        key: "HANG",
        title: "Chọn hãng",
        isDropDown: true,
        selected: quarterSelected,
        isSingleChoice: false,
        dropDownData: widget.searchParamCommodity.manufacturs,
        idValue: isNotNullOrEmpty(widget.request.idManufacturs) &&
                widget.request.idManufacturs != "null"
            ? widget.request.idManufacturs
            : "",
        getTitle: (status) => status.name,
        value: valueManufacture));
    // list.add(ContentShoppingModel(key: "HANG", title: "Chọn hãng", value: widget.request.));

    list.add(ContentShoppingModel(key: "MAHH", title: "Mã hàng hóa"));
    list.add(ContentShoppingModel(key: "TENHH", title: "Tên hàng hóa"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lọc nâng cao"),
          actions: [
            TextButton(
              child: Text(
                "Xóa",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (isNotNullOrEmpty(list)) {
                  for (ContentShoppingModel model in list) {
                    model.idValue = null;
                    model.value = "";
                    model.selected = null;
                  }
                  setState(() {});
                }
              },
            )
          ]
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ContentViewShoppingItem(
                    model: list[index],
                    onClick: (model, position) {
                      switch(list[index].key) {
                        case "DMHH": {
                          ChoiceDialog<CategorySearchParams>(
                              context,
                                    widget.searchParamCommodity.categories,
                                    hintSearchText:
                                        "Tìm kiếm danh mục hàng hóa",
                                    getTitle: (CategorySearchParams item) {
                                      return item.name;
                                    },
                                    title: "${list[index].title}",
                                    itemBuilder: (CategorySearchParams item) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        child: Text(
                                          item.name,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      );
                                    },
                                    isSingleChoice: true,
                                    onAccept:
                                        (List<CategorySearchParams> items) {
                                      setState(() {
                                        widget.categorySelected = items;

                                        list[0].value = widget.categorySelected
                                            .map((e) => "${e.name}")
                                            .toList()
                                            .toString()
                                            .replaceAll("[", "")
                                            .replaceAll("]", "");

                                        list[0].idValue = widget
                                            .categorySelected
                                            .map((e) => "${e.iD}")
                                            .toList()
                                            .toString();
                                      });
                              },
                              selectedObject: widget.categorySelected).showChoiceDialog();
                          break;
                        }
                        case "HANG": {
                          ChoiceDialog<CategorySearchParams>(
                              context,
                                    widget.searchParamCommodity.manufacturs,
                                    hintSearchText: "Tìm kiếm hãng",
                                    getTitle: (CategorySearchParams item) {
                                      return item.name;
                                    },
                                    title: "${list[index].title}",
                                    itemBuilder: (CategorySearchParams item) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 8),
                                        child: Text(
                                          item.name,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      );
                                    },
                                    isSingleChoice: false,
                              onAccept: (List<CategorySearchParams> items) {
                                setState(() {
                                        widget.manufactursSelected = items;

                                        list[1].value = widget
                                            .manufactursSelected
                                            .map((e) => "${e.name}")
                                            .toList()
                                            .toString()
                                            .replaceAll("[", "")
                                            .replaceAll("]", "");

                                        list[1].idValue = widget
                                            .manufactursSelected
                                            .map((e) => "${e.iD}")
                                            .toList()
                                            .toString();
                                      });
                              },
                              selectedObject: widget.manufactursSelected).showChoiceDialog();
                          break;
                        }
                        default: {
                          pushPage(context, InputTextWidget(
                            title: list[index].title,
                            content: list[index].value,
                            onSendText: (text) {
                              setState(() {
                                list[index].value = text;
                              });
                            },
                          ));
                          break;
                        }
                      }
                    },

                  );
                },
              ),
            ),
            SaveButton(
              margin: EdgeInsets.all(16),
              onTap: () {
                widget.request.idCategory = list[0].idValue;
                widget.request.idManufacturs = list[1].idValue;
                widget.request.name = list[2].value.toString().toLowerCase();
                widget.request.code = list[3].value.toString().toLowerCase();
                // widget.request.categorySelected = widget.categorySelected;
                // widget.request.manufactursSelected = widget.manufactursSelected;

                widget.onFilter(widget
                    .request /*, widget.categorySelected, widget.manufactursSelected*/);
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

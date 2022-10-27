import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

class FilterCategoryScreen extends StatefulWidget {
  List<Categories> listData;
  List<Categories> listCheck;
  String titleDept;
  bool isSingleSelected; // false chọn 1, true chọn nhiều
  final void Function(List<Categories> listSelected) onListSelected;

  FilterCategoryScreen(
      this.listData, this.isSingleSelected, this.listCheck, this.titleDept,
      {this.onListSelected});

  @override
  _FilterCategoryScreenState createState() => _FilterCategoryScreenState();
}

class _FilterCategoryScreenState extends State<FilterCategoryScreen> {
  var searchController = TextEditingController();
  List<Categories> listCategories = new List<Categories>();
  bool isCheckAll = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listCategories = widget.listData;
    int number = 0;
    int nunCheck = 0;
    listCategories.forEach((element) {
      widget.listCheck.forEach((element1) {
        if (element.iD == element1.iD) {
          element.isSelected = true;
          number++;
        }
      });
      if (!element.isEnable) nunCheck++;
    });
    if (number == listCategories.length - nunCheck) isCheckAll = true;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listCategories.forEach((element) {
      element.isSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titleDept),
        actions: [
          IconButton(
            onPressed: () {
              List<Categories> listCheckCategories = new List<Categories>();
              listCategories.forEach((element) {
                if (element.isSelected) listCheckCategories.add(element);
                element.isSelected = false;
              });
              this.widget.onListSelected(listCheckCategories);
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                    child: TextField(
                  controller: searchController,
                  decoration: InputDecoration.collapsed(
                    hintText: "Tìm kiếm theo tên",
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      var text = removeDiacritics(value).toLowerCase();
                      listCategories = widget.listData
                          .where((element) => removeDiacritics(element.name)
                              .toLowerCase()
                              .contains(text))
                          .toList();
                    });
                  },
                )),
                Visibility(
                  visible: widget.isSingleSelected,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isCheckAll = !isCheckAll;
                        listCategories.forEach((element) {
                          if (element.isEnable) {
                            if (isCheckAll) {
                              element.isSelected = true;
                            } else {
                              element.isSelected = false;
                            }
                          }
                        });
                      });
                    },
                    icon: Icon(
                      !isCheckAll
                          ? Icons.library_add_check
                          : Icons.check_box_outline_blank_sharp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: listCategories.length == 0
                  ? EmptyScreen()
                  : ListView.separated(
                      itemCount: listCategories?.length ?? 0,
                      itemBuilder: (context, index) {
                        Categories _item = listCategories[index];
                        return InkWell(
                          onTap: () {
                            _eventClickItem(_item);
                          },
                          child: ItemCategoriesSelected(_item),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  _eventClickItem(Categories item) {
    setState(() {
      if (item.isEnable) {
        if (widget.isSingleSelected) {
          item.isSelected = !item.isSelected;
        } else {
          listCategories.forEach((element) {
            if (element.iD == item.iD) {
              element.isSelected = !element.isSelected;
            } else {
              element.isSelected = false;
            }
          });
        }
      }
    });
  }
}

class ItemCategoriesSelected extends StatelessWidget {
  Categories _item;

  ItemCategoriesSelected(this._item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: Text(
            _item?.name,
            style: TextStyle(
                fontWeight:
                    _item.isEnable ? FontWeight.normal : FontWeight.bold),
          )),
          Visibility(
              visible: _item?.isEnable,
              child: _item.isSelected
                  ? Icon(
                      Icons.check_box,
                      color: Colors.blue,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey[300],
                    ))
        ],
      ),
    );
  }
}

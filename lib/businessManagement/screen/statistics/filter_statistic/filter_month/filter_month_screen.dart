import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

class FilterMonthScreen extends StatefulWidget {
  List<DateTypes> listData;
  List<DateTypes> listCheck;
  bool isSingleSelected; // false chọn 1, true chọn nhiều
  String title;

  final void Function(List<DateTypes> listSelected) onListSelected;

  FilterMonthScreen(
      this.listData, this.isSingleSelected, this.listCheck, this.title,
      {this.onListSelected});

  @override
  _FilterMonthScreenState createState() => _FilterMonthScreenState();
}

class _FilterMonthScreenState extends State<FilterMonthScreen> {
  var searchController = TextEditingController();
  List<DateTypes> listDateTypes = [];
  bool isCheckAll = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listDateTypes = widget.listData;
    int number = 0;
    listDateTypes.forEach((element) {
      widget.listCheck.forEach((element1) {
        if (element.value == element1.value) {
          element.isSelected = true;
          number++;
        }
      });
    });
    if (number == listDateTypes.length) isCheckAll = true;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listDateTypes.forEach((element) {
      element.isSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              List<DateTypes> listCheckCategories = [];
              listDateTypes.forEach((element) {
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
                      listDateTypes = widget.listData
                          .where((element) => removeDiacritics(element.text)
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
                        listDateTypes.forEach((element) {
                          if (isCheckAll) {
                            element.isSelected = true;
                          } else {
                            element.isSelected = false;
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
              child: listDateTypes.length == 0
                  ? EmptyScreen()
                  : ListView.separated(
                      itemCount: listDateTypes?.length ?? 0,
                      itemBuilder: (context, index) {
                        DateTypes item = listDateTypes[index];
                        return InkWell(
                          onTap: () {
                            _eventClickItem(item);
                          },
                          child: ItemDateTypesSelected(item),
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

  _eventClickItem(DateTypes item) {
    setState(() {
      if (widget.isSingleSelected) {
        item.isSelected = !item.isSelected;
      } else {
        listDateTypes.forEach((element) {
          if (element.value == item.value) {
            element.isSelected = !element.isSelected;
          } else {
            element.isSelected = false;
          }
        });
      }
    });
  }
}

class ItemDateTypesSelected extends StatelessWidget {
  DateTypes item;

  ItemDateTypesSelected(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: Text(
            item?.text,
            style: TextStyle(fontWeight: FontWeight.normal),
          )),
          item.isSelected
              ? Icon(
                  Icons.check_box_sharp,
                  color: Colors.blue,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  color: Colors.grey[300],
                )
        ],
      ),
    );
  }
}

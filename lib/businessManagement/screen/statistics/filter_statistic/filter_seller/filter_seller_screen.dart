import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

class FilterSellerScreen extends StatefulWidget {
  List<Seller> listData;
  List<Seller> listCheck;
  bool isSingleSelected; // false chọn 1, true chọn nhiều
  final void Function(List<Seller> listSelected) onListSelected;

  FilterSellerScreen(this.listData, this.isSingleSelected, this.listCheck,
      {this.onListSelected});

  @override
  _FilterSellerScreenState createState() => _FilterSellerScreenState();
}

class _FilterSellerScreenState extends State<FilterSellerScreen> {
  var searchController = TextEditingController();
  List<Seller> listSeller = [];
  bool isCheckAll = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listSeller = widget.listData;
    int number = 0;
    listSeller.forEach((element) {
      widget.listCheck.forEach((element1) {
        if (element.iD == element1.iD) {
          element.isSelected = true;
          number++;
        }
      });
    });
    if (number == listSeller.length) isCheckAll = true;
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listSeller.forEach((element) {
      element.isSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn seller'),
        actions: [
          IconButton(
            onPressed: () {
              List<Seller> listCheckCategories = [];
              listSeller.forEach((element) {
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
                      listSeller = widget.listData
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
                        listSeller.forEach((element) {
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
              child: listSeller.length == 0
                  ? EmptyScreen()
                  : ListView.separated(
                      itemCount: listSeller?.length ?? 0,
                      itemBuilder: (context, index) {
                        Seller item = listSeller[index];
                        return InkWell(
                          onTap: () {
                            _eventClickItem(item);
                          },
                          child: ItemSellerSelected(item),
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

  _eventClickItem(Seller item) {
    setState(() {
      if (widget.isSingleSelected) {
        item.isSelected = !item.isSelected;
      } else {
        listSeller.forEach((element) {
          if (element.iD == item.iD) {
            element.isSelected = !element.isSelected;
          } else {
            element.isSelected = false;
          }
        });
      }
    });
  }
}

class ItemSellerSelected extends StatelessWidget {
  Seller item;

  ItemSellerSelected(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: Text(
            item?.name,
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

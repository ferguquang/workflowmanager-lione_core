import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/businessManagement/model/response/create_management_response.dart';

class GroupCustomersCreateScreen extends StatefulWidget {
  List<TypeProjects> listData;
  int idGroupCustomers;
  String title;
  final void Function(TypeProjects _groupCustomers) onGroupCustomers;

  GroupCustomersCreateScreen(this.listData, this.idGroupCustomers, this.title,
      {this.onGroupCustomers});

  @override
  _GroupCustomersCreateScreenState createState() =>
      _GroupCustomersCreateScreenState();
}

class _GroupCustomersCreateScreenState
    extends State<GroupCustomersCreateScreen> {
  var searchController = TextEditingController();
  List<TypeProjects> listSeller = [];
  bool isCheckAll = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listSeller = widget.listData;
    listSeller.forEach((element) {
      if (element.iD == widget.idGroupCustomers) {
        element.isSelected = true;
      }
    });
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
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              TypeProjects seller = TypeProjects();
              listSeller.forEach((element) {
                if (element.isSelected) seller = element;
              });
              Navigator.of(context).pop();
              this.widget.onGroupCustomers(seller);
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
              ],
            ),
            Expanded(
              child: listSeller.length == 0
                  ? EmptyScreen()
                  : ListView.separated(
                      itemCount: listSeller?.length ?? 0,
                      itemBuilder: (context, index) {
                        TypeProjects item = listSeller[index];
                        return InkWell(
                          onTap: () {
                            if (item.isEnable) _eventClickItem(item);
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

  _eventClickItem(TypeProjects item) {
    setState(() {
      listSeller.forEach((element) {
        if (element?.iD == item?.iD) {
          element.isSelected = !element.isSelected;
        } else {
          element.isSelected = false;
        }
      });
    });
  }
}

class ItemSellerSelected extends StatelessWidget {
  TypeProjects item;

  ItemSellerSelected(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: Text(
            item?.name ?? '',
            style: TextStyle(
                fontWeight:
                    item.isEnable ? FontWeight.normal : FontWeight.bold),
          )),
          Visibility(
              visible: item?.isEnable,
              child: item.isSelected
                  ? Icon(
                      Icons.check_box_sharp,
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

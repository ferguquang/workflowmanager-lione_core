import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

class CustomersCreateScreen extends StatefulWidget {
  List<Seller> listData;
  int idSeller;
  String title;
  String root;
  final void Function(Seller _seller) onSeller;

  CustomersCreateScreen(this.listData, this.idSeller, this.title, this.root,
      {this.onSeller});

  @override
  _CustomersCreateScreenState createState() => _CustomersCreateScreenState();
}

class _CustomersCreateScreenState extends State<CustomersCreateScreen> {
  var searchController = TextEditingController();
  List<Seller> listSeller = [];
  bool isCheckAll = false;
  String root = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listSeller = widget.listData;
    listSeller.forEach((element) {
      if (element.iD == widget.idSeller) {
        element.isSelected = true;
      }
      element.avatar =
          '${widget.root}${element?.avatar?.replaceAll('${widget.root}', '')}';
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
              Seller seller;
              listSeller.forEach((element) {
                if (element.isSelected) seller = element;
              });
              Navigator.of(context).pop();
              this.widget.onSeller(seller);
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
                        Seller item = listSeller[index];
                        // item?.avatar =
                        //     root + item.avatar.replaceAll('$root', '');
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
      listSeller.forEach((element) {
        if (element.iD == item.iD) {
          element.isSelected = !element.isSelected;
        } else {
          element.isSelected = false;
        }
      });
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
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleNetworkImage(
                height: 30, width: 30, url: item.avatar ?? ''),
          ),
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

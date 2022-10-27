import 'package:flutter/material.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';

class BottomSheetQuarterScreen extends StatefulWidget {
  List<DateTypes> listData;
  bool isSingleCheck = false;
  String titleQuarter;
  final void Function(List<DateTypes> listSelected) onListSelected;

  BottomSheetQuarterScreen(this.listData, this.isSingleCheck, this.titleQuarter,
      {this.onListSelected});

  @override
  _BottomSheetQuarterScreenState createState() =>
      _BottomSheetQuarterScreenState();
}

class _BottomSheetQuarterScreenState extends State<BottomSheetQuarterScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.listData.forEach((element) {
      element.isSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
            margin: EdgeInsets.only(bottom: 16),
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                Positioned(
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      widget.titleQuarter,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Visibility(
                  visible: widget.isSingleCheck,
                  child: Positioned(
                    child: IconButton(
                      onPressed: () {
                        List<DateTypes> listCheck = [];
                        widget.listData.forEach((element) {
                          if (element.isSelected) listCheck.add(element);
                          element.isSelected = false;
                        });
                        Navigator.of(context).pop();
                        this.widget.onListSelected(listCheck);
                      },
                      icon: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            ),
            color: Colors.blue,
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: widget.listData?.length ?? 0,
            itemBuilder: (context, index) {
              DateTypes item = widget.listData[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    if (widget.isSingleCheck) {
                      item.isSelected = !item.isSelected;
                    } else {
                      widget.listData.forEach((element) {
                        if (element.value == item.value) {
                          element.isSelected = !element.isSelected;
                          if (element.isSelected) {
                            List<DateTypes> listCheck = [];
                            listCheck.add(element);
                            Navigator.of(context).pop();
                            this.widget.onListSelected(listCheck);
                          }
                        } else {
                          element.isSelected = false;
                        }
                      });
                    }
                  });
                },
                child: ItemFilterQuarterSelected(item),
              );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          )
        ],
      ),
    );
  }
}

class ItemFilterQuarterSelected extends StatelessWidget {
  DateTypes item;

  ItemFilterQuarterSelected(this.item);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
              child: Text(
            item?.text,
            style: TextStyle(fontSize: 16),
          )),
          item.isSelected
              ? Icon(
                  Icons.check_box_sharp,
                  color: Colors.blue,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  color: Colors.white,
                )
        ],
      ),
    );
  }
}

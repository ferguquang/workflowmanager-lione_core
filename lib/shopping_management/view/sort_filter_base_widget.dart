import 'package:flutter/material.dart';
import 'package:workflow_manager/shopping_management/view/sort_name_bottom_sheet.dart';

class SortFilterBaseWidget extends StatefulWidget {
  void Function() onSort;
  void Function() onFilter;
  void Function(int) onSortType;
  int sortType;

  SortFilterBaseWidget(
      {this.onSort, this.onFilter, this.onSortType, this.sortType});

  @override
  _SortFilterBaseWidgetState createState() => _SortFilterBaseWidgetState();
}

class _SortFilterBaseWidgetState extends State<SortFilterBaseWidget> {
  int _sortType = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    if (widget.onSort != null) widget.onSort();
                    if (widget.onSortType != null) {
                      SortNameBottomSheet(
                        type: widget.sortType ?? _sortType,
                        onUpdateType: (type) {
                          _sortType = type;
                          widget.onSortType(type);
                        },
                      )..show(context);
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sort,
                        color: Colors.grey,
                      ),
                      Text("Sắp xếp", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
              ),
              Text("|"),
              Expanded(
                child: InkWell(
                  onTap: () {
                    widget.onFilter();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.filter_alt_sharp,
                        color: Colors.grey,
                      ),
                      Text("Lọc", style: TextStyle(fontSize: 16))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tableview/flutter_tableview.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/states_widget.dart';
import 'package:workflow_manager/base/ui/text_action.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/response/project_plan_index_response.dart';
import 'package:diacritic/diacritic.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/filter_state_widget.dart';

class SelectPhasesScreen extends StatefulWidget {
  List<TypeProjects> data;

  List<TypeProjects> selected;
  List<TypeProjects> typeBussinessSelected;

  final void Function(List<TypeProjects>) listSelected;

  SelectPhasesScreen(
      {this.data,
      this.selected,
      this.listSelected,
      this.typeBussinessSelected});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SelectPhasesScreen();
  }
}

class _SelectPhasesScreen extends State<SelectPhasesScreen> {
  List<TypeProjects> _datas = [];

  List<TypeProjects> dataSelected = [];

  int _sectionCount = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (isNotNullOrEmpty(this.widget.data)) {
      if (isNotNullOrEmpty(this.widget.typeBussinessSelected) &&
          this.widget.typeBussinessSelected.length > 0) {
        List<TypeProjects> temp = [];
        for (int i = 0; i < this.widget.data.length; i++) {
          TypeProjects item = this.widget.data[i];
          for (int j = 0; j < this.widget.typeBussinessSelected.length; j++) {
            TypeProjects jtem = this.widget.typeBussinessSelected[j];
            if (item.iD == jtem.iD) {
              temp.add(item);
            }
          }
        }
        _datas.addAll(temp);
      } else {
        _datas.addAll(this.widget.data);
      }
    }
    if (isNotNullOrEmpty(this.widget.selected)) {
      setState(() {
        dataSelected.addAll(this.widget.selected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn giai đoạn'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              this.widget.listSelected(dataSelected);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _buildSearchWidget(),
            Expanded(
              child: _buildTableWidget(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearchWidget() {
    return Container(
      padding: EdgeInsets.only(right: 16),
      height: 50,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 16, top: 8, right: 8, bottom: 8),
              padding: EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: getColor("#F5F6FA"),
              ),
              child: TextField(
                style: TextStyle(fontSize: 14 /*, height: 3*/),
                onChanged: (value) {
                  print("${value}");
                  if (value.length == 0) {
                    setState(() {
                      _datas = [];
                      _datas.addAll(widget.data);
                    });
                  } else {
                    // _datas = [];
                    List<TypeProjects> temp = [];
                    for (int i = 0; i < widget.data.length; i++) {
                      TypeProjects item = widget.data[i];
                      if (isNotNullOrEmpty(item.target)) {
                        for (int j = 0; j < item.target.length; j++) {
                          TypeBusiness bItem = item.target[j];
                          if (removeDiacritics(bItem.name)
                              .toLowerCase()
                              .contains(
                                  removeDiacritics(value).toLowerCase())) {
                            temp.add(item);
                          }
                        }
                      }
                      setState(() {
                        _datas = [];
                        _datas.addAll(temp);
                      });
                    }
                  }
                },
                decoration: InputDecoration(
                  hintText: "Tìm kiếm",
                  hintStyle: TextStyle(fontSize: 14),
                  enabledBorder: new UnderlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  icon: Icon(
                    Icons.search,
                    color: Colors.grey,
                    size: 18,
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Container(
              width: 40,
              child: RaisedButton(
                elevation: 0,
                color: Colors.grey[50],
                child: Icon(
                  Icons.library_add_check,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  _selectParams(selectAll: true);
                },
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: Container(
              width: 40,
              child: RaisedButton(
                elevation: 0,
                color: Colors.grey[50],
                child: Icon(
                  Icons.check_box_outline_blank_sharp,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  _selectParams(selectAll: false);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectParams({@required bool selectAll}) {
    setState(() {
      if (selectAll) {
        dataSelected = [];
        // dataSelected.addAll(_datas);
      } else {
        dataSelected = [];
      }
    });
  }

  // build table view
  Widget _buildTableWidget() {
    return Container(
      //FlutterTableView
      child: _datas.length == 0
          ? EmptyScreen()
          : FlutterTableView(
              sectionCount: _datas.length,
              rowCountAtSection: _rowCountAtSection,
              sectionHeaderBuilder: _sectionHeaderBuilder,
              cellBuilder: _cellBuilder,
              sectionHeaderHeight: _sectionHeaderHeight,
              cellHeight: _cellHeight,
            ),
    );
  }

  int _rowCountAtSection(int section) {
    TypeProjects _items = _datas[section];
    return _items.target.length;
    // if (section == 0) {
    //   return 5;
    // } else {
    //   return 51;
    // }
  }

  Widget _sectionHeaderBuilder(BuildContext context, int section) {
    return InkWell(
      onTap: () {
        print('Tap section header. -> section: $section');
      },
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 16),
        color: Color.fromRGBO(220, 220, 220, 1),
        height: 100,
        child: Text(_datas[section].name),
      ),
    );
  }

  Widget _cellBuilder(BuildContext context, int section, int row) {
    return InkWell(
      onTap: () {
        print('Tap cell item. -> section:$section row:$row');
        setState(() {
          if (dataSelected
                  .where(
                      (element) => element.iD == _datas[section].target[row].iD)
                  .length >
              0) {
            dataSelected.removeWhere((element) =>
                element.iD ==
                _datas[section]
                    .target[row]
                    .iD); //.remove(_datas[section].target[row]);
          } else {
            TypeProjects temp = TypeProjects();
            temp.name = _datas[section].target[row].name;
            temp.key = _datas[section].target[row].key;
            temp.iD = _datas[section].target[row].iD;
            dataSelected.add(temp);
          }
        });
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 16.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Color.fromRGBO(240, 240, 240, 1),
              ))),
              height: 50.0,
              child: Text(_datas[section].target[row].name),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: StatesWidget(dataSelected
                    .where((element) =>
                        element.iD == _datas[section].target[row].iD)
                    .length >
                0), //.contains(_datas[section].target[row])),
          ),
        ],
      ),
    );
  }

  // Each section header height;
  double _sectionHeaderHeight(BuildContext context, int section) {
    return 50.0;
  }

  // Each cell item widget height.
  double _cellHeight(BuildContext context, int section, int row) {
    return 50.0;
  }
}
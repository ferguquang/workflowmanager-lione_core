
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/states_widget.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/response/project_plan_index_response.dart';
import 'package:diacritic/diacritic.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/filter_state_widget.dart';

enum FilterManagementBussinessType {
  SELLER,
  CENTER,
  PROJECT_TYPE,
  BUSSINESS_TYPE,
  PERIOD,
  STATUS,
  QUARTERS,
  YEAR,
  SOURCES,
  PROVINCES,
  POTENTIAL_TYPE,
  CAMPAIGN_TYPE
}

class SelectParamScreen extends StatefulWidget {

  String title = "";

  FilterManagementBussinessType typeFilter;

  List<TypeProjects> data;

  List<TypeProjects> selected;

  final void Function(List<TypeProjects>) listSelected;

  SelectParamScreen({ @required this.title, this.data, this.typeFilter, this.listSelected, this.selected });

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SelectParamScreen();
  }
}

class _SelectParamScreen extends State<SelectParamScreen> {

  List<TypeProjects> _datas = [];

  List<TypeProjects> dataSelected = [];

  bool isCheckAll = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (isNotNullOrEmpty(this.widget.data)) {
      _datas.addAll(this.widget.data);
    }
    if (isNotNullOrEmpty(this.widget.selected)) {
      setState(() {
        dataSelected.addAll(this.widget.selected);
      });
    }
    if (isNotNullOrEmpty(this.widget.data) &&
        isNotNullOrEmpty(this.widget.selected)) {
      if (this.widget.data.length == this.widget.selected.length) {
        setState(() {
          isCheckAll = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(this.widget.title),
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
            Container(
              padding: EdgeInsets.only(right: 16),
              height: 50,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                          left: 16, top: 8, right: 8, bottom: 8),
                      padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: getColor("#F5F6FA"),
                      ),
                      child: TextField(
                        style: TextStyle(fontSize: 14 /*, height: 3*/),
                        onChanged: (value) {
                          if (value.length == 0) {
                            setState(() {
                              _datas = [];
                              _datas.addAll(widget.data);
                            });
                          } else {
                            setState(() {
                              _datas = [];
                              for (int i = 0; i < widget.data.length; i++) {
                                TypeProjects item = widget.data[i];
                                if (removeDiacritics(item.name)
                                    .toLowerCase()
                                    .contains(removeDiacritics(value)
                                        .toLowerCase())) {
                                  _datas.add(item);
                                }
                              }
                              // _datas = this.widget.data.where((element) => element.name.toLowerCase().contains(value.toLowerCase()));
                            });
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
                  Container(
                    width: 40,
                    child: RaisedButton(
                      elevation: 0,
                      color: Colors.grey[50],
                      child: Icon(
                        !isCheckAll
                            ? Icons.library_add_check
                            : Icons.check_box_outline_blank_sharp,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        isCheckAll = !isCheckAll;
                        _selectParams(selectAll: isCheckAll);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            Expanded(
              child: _datas.length == 0 ? EmptyScreen() : _listView(context),
            )
          ],
        ),
      ),
    );
  }

  ListView _listView(BuildContext context) {
    return ListView.separated(
      itemCount: _datas.length,
      itemBuilder: (context, index) {
        return _buildItem(_datas[index], context);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget _buildItem(TypeProjects selectModel, BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          if (dataSelected
                  .where((element) => element.iD == selectModel.iD)
                  .length >
              0) {
            //.contains(selectModel)) {
            dataSelected.removeWhere((element) =>
                element.iD == selectModel.iD); //.remove(selectModel);
          } else {
            dataSelected.add(selectModel);
          }
        });
      },
      child: Container(
        height: 40,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(selectModel.name ?? ""),
                  ],
                ),
              ),
              StatesWidget(dataSelected
                      .where((element) => element.iD == selectModel.iD)
                      .length >
                  0), //(dataSelected.contains(selectModel)),
            ],
          ),
        ),
      ),
    );
  }

  void _selectParams({@required bool selectAll}) {
    setState(() {
      if (selectAll) {
        dataSelected = [];
        dataSelected.addAll(_datas);
      } else {
        dataSelected = [];
      }
    });
  }
}
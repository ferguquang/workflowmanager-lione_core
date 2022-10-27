import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/states_widget.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/select_model.dart';
import 'package:workflow_manager/base/extension/string.dart';

class ListSelectScreen extends StatefulWidget {
  String title;

  List<SelectModel> arraySelectModel = List();

  SelectModel currentSelect;

  bool isShowSearchWidget = false;

  void Function(SelectModel) onSelected;

  ListSelectScreen(
      {this.title,
      this.arraySelectModel,
      this.onSelected,
      this.currentSelect,
      this.isShowSearchWidget,});

  @override
  State<StatefulWidget> createState() {
    return _ListSelectState();
  }
}

class _ListSelectState extends State<ListSelectScreen> {
  List<SelectModel> _listSelect = List();
  String root = "";

  @override
  void initState() {
    super.initState();
    if(isNotNullOrEmpty(widget.arraySelectModel)) {
      _listSelect.addAll(widget.arraySelectModel);
    }
    setRootApi();
  }

  setRootApi() async {
    String root = await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
    setState(() {
      this.root = root;
    });
  }

  _search(String text) {
    String textSearch = removeDiacritics(text).toLowerCase();
    _listSelect.clear();
    setState(() {
      _listSelect.addAll(widget.arraySelectModel
          .where((element) =>
              removeDiacritics(element.name).toLowerCase().contains(textSearch))
          .toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: Container(
            child: Column(children: [
              Visibility(
                visible: widget.isShowSearchWidget ?? false,
                child: Container(
                  margin:
                      EdgeInsets.only(left: 16, top: 8, right: 8, bottom: 8),
                  padding: EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: "F5F6FA".toColor(),
                  ),
                  child: TextField(
                    style: TextStyle(fontSize: 14 /*, height: 3*/),
                    onChanged: (value) {
                      _search(value);
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
              Padding(padding: EdgeInsets.only(top: 16),),
              Expanded(child: _listView(_listSelect, context)),
            ]),
          ),
        ));
  }

  ListView _listView(data, BuildContext context) {
    return ListView.separated(
      itemCount: _listSelect.length,
      itemBuilder: (context, index) {
        return _buildItem(_listSelect[index], context);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget _buildItem(SelectModel selectModel, BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onSelected(selectModel);
        Navigator.pop(context);
      },
      child: Container(
        height: 40,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Visibility(
                    visible: isNotNullOrEmpty(selectModel.avatar),
                    child: CircleNetworkImage(
                      url: "${this.root}${selectModel.avatar}",
                      size: 40,
                    )),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(selectModel.name ?? ""),
                    Visibility(
                        visible: isNotNullOrEmpty(selectModel.subName),
                        child: Text(
                          selectModel.subName ?? "",
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        )),
                  ],
                ),
              ),
              StatesWidget(selectModel.name == widget.currentSelect?.name),
            ],
          ),
        ),
      ),
    );
  }
}

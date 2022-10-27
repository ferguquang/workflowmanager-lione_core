import 'package:diacritic/diacritic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog_repository.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/main.dart';

typedef GetTitle<T> = String Function(T data);
typedef ChoiceDialogTitleBuilder<T> = Widget Function(T data);
typedef OnAccept<T> = void Function(List<T>);

class ChoiceDialog<T> extends StatefulWidget {
  BuildContext context;
  List<T> searchedData = [];
  List<T> rootData = [];
  List<T> selectedObject = [];
  List<T> backupSelectedObject = [];
  String title;
  String hintSearchText;
  String choiceButtonText;
  Widget canceButton;
  GetTitle<T> getTitle;
  bool isSingleChoice;
  OnAccept<T> onAccept;
  void Function() onCancel;
  ChoiceDialogTitleBuilder<T> itemBuilder;

  ChoiceDialog(this.context, this.searchedData,
      {List<T> selectedObject,
      this.title,
      this.choiceButtonText = "Chọn",
      @required this.getTitle,
      this.isSingleChoice = true,
      this.onAccept,
      this.onCancel,
      this.hintSearchText,
      this.itemBuilder}) {
    rootData = searchedData;
    if (isNotNullOrEmpty(selectedObject)) {
      this.selectedObject = selectedObject;
      backupSelectedObject.addAll(selectedObject);
    }
  }

  Future<void> showChoiceDialog() async {
    await pushPage(context, this);
  }

  @override
  State<StatefulWidget> createState() {
    return _ChoiceDialogState<T>();
  }
}

class _ChoiceDialogState<T> extends State<ChoiceDialog<T>> {
  List<T> searchedData = [];
  List<T> rootData = [];
  List<T> selectedObject = [];
  String title;
  String hintSearchText;
  String choiceButtonText;
  GetTitle<T> getTitle;
  bool isSingleChoice;
  OnAccept<T> onAccept;
  void Function() onCancel;
  ChoiceDialogTitleBuilder<T> itemBuilder;

  ChoiceDialogRepository _choiceDialogRepository = ChoiceDialogRepository();

  @override
  void initState() {
    super.initState();
    searchedData = widget.searchedData;
    rootData = widget.rootData;
    selectedObject.addAll(widget.selectedObject);
    title = widget.title;
    hintSearchText = widget.hintSearchText;
    choiceButtonText = widget.choiceButtonText;
    getTitle = widget.getTitle;
    isSingleChoice = widget.isSingleChoice;
    onAccept = widget.onAccept;
    onCancel = widget.onCancel;
    itemBuilder = widget.itemBuilder;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ""),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Visibility(
              visible: hintSearchText != null,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) {
                        print("search   |value|");
                        var text = removeDiacritics(value).toLowerCase();
                        searchedData = rootData.where((element) {
                          String title = getTitle(element);
                          if (title == null) return false;
                          return removeDiacritics(title)
                              .toLowerCase()
                              .contains(text);
                        }).toList();
                        _choiceDialogRepository.notifyListeners();
                      },
                      decoration: InputDecoration(
                        hintText: hintSearchText,
                        prefixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: _getWidgetContent())),
            SaveButton(
              title: choiceButtonText ?? "Chọn",
              onTap: () async {
                Navigator.pop(context);
                Future.delayed(Duration(milliseconds: 700)).then((value) {});
                if (onAccept != null) {
                  onAccept(this.selectedObject);
                }
              },
              margin: EdgeInsets.all(16),
            )
          ],
        ),
      ),
    );
  }

  Widget _getWidgetContent() {
    return ChangeNotifierProvider.value(
      value: _choiceDialogRepository,
      child: Consumer(
        builder:
            (context, ChoiceDialogRepository choiceDialogRepository, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              isNullOrEmpty(searchedData)
                  ? Expanded(
                      child: Center(
                        child: Text("Không có kết quả tìm kiếm"),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: searchedData?.length ?? 0,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              if (isSingleChoice) {
                                if (selectedObject
                                    .contains(searchedData[index])) {
                                  selectedObject.remove(searchedData[index]);
                                } else {
                                  selectedObject.clear();
                                  selectedObject.add(searchedData[index]);
                                }
                              } else {
                                if (selectedObject
                                    .contains(searchedData[index])) {
                                  selectedObject.remove(searchedData[index]);
                                } else {
                                  selectedObject.add(searchedData[index]);
                                }
                              }
                              choiceDialogRepository.notifyListeners();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: itemBuilder != null
                                          ? itemBuilder(searchedData[index])
                                          : Text(
                                              getTitle(searchedData[index]) ??
                                                  "")),
                                  getIcon(index)
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget getIcon(int index) {
    bool isSelected = selectedObject.contains(searchedData[index]);
    IconData iconData;
    if (isSingleChoice) {
      iconData = isSelected
          ? Icons.radio_button_checked_outlined
          : Icons.radio_button_off;
    } else {
      iconData = isSelected
          ? Icons.check_box_outlined
          : Icons.check_box_outline_blank_rounded;
    }
    Color color = isSelected ? Colors.blue : Colors.grey;
    return Icon(
      iconData,
      color: color,
    );
  }
}

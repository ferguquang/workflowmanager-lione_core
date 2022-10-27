import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/field_table_list.dart';
import 'package:workflow_manager/procedures/models/response/response_procedure_detail.dart';
import 'package:workflow_manager/procedures/screens/detail/detail_procedure_tab_controller/info/header_step_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/single_field_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/table_field_widget/group_table_field_widget.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/table_field_widget/table_field_widget.dart';

class RegisterStepWidget extends StatefulWidget {
  RegisterStep registerStep;
  int type;

  RegisterStepWidget(this.registerStep, this.type);

  @override
  _RegisterStepWidgetState createState() => _RegisterStepWidgetState();
}

class _RegisterStepWidgetState extends State<RegisterStepWidget> {
  RegisterStep model;
  SingleFieldWidget _singleFieldWidget;
  List<TableFieldWidget> _tableFieldWidget = [];
  GroupTableFieldWidget _groupTableFieldWidget;
  bool isShowContent = true;

  @override
  void initState() {
    super.initState();
    model = widget.registerStep;
    _singleFieldWidget = SingleFieldWidget(
      model?.singleFields,
      isReadonly: true,
      isViewInOneRow: true,
    );
    _tableFieldWidget = [];
    for (TableFieldInfo tableList in model?.fieldTableList?.tableFieldInfos) {
      _tableFieldWidget.add(TableFieldWidget(
        tableList?.fields,
        true,
        _singleFieldWidget.onFieldEditted,
        isAdd: tableList.isAdd,
        isDelete: tableList.isDelete,
        indexTitle: tableList.id,
          iDTable: tableList.iDTable,
          tableName: tableList.name
      ));
    }
    if (isNotNullOrEmpty(model?.groupInfos))
      _groupTableFieldWidget = GroupTableFieldWidget(model?.tableFields, true,
          _singleFieldWidget.onFieldEditted, model?.groupInfos);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderStepWidget("Thông tin hồ sơ", (isExpanded) {
          isShowContent = isExpanded;
          setState(() {});
        }, isShowContent),
        Visibility(
          visible: isShowContent,
          child: Column(
            children: [
              _singleFieldWidget,
              getTableWidget(),
            ],
          ),
        )
      ],
    );
  }

  Widget getTableWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: _groupTableFieldWidget ?? isNotNullOrEmpty(_tableFieldWidget)
          ? ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: _tableFieldWidget,
            )
          : Container(),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/choice_dialog/choice_dialog.dart';
import 'package:workflow_manager/procedures/models/response/drop_down_datum.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/dropdown_widget/single_field_dropdown_list_repository.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/single_field_widget.dart';
import 'package:workflow_manager/procedures/screens/register/widget_list.dart';

import '../base/single_field_widget_base.dart';

class SingleFieldDropdownListWidget extends SingleFieldWidgetBase {
  bool isReadonly;

  SingleFieldDropdownListWidget(
      Field field, bool isReadonly, bool isViewInOneRow,
      {GlobalKey key, double verticalPadding = 4})
      : super(field, isReadonly, isViewInOneRow,
            key: key, verticalPadding: verticalPadding) {
    this.isReadonly = isReadonly || field.isReadonly;
  }

  @override
  _SingleFieldDropdownListWidgetState createState() =>
      _SingleFieldDropdownListWidgetState();
}

class _SingleFieldDropdownListWidgetState
    extends SingleFieldWidgetBaseState<SingleFieldDropdownListWidget> {
  SingleFieldDropdownRepository _repository;

  @override
  get singleFieldRepositoryBase => _repository;

  @override
  void initState() {
    super.initState();
    field = widget.field;
    _repository =
        SingleFieldDropdownRepository(field, widget.isReadonly, context,widget.isViewInOneRow);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _repository.reloadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, SingleFieldDropdownRepository repository, child) {
          return Visibility(
            visible: repository.isVisible,
            child: WidgetListItem(
                isShowInRowInList: isShowInRowInList,
                child: InkWell(
                  onTap: repository.onTab,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: widget.verticalPadding),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Text(
                              field?.name ?? "",
                              maxLines: 3,
                              style: TextStyle(color: repository.lableColor),
                            ),
                        Visibility(
                          visible: repository.isRequire,
                          child: Text(
                            "*",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              repository.textToDisplay ?? "",
                              maxLines: 4,
                              textAlign: TextAlign.end,
                              style: TextStyle(color: repository.contentColor),
                            ),
                          ),
                          Visibility(
                            visible: !repository.isReadonly,
                            child: Icon(
                                  Icons.arrow_drop_down,
                                  color: _repository.contentColor,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }
}

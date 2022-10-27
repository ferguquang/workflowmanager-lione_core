import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/procedures/models/response/single_field.dart';
import 'package:workflow_manager/procedures/screens/register/info_work_follow/single_field_widget/edittext_widget/single_field_edittext_repository.dart';
import 'package:workflow_manager/procedures/screens/register/widget_list.dart';

import '../base/single_field_widget_base.dart';

class SingleFieldEditTextWidget extends SingleFieldWidgetBase {
  SingleFieldEditTextWidget(Field field, bool isReadonly, bool isViewInOneRow,
      {GlobalKey key, double verticalPadding = 4})
      : super(field, isReadonly, isViewInOneRow,
            key: key, verticalPadding: verticalPadding);

  @override
  _SingleFieldEditTextWidgetState createState() =>
      _SingleFieldEditTextWidgetState();
}

class _SingleFieldEditTextWidgetState
    extends SingleFieldWidgetBaseState<SingleFieldEditTextWidget>
    with AutomaticKeepAliveClientMixin {
  TextEditingController _textEditingController = TextEditingController();
  SingleFieldEditTextRepository _singleFieldEditTextRepository;

  @override
  get singleFieldRepositoryBase => _singleFieldEditTextRepository;

  @override
  void reloadData() {
    _singleFieldEditTextRepository.loadData(widget.isReadonly);
  }

  @override
  void initState() {
    super.initState();
    _singleFieldEditTextRepository = SingleFieldEditTextRepository(
        widget.field,
        widget.isReadonly,
        context,
        _textEditingController,
        widget.isViewInOneRow);
    field = widget.field;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _singleFieldEditTextRepository.loadData(widget.isReadonly);
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _singleFieldEditTextRepository,
        child: Consumer(
          builder: (context,
              SingleFieldEditTextRepository singleFieldEditTextRepository,
              child) {
            return Visibility(
                visible: _singleFieldEditTextRepository.isVisible,
                child: WidgetListItem(
                  isShowInRowInList: isShowInRowInList==true,
                  child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: widget.verticalPadding),
                      child: getWidget()),
                ));
          },
        ));
  }

  Widget getWidget() {
    if (!widget.isViewInOneRow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                field?.name ?? "",
                style:
                    TextStyle(color: _singleFieldEditTextRepository.lableColor),
              ),
              Visibility(
                visible: _singleFieldEditTextRepository.isRequire,
                child: Text(
                  "*",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: _singleFieldEditTextRepository.onTab,
            child: Container(
              // height: 30,
              child: TextField(
                textInputAction: TextInputAction.done,
                inputFormatters: _singleFieldEditTextRepository.inputFormats,
                controller: _textEditingController,
                onChanged: _singleFieldEditTextRepository.onTextChanged,
                enabled: !_singleFieldEditTextRepository.isReadonly,
                style: TextStyle(
                    color: _singleFieldEditTextRepository.contentColor,
                    fontSize: 14),
                decoration: InputDecoration(
                    suffixIconConstraints: BoxConstraints(maxHeight: 20),
                    isDense: true,
                    // important line
                    contentPadding: EdgeInsets.fromLTRB(0, 8, 0, 8),
                    errorText: _singleFieldEditTextRepository.errorMessages,
                    errorMaxLines: 100,
                    suffixIcon: Visibility(
                        visible: _singleFieldEditTextRepository.isShowDateIcon,
                        child: Icon(Icons.calendar_today))),
                // ),
                keyboardType: _singleFieldEditTextRepository.inputType,
              ),
            ),
          )
        ],
      );
    } else {
      return Row(
        children: [
          Text(
            field?.name ?? "",
            style: TextStyle(color: _singleFieldEditTextRepository.lableColor),
          ),
          Expanded(
            child: Text(
              _singleFieldEditTextRepository?.displayText ?? "",
              textAlign: TextAlign.end,
              style:
                  TextStyle(color: _singleFieldEditTextRepository.contentColor),
            ),
          )
        ],
      );
    }
  }

  @override
  bool get wantKeepAlive => true;
}

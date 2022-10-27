import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/custom_text_field_validate.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/response/create_management_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/create/group_customers/group_customers_create_screen.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

class BottomSheetAddValueScreen extends StatefulWidget {
  List<TypeProjects> listData;
  final void Function(TypeProjectMoney _typeProjects) onTypeProjects;

  BottomSheetAddValueScreen({this.listData, this.onTypeProjects});

  @override
  _BottomSheetAddValueScreenState createState() =>
      _BottomSheetAddValueScreenState();
}

class _BottomSheetAddValueScreenState extends State<BottomSheetAddValueScreen> {
  List<TypeProjects> listTypeProject = [];
  TypeProjects typeProject = TypeProjects();
  var valueController = TextEditingController();
  var costPriceController = TextEditingController();
  String grossProfit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listTypeProject = widget.listData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MediaQuery.of(context).viewInsets,
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: [
          TagLayoutWidget(
            isShowValidate: true,
            icon: Icons.arrow_drop_down,
            horizontalPadding: 0,
            title: "Loại dự án (Sản phẩm)",
            value: typeProject?.name ?? '',
            openFilterListener: () {
              _eventCallBackTypeProject();
              FocusScope.of(context).unfocus();
            },
          ),
          TextFieldValidate(
            padding: EdgeInsets.only(top: 8),
            keyboardType: TextInputType.number,
            title: 'Giá trị',
            isShowValidate: true,
            maxLength: 25,
            controller: valueController,
            onChange: () {
              setState(() {
                _getSubtractionValue();
              });
              valueController.selection =
                  TextSelection.collapsed(offset: valueController.text.length);
            },
          ),
          TextFieldValidate(
            maxLength: 25,
            padding: EdgeInsets.only(top: 8),
            keyboardType: TextInputType.number,
            title: 'Giá vốn',
            isShowValidate: true,
            controller: costPriceController ?? '',
            onChange: () {
              setState(() {
                _getSubtractionValue();
              });
              costPriceController.selection = TextSelection.collapsed(
                  offset: costPriceController.text.length);
            },
          ),
          TagLayoutWidget(
            horizontalPadding: 0,
            title: "Lãi gộp",
            value:
                grossProfit == null ? '' : getCurrencyFormat(grossProfit) ?? '',
            openFilterListener: () {
              setState(() {
                _getSubtractionValue();
              });
            },
          ),
          SaveButton(
            color: Colors.blue,
            margin: EdgeInsets.only(top: 8),
            title: 'XONG',
            onTap: () {
              if (typeProject == null || typeProject?.iD == null) {
                ToastMessage.show(
                    "Loại dự án (Sản phẩm)$textNotLeftBlank", ToastStyle.error);
                return;
              }

              if (valueController.text.length == 0) {
                ToastMessage.show("Giá trị$textNotLeftBlank", ToastStyle.error);
                return;
              }

              if (costPriceController.text.length == 0) {
                ToastMessage.show("Giá vốn$textNotLeftBlank", ToastStyle.error);
                return;
              }

              TypeProjectMoney data = TypeProjectMoney(
                  moneyID: 0,
                  moneyTotalMoney:
                      '${getCurrencyFormat(valueController.text)} VNĐ',
                  moneyCapital:
                      '${getCurrencyFormat(costPriceController.text)} VNĐ',
                  moneyIDTypeProject: typeProject?.iD ?? 0,
                  grossProfit: '${getCurrencyFormat(grossProfit)} VNĐ',
                  typeProject: typeProject,
                  nameTypeProject: typeProject?.name ?? '');
              widget.onTypeProjects(data);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  _getSubtractionValue() {
    int sum = 0;
    if (costPriceController.text.length == 0)
      sum = int.parse(valueController.text.replaceAll(',', ''));
    else
      sum = int.parse(valueController.text.replaceAll(',', '')) -
          int.parse(costPriceController.text.replaceAll(',', ''));
    grossProfit = sum.toString();
    valueController.text = getCurrencyFormat(valueController.text);
    costPriceController.text = getCurrencyFormat(costPriceController.text);
  }

  // Loại dự án
  _eventCallBackTypeProject() {
    if (isNullOrEmpty(listTypeProject)) {
      ToastMessage.show("Không có dữ liệu về Loại dự án!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listTypeProject,
          typeProject?.iD ?? 0,
          'Chọn loại dự án',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              typeProject = _groupCustomers;
            });
          },
        ));
  }
}

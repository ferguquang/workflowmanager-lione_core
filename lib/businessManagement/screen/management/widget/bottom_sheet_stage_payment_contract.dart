import 'package:flutter/material.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/divider_widget.dart';

import 'row_icon_text_widget.dart';

class BottomSheetStagePaymentContractScreen extends StatefulWidget {
  static const int VIEW_UPDATE = 1;
  static const int VIEW_DELETE = 2;

  final void Function(ModelContract data) onData;

  String title;

  BottomSheetStagePaymentContractScreen({this.title, this.onData});

  @override
  _BottomSheetStagePaymentContractScreenState createState() =>
      _BottomSheetStagePaymentContractScreenState();
}

class _BottomSheetStagePaymentContractScreenState
    extends State<BottomSheetStagePaymentContractScreen> {
  List<ModelContract> listData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listData.add(ModelContract(
        icon: Icons.error_outline_outlined,
        name: widget.title ?? '',
        isClick: false,
        type: 0));
    listData.add(ModelContract(
        icon: Icons.border_color,
        name: 'Chỉnh sửa' ?? '',
        isClick: true,
        type: BottomSheetStagePaymentContractScreen.VIEW_UPDATE));
    listData.add(ModelContract(
        icon: Icons.delete,
        name: 'Xóa' ?? '',
        isClick: true,
        type: BottomSheetStagePaymentContractScreen.VIEW_DELETE));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: MediaQuery.of(context).viewInsets,
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: listData?.length ?? 0,
        itemBuilder: (context, index) {
          ModelContract item = listData[index];
          return InkWell(
            child: _itemBottomSheetContract(item),
            onTap: () {
              if (item.isClick && item.type != 0) {
                Navigator.of(context).pop();
                widget.onData(item);
              }
            },
          );
        },
      ),
    );
  }

  Widget _itemBottomSheetContract(ModelContract item) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  item?.icon,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
              Expanded(
                child: Text(
                  item?.name,
                  style: TextStyle(
                      fontSize: !item.isClick ? 16 : null,
                      color: !item.isClick ? Colors.black : null),
                ),
              )
            ],
          ),
        ),
        DividerWidget(
          iHeight: 1,
        ),
      ],
    );
  }
}

class ModelContract {
  String name;
  IconData icon;
  bool isClick;
  int type;

  ModelContract({this.name, this.icon, this.isClick, this.type});
}

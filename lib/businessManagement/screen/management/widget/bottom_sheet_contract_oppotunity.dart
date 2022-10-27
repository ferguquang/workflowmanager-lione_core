import 'package:flutter/material.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/divider_widget.dart';

import 'row_icon_text_widget.dart';

class BottomSheetContractOpportunityScreen extends StatefulWidget {
  static const int VIEW_UPDATE = 1;
  static const int VIEW_DELETE = 2;
  static const int VIEW_DELETE_FOREVER = 3;
  static const int VIEW_RESTORE = 4;

  final void Function(ModelContract data) onData;

  Contracts contract;

  BottomSheetContractOpportunityScreen({this.contract, this.onData});

  @override
  _BottomSheetContractOpportunityScreenState createState() =>
      _BottomSheetContractOpportunityScreenState();
}

class _BottomSheetContractOpportunityScreenState
    extends State<BottomSheetContractOpportunityScreen> {
  List<ModelContract> listData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listData.add(ModelContract(
        icon: Icons.error_outline_outlined,
        name: widget.contract?.name ?? '',
        isClick: false,
        isShowView: true,
        type: 0));
    listData.add(ModelContract(
        icon: Icons.border_color,
        name: 'Chỉnh sửa' ?? '',
        isClick: true,
        isShowView: widget.contract?.isUpdate,
        type: BottomSheetContractOpportunityScreen.VIEW_UPDATE));
    listData.add(ModelContract(
        icon: Icons.delete,
        name: 'Xóa' ?? '',
        isClick: true,
        isShowView: widget.contract?.isTrash,
        type: BottomSheetContractOpportunityScreen.VIEW_DELETE));
    listData.add(ModelContract(
        icon: Icons.delete_forever,
        name: 'Xóa vĩnh viễn' ?? '',
        isClick: true,
        isShowView: widget.contract?.isDelete,
        type: BottomSheetContractOpportunityScreen.VIEW_DELETE_FOREVER));
    listData.add(ModelContract(
        icon: Icons.history,
        name: 'Khôi phục' ?? '',
        isClick: true,
        isShowView: widget.contract?.isRestore,
        type: BottomSheetContractOpportunityScreen.VIEW_RESTORE));
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
    return Visibility(
      visible: item.isShowView ?? false,
      child: Column(
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
      ),
    );
  }
}

class ModelContract {
  String name;
  IconData icon;
  bool isClick;
  bool isShowView;
  int type;

  ModelContract(
      {this.name, this.icon, this.isClick, this.isShowView, this.type});
}

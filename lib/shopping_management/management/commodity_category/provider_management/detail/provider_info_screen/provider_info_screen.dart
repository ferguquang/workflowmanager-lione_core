import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/detail/provider_info_screen/provider_info_repository.dart';
import 'package:workflow_manager/shopping_management/response/provider_response.dart';

// dùng chung: Thông tin nhà cung cấp (trong chi tiết) - tạo mới/chỉnh sửa NCC
class ProviderInfoScreen extends StatefulWidget {
  static final int TYPE_DETAIL = 1;
  static final int TYPE_CREATE = 2;
  static final int TYPE_UPDATE = 3;

  ProvidersIndex model;
  int type;

  ProviderInfoScreen({this.model, this.type});

  @override
  _ProviderInfoScreenState createState() => _ProviderInfoScreenState();
}

class _ProviderInfoScreenState extends State<ProviderInfoScreen> {
  ProviderInfoRepository _repository = ProviderInfoRepository();

  @override
  void initState() {
    super.initState();
    if (widget.type == ProviderInfoScreen.TYPE_CREATE) {
      _repository.addList(
        type: widget.type,
      );
    } else {
      _repository.getDetailProvider(widget.model.iD, type: widget.type);
    }
  }

  String _getTitle(int type) {
    if (type == ProviderInfoScreen.TYPE_DETAIL) {
      return "Thông tin nhà cung cấp";
    } else if (type == ProviderInfoScreen.TYPE_CREATE) {
      return "Tạo mới nhà cung cấp";
    } else {
      return "Chỉnh sửa nhà cung cấp";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (BuildContext context, ProviderInfoRepository repository, Widget child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_getTitle(widget.type)),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: repository.list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ContentViewShoppingItem(
                          model: repository.list[index],
                          position: index,
                          onClick: (item, position) {

                          },
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.type != ProviderInfoScreen.TYPE_DETAIL,
                    child: SaveButton(
                      title: "XONG",
                      onTap: () {

                      },
                      margin: EdgeInsets.all(16),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

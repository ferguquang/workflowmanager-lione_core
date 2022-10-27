import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/constracts/manager_constract/contract_list_screen.dart';
import 'package:workflow_manager/shopping_management/constracts/manager_serial/manager_serial_list_screen/manager_serial_list_screen.dart';
import 'package:workflow_manager/shopping_management/constracts/provider/choose_provider/choose_provider_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/management/management_shopping_screen.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';

class TypeContractScreen extends StatefulWidget {
  @override
  _TypeContractScreenState createState() => _TypeContractScreenState();
}

class _TypeContractScreenState extends State<TypeContractScreen> {
  List<ContentShoppingModel> data = [];
  static const int choose_supplier = 0;
  static const int approve_supplier = 1;
  static const int manager_constract = 2;
  static const int manager_serial = 3;

  @override
  void initState() {
    super.initState();
    ContentShoppingModel choiceProducer = ContentShoppingModel(
        title: "Lựa chọn nhà cung cấp",
        isNextPage: true,
        key: choose_supplier);
    ContentShoppingModel browser = ContentShoppingModel(
        title: "Duyệt lựa chọn nhà cung cấp",
        isNextPage: true,
        key: approve_supplier);
    ContentShoppingModel managerConstract = ContentShoppingModel(
        title: "Quản lý hợp đồng", isNextPage: true, key: manager_constract);
    ContentShoppingModel managerSerial = ContentShoppingModel(
        title: "Quản lý serial", isNextPage: true, key: manager_serial);
    if (shoppingRoles.isLuaChonNCC) data.add(choiceProducer);
    if (shoppingRoles.isDuyetLuaChonNCC) data.add(browser);
    if (shoppingRoles.isQuanLyHopDong) data.add(managerConstract);
    if (shoppingRoles.isQuanLySerial) data.add(managerSerial);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý hợp đồng"),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ContentViewShoppingItem(
            model: data[index],
            onClick: (model, index) {
              switch (model.key) {
                case choose_supplier:
                  {
                    pushPage(context, ChooseProviderScreen(false));
                    break;
                  }
                case approve_supplier:
                  {
                    pushPage(context, ChooseProviderScreen(true));
                    break;
                  }
                case manager_constract:
                  {
                    pushPage(context, ContractListScreen());
                    break;
                  }
                case manager_serial:
                  {
                    pushPage(context, ManagerSerialListScreen());
                    break;
                  }
              }
            },
          );
        },
      ),
    );
  }
}

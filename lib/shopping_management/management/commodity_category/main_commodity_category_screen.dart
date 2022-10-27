import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_category_management/commodity_category_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_management/commodity_management_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/manufacture_management/manufacture_management_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_management/provider_management_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/provider_vote/provider_vote_screen.dart';
import 'package:workflow_manager/shopping_management/management/management_shopping_screen.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';

class MainCommodityCategoryScreen extends StatefulWidget {
  @override
  _MainCommodityCategoryScreenState createState() => _MainCommodityCategoryScreenState();
}

class _MainCommodityCategoryScreenState extends State<MainCommodityCategoryScreen> {
  List<ContentShoppingModel> list = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(shoppingRoles.isQuanlyDmHangHoa) {
      list.add(ContentShoppingModel(key: "DMHH", title: "Quản lý danh mục hàng hóa"));
    }
    if(shoppingRoles.isQuanLyHang) {
      list.add(ContentShoppingModel(key: "QLH", title: "Quản lý hãng"));
    }
    if(shoppingRoles.isQuanLyHangHoa) {
      list.add(ContentShoppingModel(key: "QLHH", title: "Quản lý hàng hóa"));
    }
    if(shoppingRoles.isQuanLyNCC) {
      list.add(ContentShoppingModel(key: "QLNCC", title: "Quản lý nhà cung cấp"));
    }
    if(shoppingRoles.isDanhGiaNCC) {
      list.add(ContentShoppingModel(key: "DGNCC", title: "Đánh giá nhà cung cấp"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hàng hóa - Nhà cung cấp"),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return ContentViewShoppingItem(
              model: list[index],
              onClick: (item, position) {
                switch (item.key) {
                  case "DMHH":
                    pushPage(context, CommodityCategoryChildScreen());
                    break;
                  case "QLH":
                    pushPage(context, ManufactureManagementScreen());
                    break;
                  case "QLHH":
                    pushPage(context, CommodityManagementScreen());
                    break;
                  case "QLNCC":
                    pushPage(context, ProviderManagementScreen());
                    break;
                  case "DGNCC":
                    pushPage(context, ProviderVoteScreen());
                    break;
                }
              },
            );
          },
        ),
      ),
    );
  }
}

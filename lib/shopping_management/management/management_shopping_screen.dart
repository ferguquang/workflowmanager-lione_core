import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/manager/models/module.dart';
import 'package:workflow_manager/shopping_management/constracts/type_constract_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_screen.dart';
import 'package:workflow_manager/shopping_management/management/management_shopping_item.dart';
import 'package:workflow_manager/shopping_management/management/plan_shopping/plan_shopping_screen.dart';
import 'package:workflow_manager/shopping_management/management/report/report_statitic_screen.dart';
import 'package:workflow_manager/shopping_management/management/requisition_shopping/requisition_shopping_screen.dart';
import 'package:workflow_manager/shopping_management/payment_progress/main_payment_screen.dart';
import 'package:workflow_manager/shopping_management/response/module_role_response.dart';

ModuleRoleModel shoppingRoles;

class ManagementShoppingScreen extends StatefulWidget {
  @override
  _ManagementShoppingScreenState createState() =>
      _ManagementShoppingScreenState();
}

class _ManagementShoppingScreenState extends State<ManagementShoppingScreen> {
  double _aspectRatio = 1.5, _crossAxisSpacing = 0.2, _mainAxisSpacing = 0.2;
  List<Module> listModules = [];

  @override
  void initState() {
    super.initState();
    getModuleRoles();
  }

  getModuleRoles() async {
    var json =
        await ApiCaller.instance.postFormData(AppUrl.qlmsGetIModule, Map());
    ModuleRoleResponse response = ModuleRoleResponse.fromJson(json);
    if (response.status != 1) {
      showErrorToast(response.messages);
    } else {
      shoppingRoles = response.data;
      checkPermission();
    }
  }

  checkPermission() {
    if (shoppingRoles.isMenuHangHoaNCC) {
      listModules.add(Module("HH_NCC", "Hàng hóa - nhà cung cấp", "icon_hanghoa_ncc"));
    }
    if(shoppingRoles.isMenuKHMuaSam) {
      listModules.add(Module("KHMS", "Kế hoạch mua sắm", "icon_kh_muasam"));
    }
    if (shoppingRoles.isMenuYCMuaSam) {
      listModules.add(Module("YCMS", "Yêu cầu mua sắm", "icon_yeucau_muasam"));
    }
    if (shoppingRoles.isMenuQLHopDong) {
      listModules.add(Module("QLHD", "Quản lý hợp đồng", "icon_ql_hopdong"));
    }
    if (shoppingRoles.isMunuTienDoThucHien) {
      listModules.add(Module("TĐTH", "Tiến độ thực hiện", "icon_tiendo_thuchien"));
    }
    if (shoppingRoles.isMenuBaoCaoThongKe) {
      listModules.add(Module("BCTK", "Báo cáo thống kê", "icon_baocao_thongke"));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listModules.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: _aspectRatio,
        crossAxisSpacing: _crossAxisSpacing,
        mainAxisSpacing: _mainAxisSpacing,
      ),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: Container(
            alignment: Alignment.center,
            child: ManagementShoppingItem(listModules[index]),
            color: Colors.white,
          ),
          onTap: () async {
            switch (listModules[index].id) {
              case "HH_NCC":
                pushPage(context, MainCommodityCategoryScreen());
                break;
              case "KHMS":
                pushPage(context, PlanShoppingScreen());
                break;
              case "YCMS":
                pushPage(context, RequisitionShoppingScreen());
                break;
              case "QLHD":
                pushPage(context, TypeContractScreen());
                break;
              case "TĐTH":
                pushPage(context, MainPaymentProgressScreen());
                break;
              case "BCTK":
                pushPage(context, ReportStatiticScreen());
                break;
            }
          },
        );
      },
    );
  }
}

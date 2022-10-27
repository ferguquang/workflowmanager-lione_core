import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/commodity_category_management/commodity_category_screen.dart';
import 'package:workflow_manager/shopping_management/management/commodity_category/main_commodity_category_item.dart';
import 'package:workflow_manager/shopping_management/management/management_shopping_screen.dart';
import 'package:workflow_manager/shopping_management/management/report/import_report/import_report_screen.dart';
import 'package:workflow_manager/shopping_management/model/content_shopping_model.dart';
import 'package:workflow_manager/shopping_management/report/general_report_screen/general_report_screen.dart';
import 'package:workflow_manager/shopping_management/report/progress_progress_screen/progress_report_screen.dart';
import 'package:workflow_manager/shopping_management/report/provider_report/manufactur_report_screen.dart';

class ReportStatiticScreen extends StatefulWidget {
  @override
  _ReportStatiticScreenState createState() => _ReportStatiticScreenState();
}

class _ReportStatiticScreenState extends State<ReportStatiticScreen> {
  List<ContentShoppingModel> list = [];

  @override
  void initState() {
    super.initState();
    if(shoppingRoles.isBaoCaoTongHopMuaSam) {
      list.add(ContentShoppingModel(key: "THMS", title: "Báo cáo tổng hợp mua sắm dự án"));
    }
    if(shoppingRoles.isBaoCaoChiTietMuaSam) {
      list.add(ContentShoppingModel(key: "CTMS", title: "Báo cáo chi tiết mua sắm dự án"));
    }
    if(shoppingRoles.isBaoCaoTienDoMuaSam) {
      list.add(ContentShoppingModel(key: "TDMS", title: "Báo cáo tiến độ mua sắm dự án"));
    }
    if(shoppingRoles.isBaoCaoNhapHangPhanPhoi) {
      list.add(ContentShoppingModel(key: "NHMS", title: "Báo cáo nhập hàng phân phối"));
    }
    if(shoppingRoles.isBaoCaoMuaSamTheoHang) {
      list.add(ContentShoppingModel(key: "HANG", title: "Báo cáo mua sắm theo hãng"));
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
                  case "THMS":
                    pushPage(context, GeneralReportScreen(true));
                    break;
                  case "CTMS":
                    pushPage(context, GeneralReportScreen(false));

                    break;
                  case "TDMS":
                    pushPage(context, ProgressReportScreen());
                    break;
                  case "NHMS":
                    pushPage(context, ImportReportScreen());
                    break;
                  case "HANG":
                    pushPage(context, ManufacturReportScreen());
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

import 'package:workflow_manager/manager/models/response/home_index_response.dart';
import 'package:workflow_manager/procedures/models/response/report_procedure_response.dart';
import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/shopping_management/response/shopping_dashboard_response.dart';
import 'package:workflow_manager/storage/screens/tabs/main_tab_storage_screen.dart';

class AppStore {

  static bool isLogoutState = false;

  static int isViewDeadLine = 0; // phân biệt chế độ hiển thị Trạng thái công việc hay Theo dõi ngày kết thúc

  static int currentViewTypeWorkflow = 1; // phân biệt các tab Được giao, đã giao, phối hợp ...

  static StorageBottomTabType currentBottomViewTypeStorage = StorageBottomTabType.DataStorage; // Kho tài liệu, tài liệu cá nhân, tài liệu chia sẻ

  static String AppleID = "1548095234";

  static HomeIndexData homeIndexData; // Hiển thị đồ thị của trang home
  static int countNotify = 0;
  static ReportProcedureData reportProcedureData; // Hiển thị đồ thị QTTT

  static ReportShoppingDashBoardData reportShoppingData; // Hiển thị đồ thị quản lý mua sắm

  static int idNotify = 0;

  static String copyRight = "";
}
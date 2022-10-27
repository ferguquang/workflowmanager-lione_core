import 'package:workflow_manager/procedures/models/response/response_list_register.dart';
import 'package:workflow_manager/procedures/models/response/user.dart';

import '../select_model.dart';

class SearchProcedureModel {
  //Loại thủ tục
  List<TypeResolve> listTypeResolves;
  //Thủ tục
  List<Services> listServices;
  //Trạng thái
  List<FilterStates> listStates;
  //Mức độ
  List<FilterPriorities> listPriorities;
  //Tình trạng hồ sơ
  List<FilterStatusRecords> listStatusRecords;
  //User đăng ký
  List<UserRegister> listUserRegisters;
  //Danh sách phòng ban 
  List<FilterDept> listDepts;
  //Năm
  List<FilterYear> listYears;

}

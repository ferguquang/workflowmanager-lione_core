import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/custom_text_field_validate.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/request/create_management_request.dart';
import 'package:workflow_manager/businessManagement/model/response/create_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/cell/title_infor_item.dart';
import 'package:workflow_manager/businessManagement/screen/management/cell/value_project_item.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/divider_widget.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

import '../widget/bottom_sheet_add_value.dart';
import 'create_management_repository.dart';
import 'customers/customers_create_screen.dart';
import 'group_customers/group_customers_create_screen.dart';

class CreateManagementScreen extends StatefulWidget {
  static const int TYPE_CREATE = 1; // tạo mới
  static const int TYPE_EDIT = 2; // Chỉnh sửa
  static const int TYPE_COPY = 3; // sao chép

  int typeOpportunity;
  int idOpportunity;

  CreateManagementScreen({this.typeOpportunity, this.idOpportunity});

  @override
  _CreateManagementScreenState createState() => _CreateManagementScreenState();
}

class _CreateManagementScreenState extends State<CreateManagementScreen> {
  var _repository = CreateManagementRepository();
  String root;
  String title = 'TẠO MỚI CƠ HỘI';
  double dOpacity = 0.5;

  // thông tin khách hàng
  List<Seller> listCustomers = [];
  List<TypeProjects> listGroupCustomers = [];
  List<TypeProjects> listInforCustomers = [];
  Seller customers = Seller();
  TypeProjects groupCustomers = TypeProjects();
  TypeProjects inforCustomers = TypeProjects();
  bool isPermissionGroupCustomer = false; // true dc chọn, false không dc chọn
  bool isPermissionInforCustomer = false; // true dc chọn, false không dc chọn

  // thông tin tổng quan
  var nameOpportunityController = TextEditingController();
  String dateSignContract = '';
  List<TypeProjects> listTypeProject = [];
  TypeProjects typeProject = TypeProjects();

  //Thông tin chi tiết
  var costMarketingController = TextEditingController();
  List<TypeProjects> listProvince = []; // địa điểm triển khai
  TypeProjects province = TypeProjects();
  List<TypeProjects> listStarLevelContract = []; //đánh giá mức độ hợp đồng
  TypeProjects starLevelContract = TypeProjects();
  String levelContract = '';
  int numberPercent = 0;
  List<TypeProjects> listPhases = []; // giai đoạn
  TypeProjects phases = TypeProjects();
  bool isPermissionPhase = false; // true dc chọn, false không dc chọn
  List<TypeProjects> listCampaignTypes = []; // chiến dịch marketing
  TypeProjects campaignTypes = TypeProjects();
  List<TypeProjects> listDept = []; // phòng ban phụ trách
  TypeProjects dept = TypeProjects();
  var unitController = TextEditingController(); // đơn vị sử dụng
  var timePerformContractController = TextEditingController();
  var massDetailController = TextEditingController(); // khối lượng chi tiết
  var typeFileController = TextEditingController(); // Loại hồ sơ
  var advanceController = TextEditingController(); // điều khoản tạm ứng
  var payController = TextEditingController(); // điều khoản thanh toán
  String timeHSMTOpen = '';
  String expectedDateDemo = '';
  String expectedDateDeployment = '';

  //seller
  List<Seller> listSeller = [];
  Seller seller = Seller();
  bool isPermissionSeller = false; // true dc chọn, false không dc chọn

  //Thêm giá trị dự án
  List<TypeProjectMoney> listTypeProjectMoney = [];

  // dành cho update
  List<DataFields> dataFields = [];
  String totalMoney = '';
  String capital = '';
  String grossProfit = '';
  bool isShowTotalMoney = false;
  bool isShowCapital = false;
  bool isShowGrossProfit = false;

  // dành cho create
  User user = User();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProjectPlanCreate();
  }

  _getProjectPlanCreate() async {
    root = await SharedPreferencesClass.getRoot();
    await _repository.getProjectPlanCreate(
        widget.idOpportunity, widget.typeOpportunity);

    isPermissionGroupCustomer = _repository.dataCreate?.isSelectCustomer;
    isPermissionInforCustomer = _repository.dataCreate?.isSelectContact;

    listCustomers = _repository.dataCreate?.customers;
    listGroupCustomers = _repository.dataCreate?.typeBusiness;
    listInforCustomers = _repository.dataCreate?.contacts;
    listTypeProject = _repository.dataCreate?.typeProjects;
    listProvince = _repository.dataCreate?.provinces;
    listStarLevelContract = _repository.dataCreate?.potentialTypes;
    listPhases = _repository.dataCreate?.phases;
    listCampaignTypes = _repository.dataCreate?.campaignTypes;
    listDept = _repository.dataCreate?.centers;
    listSeller = _repository.dataCreate?.sellers;
    isPermissionPhase = _repository.dataCreate?.isChangePhase;
    isPermissionSeller = _repository.dataCreate?.isSelectSeller;
    dataFields = _repository.dataCreate?.projectPlan?.dataFields;
    listTypeProjectMoney = _repository.dataCreate?.typeProjectMoney;

    if (widget.typeOpportunity == CreateManagementScreen.TYPE_EDIT) {
      title = 'Chỉnh sửa cơ hội';
      isShowTotalMoney = true;
      isShowCapital = true;
      isShowGrossProfit = true;
    } else if (widget.typeOpportunity == CreateManagementScreen.TYPE_COPY) {
      title = 'Sao chép cơ hội';
      isShowTotalMoney = false;
      isShowCapital = false;
      isShowGrossProfit = false;
    }
    _getDataForView();
  }

  _getDataForView() {
    // tỷ lệ thành công
    numberPercent =
        _repository.dataCreate?.projectPlan?.potentialTypeSuccessPercent ?? 0;
    //định nghĩa mức độ đánh giá
    levelContract =
        _repository.dataCreate?.projectPlan?.potentialTypeDescribe ?? '';

    setState(() {
      if (isNotNullOrEmpty(dataFields)) {
        for (int i = 0; i < dataFields?.length; i++) {
          switch (_getName(i)) {
            case "ID":
              // titleAddProjectValue.setEnabled(getIsUpdate(i));
              break;

            case "IDCustomer": // Khách hàng
              customers =
                  _getListSeller(listCustomers, int.parse(_getValue(i)));
              break;
            case "IDTypeBusiness": // Nhóm khách hàng
              groupCustomers = _getListTypeProjects(
                  listGroupCustomers, int.parse(_getValue(i)));
              break;
            case "IDContact": // Thông tin liên hệ
              inforCustomers = _getListTypeProjects(
                  listInforCustomers, int.parse(_getValue(i)));
              break;

            case "Name": // tên cơ hội
              nameOpportunityController.text = _getValue(i);
              break;
            case "IDTypeProject": // Loại dự án (sản phẩm)
              typeProject = _getListTypeProjects(
                  listTypeProject, int.parse(_getValue(i)));
              break;
            case "StartDate": // ngày dự kiến ký hợp đồng
              dateSignContract = _getValue(i);
              break;
            case "IDCenter": // Phòng ban phụ trách
              dept = _getListTypeProjects(listDept, int.parse(_getValue(i)));
              break;
            case "IDSeller": // AM(Sale)
              seller = _getListSeller(listSeller, int.parse(_getValue(i)));
              break;
            case "PotentialType": //Mức độ đánh giá cơ hội
              starLevelContract = _getListTypeProjects(
                  listStarLevelContract, int.parse(_getValue(i)));
              break;
            case "Province": // Địa điểm triển khai
              province =
                  _getListTypeProjects(listProvince, int.parse(_getValue(i)));
              break;
            case "IDPhase": // Giai đoạn
              phases =
                  _getListTypeProjects(listPhases, int.parse(_getValue(i)));
              break;
            case "CampaignType": // Chiến dịch Marketing
              campaignTypes = _getListTypeProjects(
                  listCampaignTypes, int.parse(_getValue(i)));
              break;
            case "MarketingCost": // Chi phí maketing
              costMarketingController.text = _getValue(i);
              break;

            case "Investors": // Đơn vị sử dụng
              unitController.text = _getValue(i);
              break;
            case "ExecuteDuration": // Thời gian thực hiện hợp đồng
              timePerformContractController.text = _getValue(i);
              break;
            case "AdvanceTerms": // Điều khoản tạm ứng
              advanceController.text = _getValue(i);
              break;
            case "PaymentTerms": // Điều khoản thanh toán
              payController.text = _getValue(i);
              break;
            case "TendererDate": // Ngày chuẩn bị HSMT thầu/ mở thầu
              timeHSMTOpen = _getValue(i);
              break;
            case "DemoDate": // Ngày triển khảo sát, tư vấn, demo
              expectedDateDemo = _getValue(i);
              break;
            case "DeployDate": // Ngày dự kiến triển khai
              expectedDateDeployment = _getValue(i);
              break;
            case "DetailAmount": // Khối lượng chi tiết
              massDetailController.text = _getValue(i);
              break;
            case "ProfileType": // Loại hồ sơ
              typeFileController.text = _getValue(i);
              break;

            case "TotalMoney": // Giá trị dự kiến
              totalMoney = _getValue(i);
              break;
            case "Capital": // Giá vốn
              capital = _getValue(i);
              break;
            case "GrossProfit": // Lãi gộp
              grossProfit = _getValue(i);
              break;
          }
        }
      }
      if (isNotNullOrEmpty(listTypeProjectMoney)) {
        listTypeProjectMoney.forEach((element) {
          listTypeProject.forEach((element1) {
            if (element.moneyIDTypeProject == element1.iD) {
              element.nameTypeProject = element1.name;
              return;
            }
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, CreateManagementRepository __repository1, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SafeArea(
              child: _listViewWidget(),
            ),
          );
        },
      ),
    );
  }

  Widget _listViewWidget() {
    return ListView(
      children: [
        // Thông tin khách hàng
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TitleInforItem(
                title: 'Thông tin khách hàng',
              ),
              TagLayoutWidget(
                isShowValidate: true,
                icon: Icons.arrow_drop_down,
                horizontalPadding: 0,
                title: "Khách hàng",
                value: customers?.name ?? '',
                openFilterListener: () {
                  _eventCallBackCustomers();
                  FocusScope.of(context).unfocus();
                },
              ),
              TagLayoutWidget(
                icon: Icons.arrow_drop_down,
                horizontalPadding: 0,
                title: "Nhóm khách hàng",
                value: groupCustomers?.name ?? '',
              ),
              TagLayoutWidget(
                isShowValidate: true,
                icon: Icons.arrow_drop_down,
                horizontalPadding: 0,
                title: "Thông tin liên hệ",
                value: inforCustomers?.name ?? '',
                openFilterListener: () {
                  _eventCallBackInforCustomers();
                  FocusScope.of(context).unfocus();
                },
              ),
            ],
          ),
        ),
        DividerWidget(),
        // Thông tin tổng quan
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              //  Thông tin tổng quan
              TitleInforItem(
                title: 'Thông tin tổng quan',
              ),
              //  Tên cơ hội
              TextFieldValidate(
                padding: EdgeInsets.only(top: 8),
                title: 'Tên cơ hội',
                isShowValidate: true,
                controller: nameOpportunityController,
                maxLength: 500,
              ),
              //  Loại dự án (Sản phẩm)
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
              //  Ngày ký kết hợp đồng (dự kiến)
              TagLayoutWidget(
                isShowValidate: true,
                horizontalPadding: 0,
                title: "Ngày ký kết hợp đồng (dự kiến)",
                value: dateSignContract,
                icon: Icons.date_range,
                openFilterListener: () {
                  FocusScope.of(context).unfocus();
                  DateTimePickerWidget(
                      // minTime: DateTime.now(),
                      format: Constant.ddMMyyyy2,
                      context: context,
                      onDateTimeSelected: (valueDate) {
                        setState(() {
                          dateSignContract = valueDate;
                        });
                        // print(valueDate);
                      }).showOnlyDatePicker();
                },
              ),
              // Phòng ban phụ trách
              TagLayoutWidget(
                isShowValidate: true,
                horizontalPadding: 0,
                title: "Phòng ban phụ trách",
                value: dept?.name ?? '',
                icon: Icons.arrow_drop_down,
                openFilterListener: () {
                  _eventCallBackDept();
                  FocusScope.of(context).unfocus();
                },
              ),
              // Giá trị dự kiến
              Visibility(
                visible: isShowTotalMoney,
                child: Opacity(
                  opacity: dOpacity,
                  child: TagLayoutWidget(
                    isShowValidate: true,
                    horizontalPadding: 0,
                    title: "Giá trị dự kiến",
                    value: '${getCurrencyFormat(totalMoney)} VNĐ',
                  ),
                ),
              ),
              // Giá vốn
              Visibility(
                visible: isShowCapital,
                child: Opacity(
                  opacity: dOpacity,
                  child: TagLayoutWidget(
                    isShowValidate: true,
                    horizontalPadding: 0,
                    title: "Giá vốn",
                    value: '${getCurrencyFormat(capital)} VNĐ',
                  ),
                ),
              ),
              // Lãi gộp
              Visibility(
                visible: isShowGrossProfit,
                child: Opacity(
                  opacity: dOpacity,
                  child: TagLayoutWidget(
                    isShowValidate: true,
                    horizontalPadding: 0,
                    title: "Lãi gộp",
                    value: '${getCurrencyFormat(grossProfit)} VNĐ',
                  ),
                ),
              ),
            ],
          ),
        ),
        // AM (Sale)
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TitleInforItem(
                title: 'AM (Sale)',
                colors: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    Text(
                      "Chọn AM (Sale)",
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      '*',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: Colors.blue,
                            width: 1,
                            style: BorderStyle.solid)),
                    child: InkWell(
                      onTap: () {
                        _eventCallBackSeller();
                        FocusScope.of(context).unfocus();
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  CircleNetworkImage(
                      height: 40,
                      width: 40,
                      url: "$root${seller?.avatar?.replaceAll('$root', '')}" ??
                          '')
                ],
              ),
            ],
          ),
        ),
        DividerWidget(),
        // Thông tin chi tiết
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleInforItem(
                title: 'Thông tin chi tiết',
              ),
              //Đánh giá mức độ cơ hội
              TagLayoutWidget(
                isShowValidate: true,
                horizontalPadding: 0,
                title: "Đánh giá mức độ cơ hội",
                value: starLevelContract?.name ?? '',
                icon: Icons.arrow_drop_down,
                openFilterListener: () {
                  _eventCallBackStarLevelContract();
                  FocusScope.of(context).unfocus();
                },
              ),
              // Định nghĩa mức độ đánh giá
              Text(
                'Định nghĩa mức độ đánh giá',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        //mức độ hợp đồng
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Html(
            style: {"body": Style(textAlign: TextAlign.start)},
            data: levelContract ?? "",
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tỷ lệ thành công
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tỷ lệ thành công: ',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      '$numberPercent%',
                    ),
                  ],
                ),
              ),
              // Giai đoạn
              TagLayoutWidget(
                isShowValidate: true,
                horizontalPadding: 0,
                title: "Giai đoạn",
                value: phases?.name ?? '',
                icon: Icons.arrow_drop_down,
                openFilterListener: () {
                  _eventCallBackPhases();
                  FocusScope.of(context).unfocus();
                },
              ),
              // Địa điểm triển khai
              TagLayoutWidget(
                isShowValidate: true,
                icon: Icons.arrow_drop_down,
                horizontalPadding: 0,
                title: "Địa điểm triển khai",
                value: province?.name ?? '',
                openFilterListener: () {
                  _eventCallBackProvince();
                  FocusScope.of(context).unfocus();
                },
              ),
              // Ngày dự kiến triển khai
              TagLayoutWidget(
                isShowValidate: true,
                horizontalPadding: 0,
                title: "Ngày dự kiến triển khai",
                value: expectedDateDeployment,
                icon: Icons.date_range,
                openFilterListener: () {
                  FocusScope.of(context).unfocus();
                  DateTimePickerWidget(
                    // minTime: DateTime.now(),
                      format: Constant.ddMMyyyy2,
                      context: context,
                      onDateTimeSelected: (valueDate) {
                        setState(() {
                          expectedDateDeployment = valueDate;
                        });
                        // print(valueDate);
                      }).showOnlyDatePicker();
                },
              ),
              // Thời gian chuẩn bị HSMT thầu/ mở thầu
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TagLayoutWidget(
                  isShowValidate: true,
                  horizontalPadding: 0,
                  title: "Thời gian chuẩn bị HSMT thầu/ mở thầu",
                  value: timeHSMTOpen,
                  icon: Icons.date_range,
                  openFilterListener: () {
                    FocusScope.of(context).unfocus();
                    DateTimePickerWidget(
                      // minTime: DateTime.now(),
                        format: Constant.ddMMyyyy2,
                        context: context,
                        onDateTimeSelected: (valueDate) {
                          setState(() {
                            timeHSMTOpen = valueDate;
                          });
                          print(valueDate);
                        }).showOnlyDatePicker();
                  },
                ),
              ),
              // Ngày dự kiến khảo sát, tư vấn, demo
              TagLayoutWidget(
                isShowValidate: true,
                horizontalPadding: 0,
                title: "Ngày dự kiến khảo sát, tư vấn, demo",
                value: expectedDateDemo,
                icon: Icons.date_range,
                openFilterListener: () {
                  FocusScope.of(context).unfocus();
                  DateTimePickerWidget(
                    // minTime: DateTime.now(),
                      format: Constant.ddMMyyyy2,
                      context: context,
                      onDateTimeSelected: (valueDate) {
                        setState(() {
                          expectedDateDemo = valueDate;
                        });
                        // print(valueDate);
                      }).showOnlyDatePicker();
                },
              ),
              // Chiến dịch marketing
              TagLayoutWidget(
                isShowValidate: true,
                horizontalPadding: 0,
                title: "Chiến dịch marketing",
                value: campaignTypes?.name ?? '',
                icon: Icons.arrow_drop_down,
                openFilterListener: () {
                  _eventCallBackCampaignTypes();
                  FocusScope.of(context).unfocus();
                },
              ),
              // Chi phí marketing (%)
              TextFieldValidate(
                inputFormatters:
                    FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                padding: EdgeInsets.only(top: 8),
                title: 'Chi phí marketing (%)',
                controller: costMarketingController,
                maxLength: 6,
                onChange: () {
                  costMarketingController =
                      getDataPercentController(costMarketingController);
                },
              ),
              // Đơn vị sử dụng
              TextFieldValidate(
                isShowValidate: true,
                padding: EdgeInsets.only(top: 8),
                title: 'Đơn vị sử dụng',
                controller: unitController,
              ),
              // Thời gian thực hiện hợp đồng (Ngày)
              TextFieldValidate(
                keyboardType: TextInputType.number,
                padding: EdgeInsets.only(top: 12),
                title: 'Thời gian thực hiện hợp đồng (Ngày)',
                controller: timePerformContractController,
              ),
              // Điều khoản tạm ứng
              TextFieldValidate(
                padding: EdgeInsets.only(top: 12),
                title: 'Điều khoản tạm ứng',
                controller: advanceController,
              ),
              // Điểu khoản thanh toán
              TextFieldValidate(
                padding: EdgeInsets.only(top: 12),
                title: 'Điểu khoản thanh toán',
                controller: payController,
              ),
              // Khối lượng chi tiết
              TextFieldValidate(
                isShowValidate: true,
                padding: EdgeInsets.only(top: 12),
                title: 'Khối lượng chi tiết',
                controller: massDetailController,
              ),
              // Loại hồ sơ
              TextFieldValidate(
                isShowValidate: true,
                padding: EdgeInsets.only(top: 12),
                title: 'Loại hồ sơ',
                controller: typeFileController,
              ),
            ],
          ),
        ),
        DividerWidget(),
        // thêm giá trị dự án
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    _eventCallBackAddValueProject();
                  },
                  child: TitleInforItem(
                    title: 'Thêm giá trị dự án',
                    colors: Colors.blue,
                  ),
                ),
              ],
            )),
        isNullOrEmpty(listTypeProjectMoney)
            ? Container()
            : ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                itemCount: listTypeProjectMoney?.length ?? 0,
                itemBuilder: (context, index) {
                  TypeProjectMoney _item = listTypeProjectMoney[index];
                  return ValueProjectItem(
                    _item,
                    index + 1,
                    onTypeProjects: () {
                      setState(() {
                        listTypeProjectMoney.remove(_item);
                        getSumValueProject();
                      });
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
        SaveButton(
          margin: EdgeInsets.all(8),
          title: 'XONG',
          onTap: () {
            _eventClickSaveOpportunity();
          },
        ),
      ],
    );
  }

  // customers
  // chọn khách hàng call api nhóm khách hàng để lấy list khách hàng và infor khách hàng
  _eventCallBackCustomers() {
    pushPage(
        context,
        CustomersCreateScreen(
          listCustomers,
          customers?.iD ?? 0,
          'Chọn khách hàng',
          root,
          onSeller: (_seller) {
            setState(() {
              getGroupCustomers(_seller);
            });
          },
        ));
  }

  // khách hàng
  getGroupCustomers(Seller _seller) async {
    phases = TypeProjects(); // giai đoạn
    if (_seller != null) {
      customers = _seller;
      await _repository.getSelectGroupCustomer(customers?.iD);
      if (isNotNullOrEmpty(_repository.dataGroupCustomer)) {
        listGroupCustomers = _repository.dataGroupCustomer?.typeBusiness;
        listInforCustomers = _repository.dataGroupCustomer?.contacts;
        listPhases = _repository.dataGroupCustomer?.phases;
        if (listGroupCustomers?.length == 1) {
          groupCustomers = listGroupCustomers[0];
        }
        if (listInforCustomers.length > 0) {
          inforCustomers = listInforCustomers[0];
        } else {
          inforCustomers = TypeProjects();
        }
      } else {
        _refreshCustomers();
      }
    } else {
      _refreshCustomers();
    }
  }

  _refreshCustomers() {
    customers = Seller();
    groupCustomers = TypeProjects();
    inforCustomers = TypeProjects();
    listGroupCustomers = [];
    listInforCustomers = [];
    listPhases = _repository.dataCreate?.phases;
  }

  // thông tin khách hàng
  _eventCallBackInforCustomers() {
    if (!isPermissionInforCustomer) {
      ToastMessage.show(
          "Tài khoản của bạn không có quyền chọn Thông tin liên hệ!",
          ToastStyle.warning);
      return;
    }
    if (isNullOrEmpty(inforCustomers) ||
        inforCustomers?.iD == null && isNullOrEmpty(listInforCustomers)) {
      ToastMessage.show("Vui lòng chọn Khách hàng trước.", ToastStyle.warning);
      return;
    }
    if (isNullOrEmpty(listInforCustomers)) {
      ToastMessage.show(
          "Không có dữ liệu về Thông tin liên hệ!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listInforCustomers,
          inforCustomers?.iD ?? 0,
          'Chọn thông tin liên hệ',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              inforCustomers = _groupCustomers;
            });
          },
        ));
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

  // Địa điểm triển khai
  _eventCallBackProvince() {
    if (isNullOrEmpty(listProvince)) {
      ToastMessage.show(
          "Không có dữ liệu về Địa điểm triển khai!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listProvince,
          province?.iD ?? 0,
          'Chọn địa điểm triển khai',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              province = _groupCustomers;
            });
          },
        ));
  }

  // Đánh giá mực độ cơ hội
  _eventCallBackStarLevelContract() {
    if (isNullOrEmpty(listStarLevelContract)) {
      ToastMessage.show(
          "Không có dữ liệu về Đánh giá mực độ cơ hội!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listStarLevelContract,
          starLevelContract?.iD ?? 0,
          'Chọn đánh giá mực độ cơ hội',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              if (_groupCustomers == null || _groupCustomers?.iD == null) {
                levelContract = '';
                numberPercent = 0;
                starLevelContract = TypeProjects();
              } else {
                starLevelContract = _groupCustomers;
                _getPotentialTypes(_groupCustomers);
              }
            });
          },
        ));
  }

  _getPotentialTypes(TypeProjects _groupCustomers) async {
    await _repository.getPotentialTypes(_groupCustomers?.iD);
    levelContract =
        _repository.dataPotentialTypeInfo?.potentialType?.describe ?? '';
    numberPercent =
        _repository.dataPotentialTypeInfo?.potentialType?.successPercent ?? '';
  }

  // Giai đoạn
  _eventCallBackPhases() {
    if (!isPermissionPhase) {
      ToastMessage.show("Tài khoản của bạn không có quyền chọn Giai đoạn!",
          ToastStyle.warning);
      return;
    }

    if (isNullOrEmpty(listPhases)) {
      ToastMessage.show("Không có dữ liệu về Giai đoạn!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listPhases,
          phases?.iD ?? 0,
          'Chọn giai đoạn',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              phases = _groupCustomers;
            });
          },
        ));
  }

  // Chiến dịch markerting
  _eventCallBackCampaignTypes() {
    if (isNullOrEmpty(listCampaignTypes)) {
      ToastMessage.show(
          "Không có dữ liệu về Chiến dịch markerting!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listCampaignTypes,
          campaignTypes?.iD ?? 0,
          'Chọn chiến dịch markerting',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              campaignTypes = _groupCustomers;
            });
          },
        ));
  }

  // Phòng ban phụ trách
  _eventCallBackDept() {
    if (isNullOrEmpty(listDept)) {
      ToastMessage.show(
          "Không có dữ liệu về Phòng ban phụ trách!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listDept,
          dept?.iD ?? 0,
          'Chọn phòng ban phụ trách',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              dept = _groupCustomers;
            });
          },
        ));
  }

  // seller
  _eventCallBackSeller() {
    if (!isPermissionSeller) {
      ToastMessage.show("Tài khoản của bạn không có quyền chọn AM (Sale)!",
          ToastStyle.warning);
      return;
    }
    if (isNullOrEmpty(listSeller)) {
      ToastMessage.show(
          "Dữ liệu AM (Sale) rỗng! Vui lòng thử lại sau.", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        CustomersCreateScreen(
          listSeller,
          seller?.iD ?? 0,
          'Chọn AM',
          root,
          onSeller: (_seller) {
            setState(() {
              seller = _seller;
            });
          },
        ));
  }

  // Thêm giá trị dự án
  _eventCallBackAddValueProject() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: this.context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Wrap(
            children: [
              BottomSheetAddValueScreen(
                listData: listTypeProject,
                onTypeProjects: (_typeProjects) {
                  setState(() {
                    listTypeProjectMoney.add(_typeProjects);
                    getSumValueProject();
                  });
                },
              ),
            ],
          );
        });
  }

  // save, update
  _eventClickSaveOpportunity() async {
    if (customers?.iD == null) {
      ToastMessage.show("Khách hàng$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (inforCustomers?.iD == null) {
      ToastMessage.show("Thông tin liên hệ$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (nameOpportunityController.text.length == 1) {
      ToastMessage.show("Tên cơ hội$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (typeProject?.iD == null) {
      ToastMessage.show(
          "Loại dự án (Sản phẩm)$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(dateSignContract)) {
      ToastMessage.show(
          "Ngày ký kết hợp đồng (dự kiến)$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (dept?.iD == null) {
      ToastMessage.show(
          "Phòng ban phụ trách$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (seller?.iD == null) {
      ToastMessage.show("Chọn AM (Sale)$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (starLevelContract?.iD == null) {
      ToastMessage.show(
          "Đánh giá mức độ cơ hội$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (phases?.iD == null) {
      ToastMessage.show("Giai đoạn$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (province?.iD == null) {
      ToastMessage.show(
          "Địa điểm triển khai$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(expectedDateDeployment)) {
      ToastMessage.show(
          "Ngày dự kiến triển khai$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(timeHSMTOpen)) {
      ToastMessage.show(
          "Thời gian chuẩn bị HSMT thầu/ mở thầu$textNotLeftBlank",
          ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(expectedDateDemo)) {
      ToastMessage.show("Ngày dự kiến khảo sát, tư vấn, demo$textNotLeftBlank",
          ToastStyle.error);
      return;
    }
    if (campaignTypes.iD == null) {
      ToastMessage.show(
          "Chiến dịch marketing$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (costMarketingController.text.length == 0) {
      ToastMessage.show("Chi phí marketing$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (unitController.text.length == 0) {
      ToastMessage.show("Đơn vị sử dụng$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (massDetailController.text.length == 0) {
      ToastMessage.show(
          "Khối lượng chi tiết$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (typeFileController.text.length == 0) {
      ToastMessage.show("Loại hồ sơ$textNotLeftBlank", ToastStyle.error);
      return;
    }

    if (listTypeProjectMoney.length == 0) {
      ToastMessage.show("Giá trị dự án$textNotLeftBlank", ToastStyle.error);
      return;
    }

    CreateManagementRequest request = CreateManagementRequest();
    // Token : mã token đăng nhập
    // IDCustomer : id khách hàng
    request.iDCustomer = customers?.iD ?? 0;
    // IDTypeBusiness: nhóm khách hàng (sau khi chọn KH)
    request.iDTypeBusiness = groupCustomers?.iD ?? 0;
    // IDContact: người liên hệ   (sau khi chọn KH)
    request.iDContact = inforCustomers?.iD ?? 0;
    // Name:tên dự án
    request.nameOpportunity = nameOpportunityController.text;
    // IDTypeProject: 144380 //loại dự án
    request.iDTypeProject = typeProject?.iD ?? 0;
    // StartDate:ngày bắt đầu dự án
    request.startDate = dateSignContract;
    // TotalMoney:tổng tiền dự kiến
    // Capital:giá vốn
    // MarketingCost : chi phí marketing
    request.marketingCost = costMarketingController.text;
    // Province:13743 //địa điểm triển khai
    request.province = province?.iD ?? 0;
    // PotentialType:1 //đánh giá cơ hội
    request.potentialType = starLevelContract?.iD ?? 0;
    // IDPhase: giai đoạn
    request.iDPhase = phases?.iD ?? 0;
    // CampaignType: //chiến dịch mkt
    request.campaignType = campaignTypes?.iD ?? 0;
    // IDCenter:602 //phòng ban
    request.iDCenter = dept?.iD ?? 0;
    // IDSeller:29// id của sale
    request.iDSeller = seller?.iD ?? 0;
    // Investors // Đơn vị sử dụng
    request.investors = unitController.text;
    // ExecuteDuration // Thời gian thực hiện hợp đồng (ngày)
    request.executeDuration = timePerformContractController.text;
    // TendererDate // Ngày dự kiến thầu/mở thầu
    request.tendererDate = timeHSMTOpen;
    // DemoDate // Ngày triển khảo sát, tư ván, demo
    request.demoDate = expectedDateDemo;
    // DeployDate // Ngày dự kiến triển khai
    request.deployDate = expectedDateDeployment;
    // DetailAmount  // Khối lượng chi tiết
    request.detailAmount = massDetailController.text;
    // ProfileType  // Loại hồ sơ
    request.profileType = typeFileController.text;
    // AdvanceTerms // Điều khoản tạm ứng
    request.advanceTerms = advanceController.text;
    // PaymentTerms // Điều khoản thanh toán
    request.paymentTerms = payController.text;
    // ================ DS Chi tiết giá trị dự án *
    // Money_ID // thêm mới truyền 0
    request.money_ID =
        listTypeProjectMoney.map((e) => e.moneyID).toList().toString();
    // Money_IDTypeProject //Loại dự án
    request.money_IDTypeProject = listTypeProjectMoney
        .map((e) => e.moneyIDTypeProject)
        .toList()
        .toString();
    // Money_TotalMoney //Giá trị
    request.money_TotalMoney = listTypeProjectMoney
        .map(
            (e) => e.moneyTotalMoney.replaceAll(',', '').replaceAll(' VNĐ', ''))
        .toList()
        .toString();
    // Money_Capital //lãi vốn
    request.money_Capital = listTypeProjectMoney
        .map((e) => e.moneyCapital.replaceAll(',', '').replaceAll(' VNĐ', ''))
        .toList()
        .toString();
    if (widget.typeOpportunity == CreateManagementScreen.TYPE_EDIT) {
      request.id = widget.idOpportunity;
    }
    bool status =
        await _repository.getPotentialSave(request, widget.typeOpportunity);
    if (status) Navigator.of(context).pop();
  }

  // dành cho update
  String _getName(int index) {
    return dataFields[index].name ?? '';
  }

  String _getValue(int index) {
    return dataFields[index].value ?? '';
  }

  bool _getUpdate(int index) {
    return dataFields[index].isUpdate;
  }

  bool _getTemp(int index) {
    return dataFields[index].isTemp;
  }

  Seller _getListSeller(List<Seller> _listSeller, int _seller) {
    return _listSeller.firstWhere(
      (element) => element?.iD == _seller,
      orElse: () => Seller(),
    );
  }

  TypeProjects _getListTypeProjects(
      List<TypeProjects> _listTypeProjects, int _typeProjects) {
    return _listTypeProjects.firstWhere(
        (element) => element?.iD == _typeProjects,
        orElse: () => TypeProjects());
  }

  getSumValueProject() {
    if (widget.typeOpportunity == CreateManagementScreen.TYPE_EDIT) {
      int iTotalMoney = 0;
      int iCapital = 0;
      int iGrossProfit = 0;
      listTypeProjectMoney.forEach((element) {
        iTotalMoney = iTotalMoney +
            int.parse(element.moneyTotalMoney
                .replaceAll(',', '')
                .replaceAll(' VNĐ', ''));
        iCapital = iCapital +
            int.parse(element.moneyCapital
                .replaceAll(',', '')
                .replaceAll(' VNĐ', ''));
        iGrossProfit = iGrossProfit +
            int.parse(
                element.grossProfit.replaceAll(',', '').replaceAll(' VNĐ', ''));
      });
      this.totalMoney = iTotalMoney.toString();
      this.capital = iCapital.toString();
      this.grossProfit = iGrossProfit.toString();
    }
  }
}

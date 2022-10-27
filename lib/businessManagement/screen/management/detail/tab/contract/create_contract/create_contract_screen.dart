import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/custom_text_field_validate.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/request/create_contract_request.dart';
import 'package:workflow_manager/businessManagement/model/request/save_contract_request.dart';
import 'package:workflow_manager/businessManagement/model/response/create_contract_response.dart';
import 'package:workflow_manager/businessManagement/model/response/create_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/over_view_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/create/customers/customers_create_screen.dart';
import 'package:workflow_manager/businessManagement/screen/management/create/group_customers/group_customers_create_screen.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/divider_widget.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/stage_payment/bottom_sheet_create_phase.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

import 'create_contract_repository.dart';

class CreateContractScreen extends StatefulWidget {
  int iDProjectPlan;
  bool isCreate; // true là tạo mới, false là chỉnh sửa

  CreateContractScreen(this.iDProjectPlan, this.isCreate);

  @override
  _CreateContractScreenState createState() => _CreateContractScreenState();
}

// hiện tại module này không có tạo mới hợp đồng
// lên sẽ thừa module sửa có thể xóa
// nếu dùng lại thì sẽ tạo hợp đồng thì cần 2 list file và Doanh thu xuất hóa đơn xem có sai không
class _CreateContractScreenState extends State<CreateContractScreen> {
  CreateContractRepository _repository = CreateContractRepository();
  String title = 'Tạo mới hợp đồng';
  var codePrefixController = TextEditingController();
  var codeContractController = TextEditingController();
  var numberContractController = TextEditingController();
  var nameContractController = TextEditingController();
  var absoluteValueContractController = TextEditingController();
  var revenueController = TextEditingController();
  var valueContractController = TextEditingController();
  var capitalContractController = TextEditingController();
  var grossProfitContractController = TextEditingController();
  var costMarketingController = TextEditingController();
  var costDeploymentController = TextEditingController();
  var bonusController = TextEditingController();
  String dateSignContract = '';
  String dateEffectContract = '';
  String endDate = '';

  Contract contract;
  // khách hàng
  List<Seller> listCustomers = [];
  Seller customer = Seller();
  bool isPermissionCustomer = false;
  // cơ hội
  List<TypeProjects> listProjectPlans = [];
  TypeProjects projectPlan = TypeProjects();
  bool isPermissionProjectPlan = false;
  //Loại hợp đồng
  List<TypeProjects> listTypeProjects = [];
  TypeProjects typeProject = TypeProjects();
  //Địa điểm triển khai
  List<TypeProjects> listProvinces = [];
  TypeProjects provinces = TypeProjects();
  //Giai đoạn hợp đồng
  List<TypeProjects> listStatuses = [];
  TypeProjects statuses = TypeProjects();
  // AM (Sale)
  List<Seller> listSeller = [];
  Seller seller = Seller();
  bool isPermissionSeller = false;
  // Phòng ban phụ trách
  List<TypeProjects> listCenters = [];
  TypeProjects centers = TypeProjects();
  // Loại hình hợp đồng
  List<TypeProjects> listTypeContract = [];
  TypeProjects typeContract = TypeProjects();
  bool isShowViewValue = true;
  // Tiêu chí thưởng
  List<TypeProjects> listBonusType = [];
  TypeProjects bonusType = TypeProjects();
  // file đính kèm
  List<Attachments> listAttachments = [];
  List<Attachments> listAttachmentsDeploy = [];
  // Thêm mới giai đoạn
  List<Payments> listPayments = [];

  bool isCheckFile = false;
  String root;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getContractCreate();
  }

  _getContractCreate() async {
    if (isNullOrEmpty(root)) root = await SharedPreferencesClass.getRoot();
    CreateContractRequest request = CreateContractRequest();
    if (widget.isCreate) {
      request.iDProjectPlan = widget.iDProjectPlan;
      await _repository.getContractCreate(request);
    } else {
      title = 'Chỉnh sửa hợp đồng';
      request.iDContract = widget.iDProjectPlan;
      await _repository.getContractUpdate(request);
    }
    contract = _repository.dataCreateContract?.contract;
    // khách hàng
    listCustomers = _repository.dataCreateContract?.customers;
    if (isNotNullOrEmpty(listCustomers))
      customer = _getListSeller(listCustomers, contract?.iDCustomer ?? 0);
    // Cơ hội
    listProjectPlans = _repository.dataCreateContract?.projectPlans;
    if (isNotNullOrEmpty(listCustomers))
      projectPlan =
          _getListTypeProjects(listProjectPlans, contract?.iDProjectPlan ?? 0);
    // mã hợp đồng
    codePrefixController.text = contract?.codePrefix;
    //tên hợp đồng
    nameContractController.text = contract?.name;
    //Loại hợp đồng
    listTypeProjects = _repository.dataCreateContract?.projectTypes;
    if (isNotNullOrEmpty(listTypeProjects))
      typeProject =
          _getListTypeProjects(listTypeProjects, contract?.iDTypeProject ?? 0);
    // ngày hiệu lực hợp đồng
    dateEffectContract =
        '${convertTimeStampToHumanDate(contract?.startDate, Constant.ddMMyyyy2)}';
    // ngày kết thúc
    endDate =
        '${convertTimeStampToHumanDate(contract?.endDate, Constant.ddMMyyyy2)}';
    // Địa điểm triển khai
    listProvinces = _repository.dataCreateContract?.provinces;
    if (isNotNullOrEmpty(listTypeProjects))
      provinces =
          _getListTypeProjects(listProvinces, contract?.iDProvince ?? 0);
    // Giai đoạn hợp đồng
    listStatuses = _repository.dataCreateContract?.statuses;
    if (isNotNullOrEmpty(listStatuses))
      statuses = _getListTypeProjects(listStatuses, contract?.status ?? 0);
    // AM (Sale)
    listSeller = _repository.dataCreateContract?.sellers;
    isPermissionSeller = _repository.dataCreateContract?.isSelectSeller;
    if (isNotNullOrEmpty(listSeller))
      seller = _getListSeller(listSeller, contract?.iDSeller ?? 0);
    // Phòng ban phụ trách
    listCenters = _repository.dataCreateContract?.centers;
    if (isNotNullOrEmpty(listCenters))
      centers = _getListTypeProjects(listCenters, contract?.iDCenter ?? 0);
    // Loại hình hợp đồng
    listTypeContract = _repository.dataCreateContract?.types;
    if (isNotNullOrEmpty(listTypeContract))
      typeContract =
          _getListTypeProjects(listTypeContract, contract?.type ?? 0);
    if (typeContract.iD == 2) isShowViewValue = false;
    // giá trị
    valueContractController.text =
        getCurrencyFormat(contract?.totalMoney.toString());
    // giá vốn
    capitalContractController.text =
        getCurrencyFormat(contract?.capital.toString());
    // lãi gộp
    grossProfitContractController.text =
        getCurrencyFormat(contract?.grossProfit.toString());
    // Chi phí marketing (%)
    costMarketingController.text =
        contract?.marketingCost.toString().replaceAll('.0', '');
    // Chi phí triển khai
    costDeploymentController.text =
        getCurrencyFormat(contract?.deployCost.toString());
    //thưởng
    bonusController.text = contract?.bonus.toString().replaceAll('.0', '');
    // tiêu chí thưởng
    listBonusType = _repository.dataCreateContract?.bonusTypes;
    if (isNotNullOrEmpty(listBonusType))
      bonusType = _getListTypeProjects(listBonusType, contract?.bonusType ?? 0);
    // file đính kèm
    listAttachments = contract?.attachments;
    listAttachmentsDeploy = contract?.attachmentsDeploy ?? [];
    // Thêm mới giai đoạn
    listPayments = contract?.payments;
    //doanh thu xuất hóa đơn
    revenueController.text =
        getCurrencyFormat(contract?.invoiceMoney.toString());

    // dành cho edit
    codeContractController.text = contract?.code; // mã hợp đồng
    numberContractController.text = contract?.number; // số hợp đồng
    dateSignContract =
        '${convertTimeStampToHumanDate(contract?.signDate, Constant.ddMMyyyy2)}'; // ngày ký
    absoluteValueContractController.text = getCurrencyFormat(
        contract?.absoluteValue.toString()); // giá trị tuyệt đối
    if (listAttachments.length > 0) isCheckFile = true;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, CreateContractRepository __repository1, child) {
          return Scaffold(
            appBar: AppBar(
              leading: BackIconButton(),
              title: Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: SafeArea(
              child: Container(
                width: double.infinity,
                height: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                color: Colors.white,
                child: ListView(
                  children: [
                    // Nhóm khách hàng
                    TagLayoutWidget(
                      isShowValidate: true,
                      icon: Icons.arrow_drop_down,
                      horizontalPadding: 0,
                      title: "Khách hàng",
                      value: customer?.name ?? '',
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        _eventCallBackCustomers();
                      },
                    ),
                    // Cơ hội
                    TagLayoutWidget(
                      icon: Icons.arrow_drop_down,
                      horizontalPadding: 0,
                      title: "Cơ hội",
                      value: projectPlan?.name ?? '',
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        _eventCallBackPhases();
                      },
                    ),
                    // Mã hợp đồng
                    Row(
                      children: [
                        Expanded(
                          child: TextFieldValidate(
                            padding: EdgeInsets.only(top: 8),
                            title: 'Mã hợp đồng',
                            isShowValidate: true,
                            isEnabled: false,
                            controller: codePrefixController,
                          ),
                        ),
                        Expanded(
                          child: TextFieldValidate(
                            padding: EdgeInsets.only(top: 8),
                            title: '',
                            hint: 'Mã hợp đồng',
                            controller: codeContractController,
                          ),
                        ),
                      ],
                    ),
                    // Số hợp đồng
                    TextFieldValidate(
                      padding: EdgeInsets.only(top: 8),
                      title: 'Số hợp đồng',
                      isShowValidate: true,
                      controller: numberContractController,
                    ),
                    // Tên hợp đồng
                    TextFieldValidate(
                      padding: EdgeInsets.only(top: 8),
                      title: 'Tên hợp đồng',
                      isShowValidate: true,
                      controller: nameContractController,
                    ),
                    // Loại hợp đồng
                    TagLayoutWidget(
                      icon: Icons.arrow_drop_down,
                      horizontalPadding: 0,
                      title: "Loại hợp đồng",
                      value: typeProject?.name ?? "",
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        _eventCallBackTypeProject();
                      },
                    ),
                    // Ngày ký
                    TagLayoutWidget(
                      isShowValidate: true,
                      icon: Icons.date_range,
                      horizontalPadding: 0,
                      title: "Ngày ký",
                      value: dateSignContract ?? '',
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        DateTimePickerWidget(
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
                    // Ngày hiệu lực hợp đồng
                    TagLayoutWidget(
                      icon: Icons.date_range,
                      horizontalPadding: 0,
                      isShowValidate: true,
                      title: "Ngày hiệu lực hợp đồng",
                      value: dateEffectContract ?? '',
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        DateTimePickerWidget(
                            format: Constant.ddMMyyyy2,
                            context: context,
                            onDateTimeSelected: (valueDate) {
                              setState(() {
                                dateEffectContract = valueDate;
                              });
                              // print(valueDate);
                            }).showOnlyDatePicker();
                      },
                    ),
                    // Ngày kết thúc
                    TagLayoutWidget(
                      isShowValidate: true,
                      icon: Icons.date_range,
                      horizontalPadding: 0,
                      title: "Ngày kết thúc",
                      value: endDate ?? '',
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        DateTimePickerWidget(
                            format: Constant.ddMMyyyy2,
                            context: context,
                            onDateTimeSelected: (valueDate) {
                              setState(() {
                                endDate = valueDate;
                              });
                              // print(valueDate);
                            }).showOnlyDatePicker();
                      },
                    ),
                    // Địa điểm triển khai
                    TagLayoutWidget(
                      isShowValidate: true,
                      icon: Icons.arrow_drop_down,
                      horizontalPadding: 0,
                      title: "Địa điểm triển khai",
                      value: provinces?.name ?? '',
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        _eventCallBackProvinces();
                      },
                    ),
                    // Giai đoạn hợp đồng
                    TagLayoutWidget(
                      isShowValidate: true,
                      icon: Icons.arrow_drop_down,
                      horizontalPadding: 0,
                      title: "Giai đoạn hợp đồng",
                      value: statuses?.name ?? "",
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        _eventCallBackStatus();
                      },
                    ),
                    // AM (Sale)
                    TagLayoutWidget(
                      isShowValidate: true,
                      icon: Icons.arrow_drop_down,
                      horizontalPadding: 0,
                      title: "AM (Sale)",
                      value: seller?.name ?? '',
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        _eventCallBackSeller();
                      },
                    ),
                    // Phòng ban phụ trách
                    TagLayoutWidget(
                      isShowValidate: true,
                      icon: Icons.arrow_drop_down,
                      horizontalPadding: 0,
                      title: "Phòng ban phụ trách",
                      value: centers?.name ?? '',
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        _eventCallBackCenter();
                      },
                    ),
                    // Loại hình hợp đồng
                    TagLayoutWidget(
                      isShowValidate: true,
                      icon: Icons.arrow_drop_down,
                      horizontalPadding: 0,
                      title: "Loại hình hợp đồng",
                      value: typeContract?.name ?? '',
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        _eventCallBackTypeContract();
                      },
                    ),
                    // Giá trị tuyệt đối
                    Visibility(
                      visible: !isShowViewValue,
                      child: TextFieldValidate(
                        keyboardType: TextInputType.number,
                        padding: EdgeInsets.only(top: 8),
                        title: 'Giá trị tuyệt đối',
                        isShowValidate: true,
                        controller: absoluteValueContractController,
                        onChange: () {
                          absoluteValueContractController.text =
                              getCurrencyFormat(
                                  absoluteValueContractController.text);
                          absoluteValueContractController.selection =
                              TextSelection.collapsed(
                                  offset: absoluteValueContractController
                                      .text.length);
                        },
                      ),
                    ),
                    // Doanh thu xuất hóa đơn
                    TextFieldValidate(
                      keyboardType: TextInputType.number,
                      padding: EdgeInsets.only(top: 8),
                      title: 'Doanh thu xuất hóa đơn',
                      controller: revenueController,
                      onChange: () {
                        revenueController.text =
                            getCurrencyFormat(revenueController.text);
                        revenueController.selection = TextSelection.collapsed(
                            offset: revenueController.text.length);
                      },
                    ),
                    // Giá trị
                    TextFieldValidate(
                      keyboardType: TextInputType.number,
                      padding: EdgeInsets.only(top: 8),
                      title: 'Giá trị',
                      isShowValidate: true,
                      controller: valueContractController,
                      onChange: () {
                        setState(() {
                          _getSubtractionValue();
                        });
                        valueContractController.selection =
                            TextSelection.collapsed(
                                offset: valueContractController.text.length);
                      },
                    ),
                    // Giá vốn
                    TextFieldValidate(
                      keyboardType: TextInputType.number,
                      padding: EdgeInsets.only(top: 8),
                      title: 'Giá vốn',
                      controller: capitalContractController,
                      onChange: () {
                        setState(() {
                          _getSubtractionValue();
                        });
                        capitalContractController.selection =
                            TextSelection.collapsed(
                                offset: capitalContractController.text.length);
                      },
                    ),
                    // Lãi gộp
                    TextFieldValidate(
                      keyboardType: TextInputType.number,
                      padding: EdgeInsets.only(top: 8),
                      title: 'Lãi gộp',
                      controller: grossProfitContractController,
                      isEnabled: false,
                    ),
                    // Chi phí marketing
                    TextFieldValidate(
                      inputFormatters:
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      padding: EdgeInsets.only(top: 8),
                      title: 'Chi phí marketing (%)',
                      controller: costMarketingController,
                      maxLength: 6,
                      onChange: () {
                        costMarketingController =
                            getDataPercentController(costMarketingController);
                      },
                    ),
                    // Chi phí triển khai
                    TextFieldValidate(
                      keyboardType: TextInputType.number,
                      padding: EdgeInsets.only(top: 8),
                      title: 'Chi phí triển khai',
                      controller: costDeploymentController,
                      onChange: () {
                        setState(() {
                          costDeploymentController.text =
                              getCurrencyFormat(costDeploymentController.text);
                        });
                        costDeploymentController.selection =
                            TextSelection.collapsed(
                                offset: costDeploymentController.text.length);
                      },
                    ),
                    // Thưởng (%)
                    TextFieldValidate(
                      inputFormatters:
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      maxLength: 4,
                      padding: EdgeInsets.only(top: 8),
                      title: 'Thưởng (%)',
                      controller: bonusController,
                      onChange: () {
                        bonusController =
                            getDataPercentController(bonusController);
                      },
                    ),
                    // Tiêu chí thưởng
                    TagLayoutWidget(
                      isShowValidate: true,
                      icon: Icons.arrow_drop_down,
                      horizontalPadding: 0,
                      title: "Tiêu chí thưởng",
                      value: bonusType?.name ?? '',
                      openFilterListener: () {
                        FocusScope.of(context).unfocus();
                        _eventCallBackBonusType();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            'Có file hợp đồng đính kèm?',
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isCheckFile = !isCheckFile;
                              });
                            },
                            icon: Icon(
                              isCheckFile
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: isCheckFile ? Colors.blue : Colors.grey,
                              size: 24,
                            ),
                          )
                        ],
                      ),
                    ),
                    DividerWidget(
                      iHeight: 1,
                    ),
                    // tải file lên
                    _listFileContract(true, listAttachments),
                    Visibility(
                      visible: isCheckFile,
                      child: DividerWidget(
                        iHeight: 1,
                      ),
                    ),
                    _listFileContract(false, listAttachmentsDeploy),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 16),
                      child: RichText(
                        text: TextSpan(
                          text: 'Các giai đoạn thanh toán ',
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          children: <TextSpan>[
                            TextSpan(
                                text: '*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ),
                    DividerWidget(
                      iHeight: 1,
                    ),
                    // Các giai đoạn thanh toán
                    InkWell(
                      onTap: () {
                        _showBottomSheetCreatePhase(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16, bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.subject_outlined,
                              color: Colors.blue,
                              size: 16,
                            ),
                            Text(
                              'Thêm mới giai đoạn',
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                  color: Colors.blue,
                                  fontSize: 14,
                                  height: 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    DividerWidget(
                      iHeight: 1,
                    ),
                    // danh sách giai đoạn thanh toán
                    ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: listPayments?.length ?? 0,
                      itemBuilder: (context, index) {
                        Payments item = listPayments[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item?.name ?? '',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Loại giai đoạn: ${item?.typeName}',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Tỉ lệ: ${item?.ratio}%',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Quyết định: ${item?.rules}',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Ngày thanh toán: ${convertTimeStampToHumanDate(item.paymentDate, Constant.ddMMyyyy2)}',
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Số ngày báo trước: ${item?.remindDay}',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  _eventCallApiDeletePhase(item);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                  size: 24,
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
                    SaveButton(
                      // margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      onTap: () {
                        _eventClickDone();
                      },
                      title: 'Xong',
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // danh sách file
  // isFile true: hợp đồng gốc - false: hợp đồng triển khai
  Widget _listFileContract(bool isFile, List<Attachments> listData) {
    return Visibility(
      visible: isCheckFile,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              await _repository.eventCallBackAddFile(context, isFile);
              if (isFile)
                listAttachments = contract?.attachments;
              else
                listAttachmentsDeploy = contract?.attachmentsDeploy ?? [];
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.attach_file_outlined,
                    color: Colors.blue,
                    size: 16,
                  ),
                  Text(
                    isFile ? ' Hợp đồng gốc ' : ' Hợp đồng triển khai ',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    isFile ? '*' : '',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          DividerWidget(
            iHeight: 1,
          ),
          // danh sách file tải lên
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              primary: false,
              shrinkWrap: true,
              itemCount: listData?.length ?? 0,
              itemBuilder: (context, index) {
                Attachments item = listData[index];
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        item?.fileName ?? '',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _repository.eventCallApiDeleteFile(
                            item, context, isFile);
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
            ),
          ),
        ],
      ),
    );
  }

  // khách hàng
  _eventCallBackCustomers() {
    if (!isPermissionCustomer) {
      ToastMessage.show(
          "Tài khoản này không có quyền chọn khách hàng!", ToastStyle.warning);
      return;
    }
    if (isNullOrEmpty(listCustomers)) {
      ToastMessage.show("Không có dữ liệu về Khách hàng!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        CustomersCreateScreen(
          listCustomers,
          customer?.iD ?? 0,
          'Chọn khách hàng',
          root,
          onSeller: (_seller) {
            setState(() {
              customer = _seller;
            });
          },
        ));
  }

  // Cơ hội
  _eventCallBackPhases() {
    if (!isPermissionProjectPlan) {
      ToastMessage.show(
          "Tài khoản của bạn không có quyền chọn Cơ hội!", ToastStyle.warning);
      return;
    }

    if (isNullOrEmpty(listProjectPlans)) {
      ToastMessage.show("Không có dữ liệu về Cơ hội!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listProjectPlans,
          projectPlan?.iD ?? 0,
          'Chọn cơ hội',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              projectPlan = _groupCustomers;
            });
          },
        ));
  }

  // loại hợp đồng
  _eventCallBackTypeProject() {
    if (isNullOrEmpty(listTypeProjects)) {
      ToastMessage.show("Không có dữ liệu về Loại hợp đồng!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listTypeProjects,
          typeProject?.iD ?? 0,
          'Chọn loại hợp đồng',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              typeProject = _groupCustomers;
            });
          },
        ));
  }

  // Địa điểm triển khai
  _eventCallBackProvinces() {
    if (isNullOrEmpty(listProvinces)) {
      ToastMessage.show(
          "Không có dữ liệu về Địa điểm triển khai!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listProvinces,
          provinces?.iD ?? 0,
          'Chọn địa điểm triển khai',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              provinces = _groupCustomers;
            });
          },
        ));
  }

  // Giai đoạn hợp đồng
  _eventCallBackStatus() {
    if (isNullOrEmpty(listStatuses)) {
      ToastMessage.show(
          "Không có dữ liệu về Giai đoạn hợp đồng!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listStatuses,
          statuses?.iD ?? 0,
          'Chọn giai đoạn hợp đồng',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              statuses = _groupCustomers;
            });
          },
        ));
  }

  // AM (Sale)
  _eventCallBackSeller() {
    if (!isPermissionSeller) {
      ToastMessage.show(
          "Tài khoản này không có quyền chọn AM (Sale)!", ToastStyle.warning);
      return;
    }
    if (isNullOrEmpty(listSeller)) {
      ToastMessage.show("Không có dữ liệu về AM (Sale)!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        CustomersCreateScreen(
          listSeller,
          seller?.iD ?? 0,
          'Chọn AM (Sale)',
          root,
          onSeller: (_seller) {
            setState(() {
              seller = _seller;
            });
          },
        ));
  }

  // Phòng ban phụ trách
  _eventCallBackCenter() {
    if (isNullOrEmpty(listCenters)) {
      ToastMessage.show(
          "Không có dữ liệu về Phòng ban phụ trách!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listCenters,
          centers?.iD ?? 0,
          'Chọn phòng ban phụ trách',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              centers = _groupCustomers;
            });
          },
        ));
  }

  // Loại hình hợp đồng
  _eventCallBackTypeContract() {
    if (isNullOrEmpty(listTypeContract)) {
      ToastMessage.show(
          "Không có dữ liệu về Loại hình hợp đồng!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listTypeContract,
          typeContract?.iD ?? 0,
          'Chọn loại hình hợp đồng',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              typeContract = _groupCustomers;
              absoluteValueContractController.text = '';
              if (typeContract.iD == 2) {
                isShowViewValue = false;
              }
            });
          },
        ));
  }

  // Tiêu chí thưởng
  _eventCallBackBonusType() {
    if (isNullOrEmpty(listBonusType)) {
      ToastMessage.show(
          "Không có dữ liệu về Tiêu chí thưởng!", ToastStyle.error);
      return;
    }

    pushPage(
        context,
        GroupCustomersCreateScreen(
          listBonusType,
          bonusType?.iD ?? 0,
          'Chọn tiêu chí thưởng',
          onGroupCustomers: (_groupCustomers) {
            setState(() {
              bonusType = _groupCustomers;
            });
          },
        ));
  }

  // xóa thêm mới giai đoạn
  _eventCallApiDeletePhase(Payments item) {
    ConfirmDialogFunction(
        content: 'Bạn có muốn xóa giai đoạn này không?',
        context: context,
        onAccept: () {
          setState(() {
            listPayments.remove(item);
          });
        }).showConfirmDialog();
  }

  // tạo mới giai đoạn thanh toán
  _showBottomSheetCreatePhase(BuildContext context) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Wrap(
            children: [
              BottomSheetCreatePhaseScreen(
                type: BottomSheetCreatePhaseScreen.TYPE_CRETAE_OPPOTUNITY,
                listData: _repository.dataCreateContract?.paymentTypes,
                onPaymentsCreate: (data) {
                  setState(() {
                    listPayments?.add(data);
                  });
                },
              ),
            ],
          );
        });
  }

  _eventClickDone() async {
    if (isNullOrEmpty(customer?.iD)) {
      ToastMessage.show("Khách hàng$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(codeContractController.text)) {
      ToastMessage.show("Mã hợp đồng$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(numberContractController.text)) {
      ToastMessage.show("Số hợp đồng$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(nameContractController.text)) {
      ToastMessage.show("Tên hợp đồng$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(typeProject?.iD)) {
      ToastMessage.show("Loại hợp đồng$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(dateSignContract)) {
      ToastMessage.show("Ngày ký$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(dateEffectContract)) {
      ToastMessage.show(
          "Ngày hiệu lực hợp đồng$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(endDate)) {
      ToastMessage.show("Ngày kết thúc$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(provinces?.iD)) {
      ToastMessage.show(
          "Địa điểm triển khai$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(statuses?.iD)) {
      ToastMessage.show(
          "Giai đoạn hợp đồng$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(seller?.iD)) {
      ToastMessage.show("AM (Sale)$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(centers?.iD)) {
      ToastMessage.show(
          "Phòng ban phụ trách$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(valueContractController.text)) {
      ToastMessage.show("Giá trị$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(listPayments)) {
      ToastMessage.show(
          "Giai đoạn thanh toán$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isNullOrEmpty(typeContract?.iD)) {
      ToastMessage.show(
          "Loại hình hợp đồng$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (typeContract?.iD == 2 &&
        isNullOrEmpty(absoluteValueContractController.text)) {
      ToastMessage.show("Giá trị tuyệt đối$textNotLeftBlank", ToastStyle.error);
      return;
    }
    if (isCheckFile && isNullOrEmpty(listAttachments)) {
      ToastMessage.show("Hợp đồng gốc$textNotLeftBlank", ToastStyle.error);
      return;
    }

    SaveContractRequest request = SaveContractRequest();
    // params.put("IDCustomer", idSelectCustomer + ""); // khách hàng
    request.iDCustomer = customer?.iD;
    // params.put("IDProjectPlan", idSelectProjectPlan + ""); // cơ hội
    request.iDProjectPlan = projectPlan?.iD;
    // params.put("Code", codeContract); // mã hđ
    request.code = codeContractController.text;
    // params.put("Number", numberContract); // số hđ
    request.number = numberContractController.text;
    // params.put("Name", nameContract); // tên hợp đồng
    request.name = nameContractController.text;
    // params.put("IDTypeProject", idSelectProjectType + ""); // loại hợp đồng
    request.iDTypeProject = typeProject?.iD;
    // params.put("SignDate", signDate); // ngày ký hđ
    request.signDate = dateSignContract;
    // params.put("StartDate", startDate); // ngày hiệu lực hđ
    request.startDate = dateEffectContract;
    // params.put("EndDate", endDate); // ngày kt hợp đồng
    request.endDate = endDate;
    // params.put("IDProvince", idSelectProvince + ""); //địa điểm triển khai
    request.iDProvince = provinces?.iD;
    // params.put("Status", idSelectStatus + ""); //giai đoạn hợp đồng
    request.status = statuses?.iD;
    // params.put("IDSeller", idSelectSeller + ""); //Seller
    request.iDSeller = seller?.iD;
    // params.put("IDCenter", idSelectCenter + ""); //phòng ban
    request.iDCenter = centers?.iD;
    // params.put("TotalMoney", value); //giá trị
    request.totalMoney = valueContractController.text;
    // params.put("Capital", costCapital);  //lãi vốn
    request.capital = capitalContractController.text;
    // params.put("MarketingCost", mktCost); //chi phí mkt
    request.marketingCost = costMarketingController.text.replaceAll(',', '');
    // params.put("DeployCost", deployCost); //chi phí triển khai
    request.deployCost = costDeploymentController.text;
    // params.put("Bonus", bonus + "");
    request.bonus = bonusController.text;
    // params.put("BonusType", idSelectBonusType + "");
    request.bonusType = bonusType?.iD;
    // params.put("Type", idTypeOfContract + "");
    request.type = typeContract?.iD;
    // giá trị tuyệt đối
    request.absoluteValue = absoluteValueContractController.text;

    // Doanh thu xuất hóa đơn
    request.invoiceMoney = revenueController.text.replaceAll(',', '');

    if (isNotNullOrEmpty(listAttachments)) {
      request.hasFiles = 1;
      String fileName =
          listAttachments.map((e) => "\"${e.fileName}\"").toList().toString();
      String filePath =
          listAttachments.map((e) => "\"${e.filePath}\"").toList().toString();
      request.contractFileNames = fileName; // file name hợp đồng gốc
      request.contractFilePaths = filePath; // file path hợp đồng gốc
    }

    if (isNotNullOrEmpty(listAttachmentsDeploy)) {
      request.hasFiles = 1;
      String fileName = listAttachmentsDeploy
          .map((e) => "\"${e.fileName}\"")
          .toList()
          .toString();
      String filePath = listAttachmentsDeploy
          .map((e) => "\"${e.filePath}\"")
          .toList()
          .toString();
      // file name hợp đồng triển khai
      request.deployContractFileNames = fileName;
      // file path hợp đồng triển khai
      request.deployContractFilePaths = filePath;
    }

    // danh sách giai đoạn
    if (isNotNullOrEmpty(listPayments)) {
      String namePayment =
          listPayments.map((e) => "\"${e.name}\"").toList().toString();
      String ratioPayment =
          listPayments.map((e) => "\"${e.ratio}\"").toList().toString();
      String rulePayment =
          listPayments.map((e) => "\"${e.rules}\"").toList().toString();
      String datePayment = listPayments
          .map((e) =>
              "\"${convertTimeStampToHumanDate(e.paymentDate, Constant.ddMMyyyy2)}\"")
          .toList()
          .toString();
      String remindDay =
          listPayments.map((e) => "\"${e.remindDay}\"").toList().toString();
      String typePayment =
          listPayments.map((e) => "\"${e.type}\"").toList().toString();
      if (!widget.isCreate) {
        // chỉnh sửa
        String idPayment =
            listPayments.map((e) => "\"${e?.iD ?? 0}\"").toList().toString();
        request.payment_ID = idPayment; // id giai đoạn

        String statusPayment = listPayments
            .map((e) => "\"${e?.status?.iD ?? 0}\"")
            .toList()
            .toString();
        request.payment_Status = statusPayment; // id giai đoạn
      }

      request.payment_Name = namePayment; // tên giai đoạn
      request.payment_Ratio = ratioPayment; // tỉ lệ
      request.payment_Rules = rulePayment; // Quyết định
      request.payment_Date = datePayment; // ngày thanh toán
      request.payment_RemindDay = remindDay; // Ngày nhắc trước
      request.payment_Type = typePayment; // Loại thanh toán
    }

    if (!widget.isCreate) // chỉnh sửa
      request.id = widget.iDProjectPlan;

    bool status = await _repository.getContractSave(request, widget.isCreate);
    if (status != null) {
      Navigator.pop(context);
    }
  }

  _getSubtractionValue() {
    int sum = 0;
    if (capitalContractController.text.length == 0)
      sum = int.parse(valueContractController.text.replaceAll(',', ''));
    else
      sum = int.parse(valueContractController.text.replaceAll(',', '')) -
          int.parse(capitalContractController.text.replaceAll(',', ''));
    grossProfitContractController.text = getCurrencyFormat(sum.toString());
    valueContractController.text =
        getCurrencyFormat(valueContractController.text);
    capitalContractController.text =
        getCurrencyFormat(capitalContractController.text);
  }

  Seller _getListSeller(List<Seller> _listSeller, int _seller) {
    return _listSeller?.firstWhere(
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
}

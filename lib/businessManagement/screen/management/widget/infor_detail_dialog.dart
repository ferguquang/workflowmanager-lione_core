import 'package:flutter/material.dart';
import 'package:workflow_manager/businessManagement/model/response/create_management_response.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/row_and_two_text.dart';

class InforDetailDialog extends StatefulWidget {
  ProjectDetailModel projectDetailModel;
  bool isOnlyView;

  InforDetailDialog({this.projectDetailModel, this.isOnlyView});

  @override
  _InforDetailDialogState createState() => _InforDetailDialogState();
}

class _InforDetailDialogState extends State<InforDetailDialog> {
  List<DataFields> fieldList = [];
  String executeDuration = '';
  bool isExecuteDuration = false;
  String tendererDate = '';
  bool isTendererDate = false;
  String demoDate = '';
  bool isDemoDate = false;
  String deployDate = '';
  bool isDeployDate = false;
  String investors = '';
  bool isInvestors = false;
  String detailAmount = '';
  bool isDetailAmount = false;
  String profileType = '';
  bool isProfileType = false;
  String advanceTerms = '';
  bool isAdvanceTerms = false;
  String paymentTerms = '';
  bool isPaymentTerms = false;
  String province = '';
  bool isProvince = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // if (widget.isOnlyView) {
    //   // khachs
    //   executeDuration = widget.projectDetailModel?.executeDurationString ?? '';
    //   tendererDate = widget.projectDetailModel?.tendererDateString ?? '';
    //   demoDate = widget.projectDetailModel?.demoDateString ?? '';
    //   deployDate = widget.projectDetailModel?.deployDateString ?? '';
    //   investors = widget.projectDetailModel?.investors ?? '';
    //   detailAmount = widget.projectDetailModel?.detailAmount ?? '';
    //   profileType = widget.projectDetailModel?.profileType ?? '';
    //   advanceTerms = widget.projectDetailModel?.advanceTerms ?? '';
    //   paymentTerms = widget.projectDetailModel?.paymentTerms ?? '';
    // } else {
    // admin
    fieldList = widget.projectDetailModel?.dataFields;
    for (int i = 0; i < fieldList.length; i++) {
      switch (_getName(i)) {
        case "ExecuteDuration": // Thời gian thực hiện hợp đồng
          executeDuration = _getValue(i) + " (Ngày)";
          isExecuteDuration = _getIsTemp(i);
          break;
        case "TendererDate": // Ngày chuẩn bị HSMT thầu/ mở thầu
          tendererDate = _getValue(i);
          isTendererDate = _getIsTemp(i);
          break;
        case "DemoDate": // Ngày triển khảo sát, tư vấn, demo
          demoDate = _getValue(i);
          isDemoDate = _getIsTemp(i);
          break;
        case "DeployDate": // Ngày dự kiến triển khai
          deployDate = _getValue(i);
          isDeployDate = _getIsTemp(i);
          break;
        case "Investors": // Đơn vị sử dụng
          investors = _getValue(i);
          isInvestors = _getIsTemp(i);
          break;
        case "DetailAmount": // Khối lượng chi tiết
          detailAmount = _getValue(i);
          isDetailAmount = _getIsTemp(i);
          break;
        case "ProfileType": // Loại hồ sơ
          profileType = _getValue(i);
          isProfileType = _getIsTemp(i);
          break;
        case "AdvanceTerms": // Điều khoản tạm ứng
          advanceTerms = _getValue(i);
          isAdvanceTerms = _getIsTemp(i);
          break;
        case "PaymentTerms": // Điều khoản thanh toán
          paymentTerms = _getValue(i);
          isPaymentTerms = _getIsTemp(i);
          break;
        case "Province": // Địa điểm triển khai
          province = _getValue(i);
          isProvince = _getIsTemp(i);
          break;
      }
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
              color: Colors.blue,
            ),
            alignment: Alignment.center,
            child: Text(
              'Thông tin giá trị mới',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          RowAndTwoText(
            icon: Icons.airline_seat_individual_suite,
            textTitle: 'Đơn vị sử dụng',
            textValue: investors,
            isColors: isInvestors,
          ),
          RowAndTwoText(
            icon: Icons.access_time,
            textTitle: 'Thời gian thực hiện hợp đồng',
            textValue: executeDuration,
            isColors: isExecuteDuration,
          ),
          RowAndTwoText(
            icon: Icons.calendar_today_outlined,
            textTitle: 'Ngày chuẩn bị HSMT thầu/ mở thầu',
            textValue: tendererDate,
            isColors: isTendererDate,
          ),
          RowAndTwoText(
            icon: Icons.calendar_today_outlined,
            textTitle: 'Ngày dự kiến tư vấn, khảo sát, demo',
            textValue: demoDate,
            isColors: isDemoDate,
          ),
          RowAndTwoText(
            icon: Icons.calendar_today_outlined,
            textTitle: 'Ngày dự kiến triển khai',
            textValue: deployDate,
            isColors: isDeployDate,
          ),
          RowAndTwoText(
            icon: Icons.widgets,
            textTitle: 'Khối lượng chi tiết',
            textValue: detailAmount,
            isColors: isDetailAmount,
          ),
          RowAndTwoText(
            icon: Icons.assignment_rounded,
            textTitle: 'Loại hồ sơ',
            textValue: profileType,
            isColors: isProfileType,
          ),
          RowAndTwoText(
            icon: Icons.calendar_view_day_sharp,
            textTitle: 'Điều khoản tạm ứng',
            textValue: advanceTerms,
            isColors: isAdvanceTerms,
          ),
          RowAndTwoText(
            icon: Icons.calendar_view_day_sharp,
            textTitle: 'Điều khoản thanh toán',
            textValue: paymentTerms,
            isColors: isPaymentTerms,
          ),
          RowAndTwoText(
            icon: Icons.account_balance_sharp,
            textTitle: 'Địa điểm triển khai',
            textValue: province,
            isColors: isProvince,
          ),
          const Padding(
            padding: EdgeInsets.all(4),
          )
        ],
      ),
    );
  }

  String _getName(int index) {
    return fieldList[index].name ?? '';
  }

  String _getValue(int index) {
    return fieldList[index].value ?? '';
  }

  bool _getIsTemp(int index) {
    return fieldList[index].isTemp ?? '';
  }
}

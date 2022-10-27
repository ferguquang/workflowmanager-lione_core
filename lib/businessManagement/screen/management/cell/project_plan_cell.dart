import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/response/project_plan_index_response.dart';
import 'package:workflow_manager/businessManagement/screen/management/widget/management_bottom_action_widget.dart';

class ProjectPlanCell extends StatefulWidget {
  ProjectPlanItem item = new ProjectPlanItem();
  bool isOnlyView;

  ProjectPlanCell({this.item, this.isOnlyView});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProjectPlanCell();
  }
}

class _ProjectPlanCell extends State<ProjectPlanCell> {
  String avtUrl = "";

  setAvtSeller() async {
    String root =
        await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
    setState(() {
      this.avtUrl = "${root}${this.widget.item.seller.avatar}";
      // print('ggggggggggggggggggggg- $avtUrl');
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setAvtSeller();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildNamePlanWidget(this.widget.item?.name ?? ''),
                _buildStatusWidget(this.widget.item?.status ?? ''),
                _buildTotalMoneyWidget(this.widget.item?.totalMoney ?? ''),
                _buildPhaseWidget(),
                _buildUpdateTimeWidget(
                    updateTime: this.widget.item?.updated,
                    quater: this.widget.item?.quater),
                _buildCustomerWidget(
                    customerName: this.widget.item?.customer?.name ?? ''),
                _buildCustomerAvatar(),
                _buildWarningWidget(),
              ],
            ),
          ),
          Visibility(
            visible: !widget.isOnlyView ?? false,
            child: IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              onPressed: () {
                ManagementBottomAction(context: this.context, item: widget.item)
                    .showBottomSheetDialog();
                // pushPage(
                //     context,
                //     CreateManagementScreen(
                //       idOpportunity: widget.item?.iD ?? 0,
                //       typeOpportunity: CreateManagementScreen.TYPE_EDIT,
                //     ));
                // pushPage(
                //     context,
                //     CreateManagementScreen(
                //       typeOpportunity: CreateManagementScreen.TYPE_CREATE,
                //       // idOpportunity: 1195,
                //     )),
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildNamePlanWidget(String name) {
    return Text(
      name,
      textAlign: TextAlign.left,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
    );
  }

  Widget _buildStatusWidget(StatusPlan status) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      child: Container(
        padding: EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
        decoration: new BoxDecoration(
            color: getColor(status.color ?? "#ffffff"),
            borderRadius: new BorderRadius.all(const Radius.circular(12))),
        child: Text(
          status.name,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTotalMoneyWidget(String totalMoney) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.info_outline,
            size: 16,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(right: 4),
          ),
          Expanded(
            child: Text("Giá trị hợp đồng dự kiến: ${totalMoney}"),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateTimeWidget(
      {@required int updateTime, @required int quater}) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.access_time_outlined,
            size: 16,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(right: 4),
          ),
          Text(
              "Ngày cập nhật: ${convertTimeStampToHumanDate(updateTime, Constant.ddMMyyyy2)} (Quý ${quater ?? ''})")
        ],
      ),
    );
  }

  Widget _buildCustomerWidget({@required String customerName}) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.person,
            size: 16,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(right: 4),
          ),
          Text("Khách hàng: "),
          Expanded(
            child: Text(
              customerName,
              style: TextStyle(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerAvatar() {
    return Container(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.account_circle_outlined,
            size: 16,
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(right: 4),
          ),
          Text("Seller: "),
          CircleNetworkImage(height: 22, width: 22, url: this.avtUrl ?? '')
          // CachedNetworkImage(
          //   imageUrl: this.avtUrl,
          //   imageBuilder: (context, imageProvider) {
          //     return Container(
          //       height: 22,
          //       width: 22,
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         image:
          //             DecorationImage(image: imageProvider, fit: BoxFit.cover),
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildWarningWidget() {
    return Container(
      child: Visibility(
        visible: widget.item.isExpired,
        child: Padding(
          padding: EdgeInsets.only(top: 0),
          child: Text(
            'Quá hạn',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  Widget _buildPhaseWidget() {
    return Visibility(
      visible: widget.item.phase.name != null,
      child: Container(
        padding: EdgeInsets.only(top: 4),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.info_outline,
              size: 16,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.only(right: 4),
            ),
            Expanded(
              child: Text("Giai đoạn: ${widget.item.phase.name}"),
            ),
          ],
        ),
      ),
    );
  }
}

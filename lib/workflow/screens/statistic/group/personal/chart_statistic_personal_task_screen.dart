import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/workflow/screens/statistic/group/personal/repository/chart_statistic_personal_task_repository.dart';
import 'package:workflow_manager/base/ui/chart/gauge_chart_screen.dart';
import 'package:workflow_manager/base/ui/chart/line_chart_screen.dart';
import 'package:workflow_manager/base/ui/chart/pie_chart_screen.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/title_dialog.dart';

class ChartStatisticPersonalTaskScreen extends StatefulWidget {
  int idGroupJob;

  ChartStatisticPersonalTaskScreen({this.idGroupJob});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChartStatisticPersonalTaskScreen();
  }
}

class _ChartStatisticPersonalTaskScreen
    extends State<ChartStatisticPersonalTaskScreen>
    with AutomaticKeepAliveClientMixin {
  ListStatisticPersonalTaskRepository _chartRepository =
      ListStatisticPersonalTaskRepository();

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._chartRepository.getDataGroupJob(this.widget.idGroupJob);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ChangeNotifierProvider.value(
      value: this._chartRepository,
      child: Consumer(
        builder: (context, ListStatisticPersonalTaskRepository repository, _) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // this._buildTopView(),
                    this._buildUserPersonalView(),
                    this._buildRateView(),
                    this._buildStatusChartView(),
                    this._buildAmountChartView(),
                    this._buildPerformanceChartView(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopView() {
    return Container(
      color: "#F5F6FA".toColor(),
      height: 32,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Text(
                'L???c/ T??m ki???m nh??m c??ng vi???c',
                style: TextStyle(fontSize: 14, color: "#555555".toColor()),
              ),
            ),
          ),
          FlatButton(
              onPressed: () {

              },
              child: Icon(Icons.more_vert)),
        ],
      ),
    );
  }

  Widget _buildUserPersonalView() {
    return Container(
      child: Row(
        children: <Widget>[
          Image.asset('assets/images/ic-user.png'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16, top: 16),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text(
                        'T??n nh??n vi??n:',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        this._chartRepository.userPersonal == null ? "" : this._chartRepository.userPersonal.userName,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'B??? ph???n: ',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        this._chartRepository.userPersonal == null ? "" : this._chartRepository.userPersonal.deptName,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Ch???c danh: ',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'M?? nh??n vi??n: ',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "${this._chartRepository.userPersonal == null ? "" : this._chartRepository.userPersonal.iD}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'S??? ??i???n tho???i: ',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        this._chartRepository.userPersonal == null ? "" : this._chartRepository.userPersonal.phoneNumber,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        'Email: ',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        this._chartRepository.userPersonal == null ? "" : this._chartRepository.userPersonal.email,
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateView() {
    return Container(
      padding: EdgeInsets.only(top: 16),
      // height: 100,
      decoration: BoxDecoration(
          // color: Colors.white,
          border:
              Border(bottom: BorderSide(color: "#DDDDDD".toColor(), width: 1))),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, top: 10),
                child: Text(
                  '????nh gi??: '.toUpperCase(),
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  this._chartRepository.performanceRank ?? "",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: "#00689D".toColor()),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                child: FittedBox(
                  child: RatingBar.builder(
                    initialRating: this._chartRepository.rate,
                    itemCount: 5,
                    itemPadding: EdgeInsets.all(0),
                    direction: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Icon(
                        Icons.star,
                        color: Colors.amber,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChartView() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      // height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "Tr???ng th??i nh??m c??ng vi???c".toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          this._chartRepository.pieChart == null ? EmptyScreen() :
          PieChartScreen(
            pieChart: this._chartRepository.pieChart,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountChartView() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "S??? l?????ng c??ng vi???c nh??m".toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
                child: RotatedBox(
                  quarterTurns: -1,
                  child: Text("S??? l?????ng c??ng vi???c"),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return this._chartRepository.listDataChartLine == null ? EmptyScreen() : LineChartScreen(
                        listDataChartLine:
                            this._chartRepository.listDataChartLine,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceChartView() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16, top: 10),
            child: Text(
              "Hi???u su???t nh??m c??ng vi???c".toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          this._chartRepository.performanceJobGroupData == null ? EmptyScreen() :
          GaugeChartScreen(
            performanceJobGroupData:
                this._chartRepository.performanceJobGroupData,
          ),
        ],
      ),
    );
  }

  void _showFilterView() {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return Wrap(
            children: <Widget>[
              TitleDialog("L???c"),
              Container(
                height: 150,
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text("L???a ch???n nh??m c??ng vi???c"),
                        )),
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(Icons.arrow_drop_down),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text("T??? ng??y"),
                        )),
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.date_range,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 16)),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Text("?????n ng??y"),
                        )),
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Icon(
                            Icons.calendar_today,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}

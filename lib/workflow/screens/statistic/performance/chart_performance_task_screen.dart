//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:workflow_manager/base/extension/string.dart';
// import 'package:workflow_manager/base/ui/chart/gauge_chart_screen.dart';
// import 'package:workflow_manager/base/ui/chart/line_chart_screen.dart';
// import 'package:workflow_manager/base/ui/chart/pie_chart_screen.dart';
// import 'package:workflow_manager/base/ui/empty_screen.dart';
// import 'package:workflow_manager/workflow/models/params/group_task_request.dart';
// import 'package:workflow_manager/workflow/screens/group_job/filter/filter_group_screen.dart';
// import 'package:workflow_manager/workflow/screens/statistic/performance/repository/chart_performance_task_repository.dart';
//
// class ChartPerformanceTaskScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _ChartPerformanceTaskScreen();
//   }
// }
//
// class _ChartPerformanceTaskScreen extends State<ChartPerformanceTaskScreen>
//     with AutomaticKeepAliveClientMixin {
//   ChartPerformanceTaskRepository _chartStatisticGroupTaskRepository =
//       new ChartPerformanceTaskRepository();
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     this._chartStatisticGroupTaskRepository.getDataGroupJobReport();
//   }
//
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider.value(
//       value: this._chartStatisticGroupTaskRepository,
//       child: Consumer(
//         builder: (context, ChartPerformanceTaskRepository repository, _) {
//           return Scaffold(
//             body: SafeArea(
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: <Widget>[
//                     this._buildTopView(),
//                     this._buildStatusChartView(),
//                     this._buildAmountChartView(),
//                     this._buildPerformanceChartView(),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildTopView() {
//     return Container(
//       color: "#F5F6FA".toColor(),
//       height: 32,
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.only(left: 16),
//               child: Text(
//                 'Lọc/ Tìm kiếm nhóm công việc',
//                 style: TextStyle(fontSize: 14, color: "#555555".toColor()),
//               ),
//             ),
//           ),
//           FlatButton(
//               onPressed: () {
//                 GroupTaskRequest request = GroupTaskRequest();
//                 request.jobGroupName = "";
//                 Navigator.of(context).push(MaterialPageRoute(
//                   builder: (BuildContext context) => FilterGroupScreen(
//                     originalRequest: request,
//                   ),
//                 ));
//               },
//               child: Icon(Icons.more_vert)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAmountChartView() {
//     return Container(
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(left: 16, top: 10),
//             child: Text(
//               "Số lượng công việc nhóm".toUpperCase(),
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//           Row(
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.only(left: 16, top: 10, bottom: 10),
//                 child: RotatedBox(
//                   quarterTurns: -1,
//                   child: Text("Số lượng công việc"),
//                 ),
//               ),
//               Expanded(
//                 child: SizedBox(
//                   height: 200,
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     scrollDirection: Axis.horizontal,
//                     itemCount: this
//                         ._chartStatisticGroupTaskRepository
//                         .listDataChartLine == null ? 0 : 1,
//                     itemBuilder: (context, index) {
//                       return this
//                           ._chartStatisticGroupTaskRepository
//                           .listDataChartLine == null ? EmptyScreen() : LineChartScreen(
//                         listDataChartLine: this
//                             ._chartStatisticGroupTaskRepository
//                             .listDataChartLine,
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildPerformanceChartView() {
//     return Container(
//       width: double.infinity,
//       color: Colors.white,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(left: 16, top: 10),
//             child: Text(
//               "Hiệu suất nhóm công việc".toUpperCase(),
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//           this._chartStatisticGroupTaskRepository.performanceJobGroupData == null ? EmptyScreen() :
//           GaugeChartScreen(
//             performanceJobGroupData:
//                 this._chartStatisticGroupTaskRepository.performanceJobGroupData,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatusChartView() {
//     return Container(
//       width: double.infinity,
//       color: Colors.white,
//       // height: 300,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(left: 16, top: 10),
//             child: Text(
//               "Trạng thái nhóm công việc".toUpperCase(),
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//           ),
//           this._chartStatisticGroupTaskRepository.pieChart == null ? EmptyScreen() :
//           PieChartScreen(
//             pieChart: this._chartStatisticGroupTaskRepository.pieChart,
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:workflow_manager/workflow/screens/statistic/group/chart_statistic_group_task_screen.dart';
// import 'package:workflow_manager/workflow/screens/statistic/group/list_statistic_group_task_screen.dart';
//
// import 'chart_performance_task_screen.dart';
// import 'list_performance_task_screen.dart';
//
// class MainStatisticPerformanceTaskScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _MainStatisticPerformanceTaskScreen();
//   }
// }
//
// class _MainStatisticPerformanceTaskScreen
//     extends State<MainStatisticPerformanceTaskScreen> {
//   final List<Tab> topTabs = <Tab>[
//     Tab(text: 'Biểu đồ'.toUpperCase()),
//     Tab(text: 'Danh sách'.toUpperCase()),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       body: DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           appBar: new PreferredSize(
//             preferredSize: Size.fromHeight(kToolbarHeight),
//             child: new Container(
//               color: Colors.white,
//               child: new SafeArea(
//                 child: Column(
//                   children: <Widget>[
//                     new Expanded(
//                       child: new Container(),
//                     ),
//                     new TabBar(
//                       isScrollable: false,
//                       labelColor: Colors.blue,
//                       unselectedLabelColor: Colors.grey,
//                       labelPadding: EdgeInsets.symmetric(horizontal: 10),
//                       tabs: this.topTabs,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           body: new TabBarView(children: <Widget>[
//             ChartPerformanceTaskScreen(),
//             ListPerformanceTaskScreen(),
//           ]),
//         ),
//       ),
//     );
//   }
// }

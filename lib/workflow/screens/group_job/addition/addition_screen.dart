import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/screens/group_job/addition/addition_item.dart';
import 'package:workflow_manager/workflow/screens/group_job/addition/addition_model.dart';
import 'package:workflow_manager/workflow/screens/group_job/addition/response_report_index.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_task_tab_controller.dart';
import 'package:workflow_manager/workflow/screens/notification/notification_screen.dart';
import 'package:workflow_manager/workflow/screens/statistic/main_statistic_screen.dart';

import 'addition_repository.dart';

class AdditionScreen extends StatefulWidget {
  @override
  _AdditionScreenState createState() => _AdditionScreenState();
}

class _AdditionScreenState extends State<AdditionScreen> {
  AdditionRepository additionRepository = AdditionRepository();

  List<AdditionModel> listAddition = [];

  @override
  void initState() {
    super.initState();
    additionRepository.getDataReport();

    listAddition.add(AdditionModel(
        type: 1,
        title: 'Thống kê',
        iconUrl: 'assets/images/report.png',
        color: getColor('#DFEAFB')));
    listAddition.add(AdditionModel(
        type: 2,
        title: 'Nhóm công việc',
        iconUrl: 'assets/images/group2050.png',
        color: getColor('#FCECDB')));
    listAddition.add(AdditionModel(
        type: 3,
        title: 'Thông báo',
        iconUrl: 'assets/images/notifications.png',
        color: getColor('#D9EEE8')));
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return additionRepository;
      },
      child: Consumer(
        builder: (context, AdditionRepository value, child) {
          return _mainScreen(value);
        },
      ),
    );
  }

  Widget _mainScreen(AdditionRepository repository) {
    DataReportIndex dataReportIndex = repository.data;
    double _aspectRatio = 1.5, _crossAxisSpacing = 0.2, _mainAxisSpacing = 0.2;

    return ListView(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hoàn thành'.toUpperCase(),
                    style: TextStyle(fontSize: 10, color: getColor('#6C757D')),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
                    child: new LinearPercentIndicator(
                      lineHeight: 16,
                      percent: (dataReportIndex?.performance ?? 0) / 100,
                      center: Text(
                        '${dataReportIndex?.performance ?? 0}%',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      linearStrokeCap: LinearStrokeCap.roundAll,
                      backgroundColor: getColor('#E9ECEF'),
                      progressColor: Colors.green,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Đánh giá'.toUpperCase(),
                    style: TextStyle(fontSize: 10, color: getColor('#6C757D')),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 52, right: 52, top: 4, bottom: 4),
                    child: FittedBox(
                      child: RatingBar.builder(
                        // custom gì thì custom hết ở đây
                        initialRating: (dataReportIndex?.rate ?? 0).toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Icon(
                            Icons.star_outlined,
                            color: Colors.amber,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        Container(
          height: 4,
          color: getColor('#E9ECEF'),
          margin: EdgeInsets.only(top: 16),
        ),
        Container(
          alignment: Alignment.center,
          color: Colors.white,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemCount: listAddition.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: _aspectRatio,
              crossAxisSpacing: _crossAxisSpacing,
              mainAxisSpacing: _mainAxisSpacing,
            ),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                child: Container(
                  alignment: Alignment.center,
                  child: AdditionItem(listAddition[index]),
                  color: Colors.white,
                ),
                onTap: () async {
                  switch (listAddition[index].type) {
                    case 1:
                      {
                        pushPage(context, MainStatisticScreen());
                        break;
                      }
                    case 2:
                      {
                        pushPage(context, GroupTaskTabController());
                        break;
                      }
                    case 3:
                      {
                        pushPage(context, NotificationScreen());
                        break;
                      }
                  }
                },
              );
            },
          ),
        ),
        Container(
          height: 4,
          color: getColor('#E9ECEF'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/params/group_task_request.dart';
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/shared_search_screen/shared_search_screen.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/workflow/widgets/list_tag.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/title_dialog.dart';

class FilterStatisticScreen extends StatefulWidget {
  // List<StatusGroup> statusGroups;

  void Function(GroupTaskRequest) onFilter;

  GroupTaskRequest originalRequest;

  FilterStatisticScreen({@required this.onFilter, this.originalRequest});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FilterStatisticScreen();
  }
}

class _FilterStatisticScreen extends State<FilterStatisticScreen> {
  TextEditingController searchTextController = TextEditingController();

  List<StatusItem> _listStatus = [
    StatusItem(key: 1, value: "Tháng ${getCurrentDate("MM")}"),
    StatusItem(key: 2, value: "Quý I"),
    StatusItem(key: 3, value: "Quý II"),
    StatusItem(key: 4, value: "Quý III"),
    StatusItem(key: 5, value: "Quý IV"),
    StatusItem(key: 6, value: "Năm ${getCurrentDate("yyyy")}"),
  ];

  @override
  void initState() {
    super.initState();
    searchTextController.text = widget.originalRequest.jobGroupName;
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.originalRequest.startDate ==
            "01/01/${getCurrentDate("yyyy")}" &&
        this.widget.originalRequest.endDate ==
            "${getLastOfMonth()}/${getCurrentDate("MM/yyyy")}") {
      this._listStatus[0] = StatusItem(
          key: 1, value: "Tháng ${getCurrentDate("MM")}", isSelected: true);
    } else if (this.widget.originalRequest.startDate ==
            "01/01/${getCurrentDate("yyyy")}" &&
        this.widget.originalRequest.endDate ==
            "${getLastOfMonthWithMonth(3)}/03${getCurrentDate("/yyyy")}") {
      this._listStatus[1] =
          StatusItem(key: 2, value: "Quý I", isSelected: true);
    } else if (this.widget.originalRequest.startDate ==
            "01/04${getCurrentDate("/yyyy")}" &&
        this.widget.originalRequest.endDate ==
            "${getLastOfMonthWithMonth(6)}/06${getCurrentDate("/yyyy")}") {
      this._listStatus[2] =
          StatusItem(key: 3, value: "Quý II", isSelected: true);
    } else if (this.widget.originalRequest.startDate ==
            "01/07${getCurrentDate("/yyyy")}" &&
        this.widget.originalRequest.endDate ==
            "${getLastOfMonthWithMonth(6)}/06${getCurrentDate("/yyyy")}") {
      this._listStatus[3] =
          StatusItem(key: 4, value: "Quý III", isSelected: true);
    } else if (this.widget.originalRequest.startDate ==
            "01/10${getCurrentDate("/yyyy")}" &&
        this.widget.originalRequest.endDate ==
            "${getLastOfMonthWithMonth(12)}/12${getCurrentDate("/yyyy")}") {
      this._listStatus[4] =
          StatusItem(key: 5, value: "Quý IV", isSelected: true);
    } else if (this.widget.originalRequest.startDate ==
            "01/01${getCurrentDate("/yyyy")}" &&
        this.widget.originalRequest.endDate ==
            "${getLastOfMonthWithMonth(12)}/12${getCurrentDate("/yyyy")}") {
      this._listStatus[5] = StatusItem(
          key: 6, value: "Năm ${getCurrentDate("yyyy")}", isSelected: true);
    }
    return Container(
      child: Wrap(
        children: <Widget>[
          TitleDialog(
            "LỌC / TÌM KIẾM",
            padding: 16,
          ),
          Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: ListTagWidget(
                      listStatus: this._listStatus,
                      onStatusSelected: (value) {
                        print("${value.key}");
                        switch (value.key) {
                          case 1:
                            setState(() {
                              this.widget.originalRequest.startDate =
                              "01/${getCurrentDate("MM/yyyy")}";
                              this.widget.originalRequest.endDate =
                              "${getLastOfMonth()}/${getCurrentDate("MM/yyyy")}";
                            });
                            break;
                          case 2:
                            setState(() {
                              this.widget.originalRequest.startDate =
                              "01/01${getCurrentDate("/yyyy")}";
                              this.widget.originalRequest.endDate =
                              "${getLastOfMonthWithMonth(3)}/03${getCurrentDate("/yyyy")}";
                            });
                            break;
                          case 3:
                            setState(() {
                              this.widget.originalRequest.startDate =
                              "01/04${getCurrentDate("/yyyy")}";
                              this.widget.originalRequest.endDate =
                              "${getLastOfMonthWithMonth(6)}/06${getCurrentDate("/yyyy")}";
                            });
                            break;
                          case 4:
                            setState(() {
                              this.widget.originalRequest.startDate =
                              "01/07${getCurrentDate("/yyyy")}";
                              this.widget.originalRequest.endDate =
                              "${getLastOfMonthWithMonth(9)}/09${getCurrentDate("/yyyy")}";
                            });
                            break;
                          case 5:
                            setState(() {
                              this.widget.originalRequest.startDate =
                              "01/10${getCurrentDate("/yyyy")}";
                              this.widget.originalRequest.endDate =
                              "${getLastOfMonthWithMonth(12)}/12${getCurrentDate("/yyyy")}";
                            });
                            break;
                          case 6:
                            setState(() {
                              this.widget.originalRequest.startDate =
                              "01/01${getCurrentDate("/yyyy")}";
                              this.widget.originalRequest.endDate =
                              "${getLastOfMonthWithMonth(12)}/12${getCurrentDate("/yyyy")}";
                            });
                            break;
                        }
                      },
                    )),
                TagLayoutWidget(
                  title: 'Từ ngày',
                  icon: Icons.date_range,
                  value: widget.originalRequest.startDate == null
                      ? ''
                      : widget.originalRequest.startDate,
                  openFilterListener: () {
                    DateTimePickerWidget(
                        context: context,
                        format: Constant.ddMMyyyy,
                        onDateTimeSelected: (dateValue) {
                          setState(() {
                            this.widget.originalRequest.startDate = dateValue;
                          });
                        }).showOnlyDatePicker();
                  },
                ),
                TagLayoutWidget(
                  title: 'Đến ngày',
                  icon: Icons.date_range,
                  value: widget.originalRequest.endDate == null
                      ? ''
                      : widget.originalRequest.endDate,
                  openFilterListener: () {
                    DateTimePickerWidget(
                        context: context,
                        format: Constant.ddMMyyyy,
                        onDateTimeSelected: (dateValue) {
                          setState(() {
                            this.widget.originalRequest.endDate = dateValue;
                          });
                        }).showOnlyDatePicker();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SaveButton(
                    title: 'Chọn',
                    onTap: () {
                      this.widget.onFilter(widget.originalRequest);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSearchView() {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(bottom: 20)),
          FlatButton(
            child: Text('Tìm kiếm nhóm công việc: ${this.widget.originalRequest
                .jobGroupName ?? "--"}',
              textAlign: TextAlign.left,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) =>
                    SharedSearchScreen(
                      AppUrl.getListJobGroup,
                      "Tìm kiếm nhóm công việc",
                      onSharedSearchSelected: (value) {
                        setState(() {
                          this.widget.originalRequest.idJobGroup = value.iD;
                          this.widget.originalRequest.jobGroupName = value.name;
                        });
                      },
                    ),
              ));
            },
          ),
        ],
      ),
    );
  }
}

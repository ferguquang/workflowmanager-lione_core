import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/back_icon_button.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/params/group_task_request.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';

// Sao class này chỉ có originalRequest, cần chú ý chỉnh lại giống bên FilterTaskScreen trong update mới
class FilterGroupScreen extends StatefulWidget {
  // List<StatusGroup> statusGroups;

  void Function(GroupTaskRequest) onFilter;

  GroupTaskRequest originalRequest;

  FilterGroupScreen({@required this.onFilter, this.originalRequest});

  @override
  _FilterGroupScreenState createState() => _FilterGroupScreenState();
}

class _FilterGroupScreenState extends State<FilterGroupScreen> {
  TextEditingController searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchTextController.text = widget.originalRequest.jobGroupName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lọc"),
        leading: GestureDetector(
          onTap: () {
            /* Write listener code here */
          },
          child: BackIconButton(),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Xoá",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              // this._filterTaskRepository.resetFilter();
              setState(() {
                this.searchTextController.text = "";
                widget.originalRequest.startDate = "";
                widget.originalRequest.endDate = "";
                this.setState(() {
                  widget.originalRequest = GroupTaskRequest();
                });
              });
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSearchView(),
              TagLayoutWidget(
                title: 'Từ ngày',
                icon: Icons.date_range,
                value: widget.originalRequest.startDate == null
                    ? ''
                    : widget.originalRequest.startDate,
                openFilterListener: () {
                  DateTimePickerWidget(
                      context: context,
                      format: Constant.ddMMyyyy2,
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
                      format: Constant.ddMMyyyy2,
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
                  title: 'Áp dụng',
                  onTap: () {
                    this.widget.onFilter(widget.originalRequest);
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchView() {
    return Container(
      color: getColor('F1F2F5'),
      padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: TextField(
          style: TextStyle(fontSize: 15),
          autocorrect: false,
          controller: searchTextController,
          onChanged: (value) {
            // _searchAction.action(value);
            widget.originalRequest.jobGroupName = value;
          },
          decoration: InputDecoration(
            hintText: 'Tìm kiếm nhóm công việc',
            prefixIcon: Icon(Icons.search),
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            enabledBorder: new UnderlineInputBorder(
                borderSide: new BorderSide(color: Colors.white)),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}

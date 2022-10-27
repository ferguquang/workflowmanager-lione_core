import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/response/task_detail_response.dart';
import 'package:workflow_manager/workflow/screens/details/task_details_screen_head/task_details_screen_head.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

import '../back_detail_data.dart';
import 'approval_extension_provider.dart';

class ApprovalExtensionScreen extends StatefulWidget {
  int taskType;
  int taskId;
  JobExtension jobExtension;
  String startDate;

  ApprovalExtensionScreen(this.taskType, this.taskId,
      {this.jobExtension, this.startDate});

  @override
  State<StatefulWidget> createState() {
    return _ApprovalExtensionScreenState();
  }
}

class _ApprovalExtensionScreenState extends State<ApprovalExtensionScreen> {
  ApprovalExtensionProvider _approvalExtensionProvider =
      ApprovalExtensionProvider();
  GlobalKey _headerKey = GlobalKey();
  ExtensionState state;
  BackDetailData backData;
  HeaderWidget _headerWidget;

  @override
  void initState() {
    super.initState();
    state = (widget.taskType == 1
        ? (widget.jobExtension.iD == 0
            ? ExtensionState.Add
            : ExtensionState.Waiting)
        : ExtensionState.Approve);
    _approvalExtensionProvider.loadById(widget.taskId);
    _headerWidget = HeaderWidget(_headerKey, state, widget.jobExtension);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ChangeNotifierProvider.value(
            value: _approvalExtensionProvider,
            child: Consumer(
              builder: (context,
                  ApprovalExtensionProvider approvalExtensionProvider, child) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text(
                      '${state == ExtensionState.Approve ? "Duyệt gia hạn" : (state == ExtensionState.Add ? "Xin gia hạn" : "Chờ phê duyệt")}',
                    ),
                  ),
                  body: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              _headerWidget,
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: approvalExtensionProvider
                                    .extensionHistoryModels.length,
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16,
                                          right: 16,
                                          top: 8,
                                          bottom: 8),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.circle,
                                                size: 8,
                                                color: Colors.grey,
                                              ),
                                              Text("")
                                            ],
                                          ),
                                          SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  approvalExtensionProvider
                                                      .extensionHistoryModels[
                                                          index]
                                                      .created
                                                      .toDateFormat(),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                ),
                                                Text(approvalExtensionProvider
                                                        ?.extensionHistoryModels[
                                                            index]
                                                        ?.describe ??
                                                    "")
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: state == ExtensionState.Approve ||
                              state == ExtensionState.Add,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 16, top: 16, bottom: 16, right: 8),
                                  width: double.infinity,
                                  child: FlatButton(
                                    height: 48,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Colors.black54),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    textColor: Colors.black54,
                                    child: Text(
                                      (state == ExtensionState.Add
                                              ? "Hủy"
                                              : 'Từ chối')
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.black),
                                    ),
                                    onPressed: () async {
                                      if (state == ExtensionState.Add) {
                                        Navigator.pop(context);
                                      } else {
                                        bool isSuccess =
                                            await approvalExtensionProvider
                                                .reject(widget.taskId,
                                                    widget.jobExtension.iD);
                                        backData =
                                            BackDetailData(isReject: isSuccess);
                                        if (isSuccess) {
                                          ToastMessage.show("Từ chối gia hạn thành công", ToastStyle.success);
                                          Navigator.pop(context, backData);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 8, top: 16, bottom: 16, right: 16),
                                  width: double.infinity,
                                  child: FlatButton(
                                    height: 48,
                                    color: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    textColor: Colors.white,
                                    child: Text(
                                      (widget.taskType == 1
                                              ? 'Xin gia hạn'
                                              : "Duyệt gia hạn"),
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    onPressed: () async {
                                      HeaderWidget header = _headerKey
                                          .currentWidget as HeaderWidget;
                                      if (state == ExtensionState.Add) {
                                        if (isNullOrEmpty(header.reason)) {
                                          ToastMessage.show(
                                              "Lý do xin gia hạn không được để trống",
                                              ToastStyle.error);
                                          return;
                                        }
                                        if (isNullOrEmpty(header.date)) {
                                          ToastMessage.show(
                                              "Ngày gia hạn không được để trống",
                                              ToastStyle.error);
                                          return;
                                        } else if (compareDate(widget.startDate,
                                                header.date) !=
                                            -1) {
                                          ToastMessage.show(
                                              "Ngày gia hạn không được nhỏ hơn Ngày bắt đầu",
                                              ToastStyle.error);
                                          return;
                                        }
                                        JobExtension jobExtension =
                                            await approvalExtensionProvider
                                                .addExtension(widget.taskId,
                                                    header.date, header.reason);
                                        backData = BackDetailData(
                                            jobExtension: jobExtension);
                                        if (jobExtension != null) {
                                          Navigator.pop(context, backData);
                                        }
                                      } else {
                                        bool isSuccess =
                                            await approvalExtensionProvider
                                                .approve(
                                                    widget.taskId,
                                                    header.date,
                                                    widget.jobExtension.iD);
                                        backData = BackDetailData(
                                            isApproval: isSuccess);
                                        if (isSuccess) {
                                          ToastMessage.show("Duyệt gia hạn thành công", ToastStyle.success);
                                          Navigator.pop(context, backData);
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )));
  }
}

class HeaderWidget extends StatefulWidget {
  String date;
  String reason;
  ExtensionState state;
  JobExtension jobExtension;

  HeaderWidget(Key key, this.state, this.jobExtension) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HeaderWidgetState();
  }
}

class _HeaderWidgetState extends State<HeaderWidget> {
  TextEditingController _dateController = TextEditingController();
  TextEditingController _reasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.jobExtension.iD != 0) {
      _dateController.text = widget.jobExtension.newDeadline.toDateTimeFormat();
      _reasonController.text = widget.jobExtension.reason ?? "";
      widget.date = widget.jobExtension.newDeadline.toDateFormat();
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Lý do xin gia hạn',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text("*", style: TextStyle(color: Colors.red),)
                ],
              ),
              TextField(
                // textInputAction: TextInputAction.done,
                // keyboardType: TextInputType.multiline,
                maxLines: null,
                controller: _reasonController,
                enabled: widget.state == ExtensionState.Add,
                onChanged: (value) {
                  widget.reason = value;
                },
                decoration: InputDecoration(
                  labelStyle: TextStyle(fontSize: 12),
                ),
              ),
              const SizedBox(height: 10),
              TagLayoutWidget(
                  title: "Ngày gia hạn",
                  isShowValidate: true,
                  value: _dateController.text,
                  icon: Icons.date_range,
                  openFilterListener: () {
                    if (widget.state != ExtensionState.Waiting) {
                      DatePicker.showDateTimePicker(context, locale: LocaleType.vi,
                          onConfirm: (date) {
                        this.setState(() {
                          _dateController.text =
                              DateFormat(Constant.ddMMyyyyHHmm).format(date);
                          widget.date = DateFormat(Constant.ddMMyyyyHHmm).format(date);
                        });
                      });
                    }
                  },
                  horizontalPadding: 0),
            ],
          ),
        ),
        Container(
          height: 5,
          color: "#E9ECEF".toColor(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Lịch sử gia hạn',
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

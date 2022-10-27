import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/date_time_picker_widget.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/response/search_user_model_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/shared_search_screen/shared_search_screen.dart';
import 'package:workflow_manager/workflow/widgets/change_status/change_status_repository.dart';
import 'package:workflow_manager/workflow/widgets/change_status/change_updefined_state_reponse.dart';
import 'package:workflow_manager/workflow/widgets/task_layout_widget.dart';

class CustomTransferStatusJobDialog {
  BuildContext context;

  // ĐÂY LÀ MÀN CHUYỂN TRẠNG THÁI CÔNG VIỆC DIALOG
  CustomTransferStatusJobDialog(this.context);

  Future<ChangeUndefinedStatusModel> showCustomDialog(int jobId, int idGroup,
      SharedSearchModel jobRecipient, String endDate) async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.black45,
          body: Center(
            child: Wrap(
              children: [
                TransferStatusJob(jobId, idGroup, jobRecipient, endDate)
              ],
            ),
          ),
        );
      },
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}

class TransferStatusJob extends StatefulWidget {
  int jobId;
  int idGroup;

  SharedSearchModel jobRecipient; // người nhận việc dùng khi sửa công việc
  String endDate;

  TransferStatusJob(this.jobId, this.idGroup, this.jobRecipient,
      this.endDate); // ngày kết thúc dùng khi sửa công việc

  @override
  State<StatefulWidget> createState() {
    return _TransferStatusJobState();
  }
}

class _TransferStatusJobState extends State<TransferStatusJob> {
  TextEditingController timeController = TextEditingController();
  ChangeStatusRepository _changeStatusRepository = ChangeStatusRepository();

  @override
  void initState() {
    super.initState();
    if (widget.jobRecipient != null) {
      _changeStatusRepository.userItem = UserItem();
      _changeStatusRepository?.userItem?.iD = widget.jobRecipient?.iD;
      _changeStatusRepository?.userItem?.name = widget.jobRecipient?.name;
    }
    if (widget.endDate != null) {
      timeController.text = widget.endDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _changeStatusRepository,
      child: Consumer(
        builder:
            (context, ChangeStatusRepository changeStatusRepository, child) {
          return Container(
            margin: EdgeInsets.all(20),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                              child: Text(
                            "Chuyển trạng thái công việc".toUpperCase(),
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                decoration: TextDecoration.none),
                          )),
                          Container(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.clear_sharp,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: Text(
                        "Bạn phải bổ sung thông tin công việc để chuyển công việc Chưa xác định sang trạng thái khác",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            decoration: TextDecoration.none),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TagLayoutWidget(
                      title: "Ngày kết thúc",
                      value: timeController.text,
                      icon: Icons.date_range,
                      openFilterListener: () {
                        eventDateTimepicker();
                      },
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TagLayoutWidget(
                      title: "Người nhận việc",
                      value: changeStatusRepository?.userItem?.name ?? "",
                      icon: Icons.arrow_drop_down_rounded,
                      openFilterListener: () {
                        eventChooseJobUser(false);
                      },
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        child: FlatButton(
                          child: Text(
                            "Đóng".toUpperCase(),
                            style: TextStyle(
                                color: "555555".toColor(), fontSize: 14),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        decoration: BoxDecoration(
                          color: "E9ECEF".toColor(),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10)),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        child: FlatButton(
                          child: Text(
                            "Chuyển trạng thái".toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          onPressed: () async {
                            if (isNullOrEmpty(timeController.text)) {
                              ToastMessage.show(
                                  "Ngày kết thúc không được để trống",
                                  ToastStyle.error);
                              return;
                            }
                            if (isNullOrEmpty(
                                changeStatusRepository?.userItem?.name)) {
                              ToastMessage.show(
                                  "Người nhận việc không được để trống",
                                  ToastStyle.error);
                              return;
                            }
                            ChangeUndefinedStatusModel data =
                                await changeStatusRepository
                                    .changeUndefinedStatus(
                                        widget.jobId,
                                        timeController.text,
                                        changeStatusRepository?.userItem?.iD);
                            if (data != null) {
                              Navigator.pop(context, data);
                            }
                          },
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void eventDateTimepicker() {
    DateTimePickerWidget(
        format: Constant.ddMMyyyyHHmm,
        context: context,
        onDateTimeSelected: (valueDate) {
          setState(() {
            timeController.text = valueDate;
          });
          // print(valueDate);
        }).showDateTimePicker();
  }

  void eventChooseJobUser(bool isJobGroup) {
    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (context) => SearchUserScreen(
    //           isJobGroup: isJobGroup,
    //           onUserSelected: (item) {
    //             _changeStatusRepository.changeUser(item);
    //           },
    //         )));

    Map<String, dynamic> params = new Map<String, dynamic>();
    params["PageSize"] = 20;
    params["IDGroupJob"] = widget.idGroup;
    // params["SearchName"] = '';

    Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
      return SharedSearchScreen(
          AppUrl.getUserForCreateJob, 'Tìm kiếm tên nhân viên', params: params,
          onSharedSearchSelected: (item) {
        this.setState(() {
          UserItem userItem = UserItem();
          userItem.iD = item.iD;
          userItem.name = item.name;
          _changeStatusRepository.changeUser(userItem);
        });
      });
    }));
  }
}

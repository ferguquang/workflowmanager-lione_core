import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/ratingbar_widget.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/workflow/models/params/for_tranfer_user_request.dart';
import 'package:workflow_manager/workflow/models/params/transfer_rate_user_request.dart';
import 'package:workflow_manager/workflow/models/response/job_recipient_response.dart';
import 'package:workflow_manager/workflow/screens/details/transfer/transfer_job/transfer_job_repository.dart';
import 'package:workflow_manager/workflow/screens/group_job/shared_search_screen/shared_search_screen.dart';

// CHUYỂN GIAO CÔNG VIỆC
class TransferJobScreen extends StatefulWidget {
  // sIDJob id công việc
  // sIDOldCoExecuter id nguời phối hợp
  // sIDOldSupervisor ID người giám sát
  //sName là người nhận việc cũ
  String sIDJob, sIDOldCoExecuter, sIDOldSupervisor, sName;
  int idGroup;

  TransferJobScreen(this.sIDJob, this.sIDOldCoExecuter, this.sIDOldSupervisor,
      this.sName, this.idGroup);

  @override
  State<StatefulWidget> createState() {
    return _TransferJobScreenState();
  }
}

class _TransferJobScreenState extends State<TransferJobScreen> {
  TransferJobRepository _transferJobRepository = TransferJobRepository();
  TextEditingController ratingNoteText = TextEditingController();
  TextEditingController reasonText = TextEditingController();

  DataJobRecipient _dataJobRecipient = DataJobRecipient();
  String sRate = '0', sIDNewExecutor;
  TextEditingController jobUsersController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ForTranferUserRequest request = ForTranferUserRequest();
    request.idJob = widget.sIDJob;
    _transferJobRepository.loadDataForTransferUser(request);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => _transferJobRepository,
        child: Consumer(
          builder:
              (context, TransferJobRepository _transferJobRepository, child) {
            return Scaffold(
              appBar: AppBar(
                title: Text('Chuyển giao công việc'),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          _headerWidget(),
                          ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: _transferJobRepository
                                        .dataForTranferUserModel ==
                                    null
                                ? 0
                                : _transferJobRepository
                                    .dataForTranferUserModel.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 8, bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 8,
                                        color: Colors.grey,
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
                                              _transferJobRepository
                                                  .dataForTranferUserModel[
                                                      index]
                                                  .created
                                                  .toDateTimeFormat(),
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                style:
                                                    DefaultTextStyle.of(context)
                                                        .style,
                                                children: [
                                                  TextSpan(
                                                      text: _transferJobRepository
                                                          .dataForTranferUserModel[
                                                              index]
                                                          .describe,
                                                      style: TextStyle(
                                                          fontSize: 14)),
                                                ],
                                              ),
                                            )
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SaveButton(
                        title: 'Chuyển giao'.toUpperCase(),
                        onTap: () {
                          _eventTransferRateUser();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }

  Widget _headerWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 24, right: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.blue[100],
                ),
                alignment: Alignment.center,
                height: 21,
                width: 21,
                child: Text(
                  '1',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bạn phải đánh giá kết quả công việc của ${widget.sName} trước khi chuyển giao cho nhân sự mới',
                      style: TextStyle(fontSize: 14),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.center,
                      child: RatingBarWidget(
                        value: 0,
                        onCountChange: (value) {
                          print(value);
                          sRate = value.toString();
                        },
                      ),
                    ),
                    TextField(
                      controller: ratingNoteText,
                      decoration: InputDecoration(
                        labelText: 'Nhận xét',
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                  color: Colors.blue[100],
                ),
                alignment: Alignment.center,
                height: 21,
                width: 21,
                child: Text(
                  '2',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Bạn hãy nhập lý do và thông tin người nhận công việc',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "*",
                          style: TextStyle(color: Colors.red),
                        )
                      ],
                    ),
                    TextField(
                      controller: reasonText,
                      decoration: InputDecoration(
                        labelText: 'Lý do chuyển',
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        // final result = await Navigator.of(context)
                        //     .push(MaterialPageRoute(builder: (builder) {
                        //   return JobRecipientScreen(widget.sIDJob);
                        // }));
                        // setState(() {
                        //   _dataJobRecipient = result;
                        //   jobUsersController.text = _dataJobRecipient.name;
                        // });
                        Map<String, dynamic> params =
                            new Map<String, dynamic>();
                        params["PageSize"] = 20;
                        params["IDGroupJob"] = widget.idGroup;
                        // params["SearchName"] = '';

                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (builder) {
                          return SharedSearchScreen(AppUrl.getUserForCreateJob,
                              'Tìm kiếm tên nhân viên', params: params,
                              onSharedSearchSelected: (item) {
                            this.setState(() {
                              _dataJobRecipient.iD = item.iD;
                              _dataJobRecipient.name = item.name;
                              jobUsersController.text = _dataJobRecipient.name;
                            });
                          });
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                          top: 16,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text("Người nhận việc"),
                                      Text(
                                        "*",
                                        style: TextStyle(color: Colors.red),
                                      )
                                    ],
                                  ),
                                ),
                                Icon(Icons.arrow_drop_down_rounded)
                              ],
                            ),
                            TextField(
                              enabled: false,
                              controller: jobUsersController,
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.black),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 5,
          color: "E9ECEF".toColor(),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.grey,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Lịch sử chuyển giao '.toUpperCase(),
                  style: TextStyle(color: Colors.black87, fontSize: 14),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  void _eventTransferRateUser() {
    FocusScope.of(context).unfocus();
    if (ratingNoteText.text.isEmpty || ratingNoteText.text.length == 0) {
      ToastMessage.show('Nhận xét không được để trống', ToastStyle.error);
      return;
    }

    if (reasonText.text.isEmpty || reasonText.text.length == 0) {
      ToastMessage.show('Lý do chuyển không được để trống', ToastStyle.error);
      return;
    }

    if (_dataJobRecipient == null ||
        _dataJobRecipient.iD == null ||
        _dataJobRecipient.iD == 0) {
      ToastMessage.show(
          'Người nhận việc không được để trống', ToastStyle.error);
      return;
    }
    // "IDJob": "31063", ID công việc
    // "RatingNote": "6666", Đánh giá
    // "Rate": "3", Số sao đánh giá công việc
    // "Reason": Lý do chuyển
    // "IDNewExecutor": "95", ID người thực hiện công việc mới
    // "IDOldCoExecuter" ID nguời phối hợp,
    // IDOldSupervisor: ID người giám sát
    TransferRateUserRequest request = TransferRateUserRequest();
    request.sIDJob = widget.sIDJob;
    request.sRatingNote = ratingNoteText.text;
    request.sRate = sRate;
    request.sReason = reasonText.text;
    request.sIDNewExecutor = _dataJobRecipient.iD.toString();
    request.sIDOldCoExecuter = widget.sIDOldCoExecuter;
    request.sIDOldSupervisor = widget.sIDOldSupervisor;
    _transferJobRepository.getTransferAndRateUser(request, context);
  }
}

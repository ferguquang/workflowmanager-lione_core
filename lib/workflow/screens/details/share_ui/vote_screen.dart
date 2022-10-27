import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:workflow_manager/workflow/models/params/vote_task_request.dart';
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/repository/vote_screen_repository.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/title_dialog.dart';

typedef DoubleCallback = void Function(double value);

class VoteScreen extends StatefulWidget {
  double vote;
  DoubleCallback onTap;
  int jobId;
  final void Function(StatusItem, double) onTaskVoted;

  VoteScreen({this.jobId, this.vote, this.onTap, this.onTaskVoted});

  @override
  State<StatefulWidget> createState() {
    return _VoteScreen();
  }
}

class _VoteScreen extends State<VoteScreen> {
  VoteTaskRequest _request = VoteTaskRequest();
  double padding = 20;
  VoteScreenRepository _voteScreenRepository = VoteScreenRepository();
  TextEditingController _rateTextController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _request.rate = widget.vote.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(children: [
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TitleDialog(
                    "Đánh giá công việc",
                    padding: padding,
                  ),
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: padding),
                      color: Colors.white,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                  "Bạn có thể đánh giá kết quả công việc trước khi đóng"),
                            ),
                            Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: FittedBox(
                                  child: RatingBar.builder(
                                    // custom gì thì custom hết ở đây
                                    initialRating: _request.rate.toDouble(),
                                    itemCount: 5,

                                    itemPadding: EdgeInsets.all(0),
                                    direction: Axis.horizontal,
                                    onRatingUpdate: (value) {
                                      _request.rate = value.toInt();
                                    },
                                    itemBuilder: (context, index) {
                                      return Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      );
                                    },
                                  ),
                                )),
                            Padding(
                              padding: EdgeInsets.only(top: 30),
                            ),
                            Text("Nhận xét"),
                            TextField(
                              controller: _rateTextController,
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: SaveButton(
                                  title: "ĐÓNG CÔNG VIỆC",
                                  onTap: () {
                                    if (this.widget.onTap != null)
                                      this
                                          .widget
                                          .onTap(_request.rate.toDouble());
                                    this.executeRateTask();
                                  },
                                ))
                          ]))
                ],
              )),
        )
      ]),
    );
  }

  Future<void> executeRateTask() async {
    _request.idJob = this.widget.jobId;
    _request.ratingNote = this._rateTextController.text;
    print('abcccccccccc12312313 ${_request.rate}');
    await _voteScreenRepository.ratingCloseJob(_request);

    if (_voteScreenRepository.ratingCloseJobData != null) {
      this.widget.onTaskVoted(
          _voteScreenRepository.ratingCloseJobData, _request.rate.toDouble());
    }
    Navigator.of(context).pop();
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:workflow_manager/workflow/models/response/get_data_for_list_group_job_personal_response.dart';

class ReportPerformanceCell extends StatefulWidget {
  DataGroupJobPersonal item = DataGroupJobPersonal();

  ReportPerformanceCell({this.item});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReportPerformanceCell();
  }
}

class _ReportPerformanceCell extends State<ReportPerformanceCell> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: 16, top: 10),
          child: Text(
            this.widget.item.jobName,
            style: TextStyle(color: Colors.blue),
          ),
        )),
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Padding(
            padding: EdgeInsets.only(left: 0, top: 10, bottom: 0),
            child: SizedBox(
              width: 80,
              height: 20,
              child: FittedBox(
                child: RatingBar.builder(
                  // custom gì thì custom hết ở đây
                  initialRating: this.widget.item.rate.toDouble(),
                  itemCount: 5,

                  itemPadding: EdgeInsets.all(0),
                  direction: Axis.horizontal,
                  onRatingUpdate: (value) {},
                  itemBuilder: (context, index) {
                    return Icon(
                      Icons.star,
                      color: Colors.amber,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 16, top: 10),
          child: Text('${this.widget.item.percentComplete}'),
        ),
      ],
    );
  }
}

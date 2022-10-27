import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/workflow/models/event/refresh_list_task_event.dart';
import 'package:workflow_manager/workflow/models/event/view_mode_event.dart';
import 'package:workflow_manager/workflow/widgets/list_tag.dart';
import 'package:workflow_manager/workflow/models/response/list_status_response.dart';
import 'package:workflow_manager/workflow/screens/details/share_ui/title_dialog.dart';

import '../../../main.dart';

class ChangeStatusView extends StatelessWidget {
  final List<StatusItem> listStatus;

  final void Function(StatusItem) onStatusSelected;

  ChangeStatusView({this.listStatus, this.onStatusSelected});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          TitleDialog('CHUYỂN TRẠNG THÁI'),
          Container(
            padding: EdgeInsets.only(bottom: 50),
            width: double.infinity,
            color: Colors.white,
            child: ListTagWidget(
              listStatus: listStatus,
              onStatusSelected: (item) {
                this.onStatusSelected(item);
                // eventBus.fire(new RefreshListTaskEvent());
              },
            ),
          ),
        ],
      ),
    );
  }

}
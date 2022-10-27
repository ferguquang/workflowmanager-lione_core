import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/procedures/models/response/group_infos.dart';

class GroupInfoWidget extends StatefulWidget {
  List<GroupInfos> groupInfos;

  GroupInfoWidget(this.groupInfos);

  @override
  _GroupInfoWidgetState createState() => _GroupInfoWidgetState();
}

class _GroupInfoWidgetState extends State<GroupInfoWidget> {
  List<GroupInfos> groupInfos;

  @override
  void initState() {
    super.initState();
    groupInfos = widget.groupInfos;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

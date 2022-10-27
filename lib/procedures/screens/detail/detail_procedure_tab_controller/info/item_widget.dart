import 'package:flutter/cupertino.dart';
import 'package:workflow_manager/procedures/models/response/solved_info.dart';

class ItemWidget extends StatefulWidget {
  SolvedInfo solvedInfo;
  int type;
  ItemWidget(this.solvedInfo,this.type);

  @override
  _ItemWidgetState createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  SolvedInfo solvedInfo;

  @override
  void initState() {
    super.initState();
    this.solvedInfo = widget.solvedInfo;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

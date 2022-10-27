import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/okr/base/ui/timeline_one_column.dart';

class OKRMainScreen extends StatefulWidget {
  const OKRMainScreen({Key key}) : super(key: key);

  @override
  _OKRMainScreenState createState() => _OKRMainScreenState();
}

class _OKRMainScreenState extends State<OKRMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kế hoạch trọng tâm"),
      ),
      body: TimelineOneColumnWidget(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/save_button.dart';

class DetailCommodityScreen extends StatefulWidget {
  @override
  _DetailCommodityScreenState createState() => _DetailCommodityScreenState();
}

class _DetailCommodityScreenState extends State<DetailCommodityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chi tiết"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Container();
                },
              ),
            ),
            SaveButton(
              title: "XONG",
              onTap: () {

              },
              margin: EdgeInsets.all(16),
            )
          ],
        ),
      ),
    );
  }
}

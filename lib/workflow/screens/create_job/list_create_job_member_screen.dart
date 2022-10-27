import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/save_button.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/screens/create_job/selected_multiple_screen/selected_multiple_screen.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';

class ListCreateJobMemberScreen extends StatefulWidget {
  Map<String, dynamic> params;
  List<SharedSearchModel> listSelected;
  bool isType; // true là người giám sát, false là người phối hợp
  final void Function(List<SharedSearchModel>) onSharedSearchSelected;
  ListCreateJobMemberScreen(this.params, this.listSelected, this.isType,
      {this.onSharedSearchSelected});

  @override
  State<StatefulWidget> createState() {
    return ListCreateJobMemberState();
  }
}

class ListCreateJobMemberState extends State<ListCreateJobMemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isType == true ? 'Người giám sát' : 'Người phối hợp'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              List<SharedSearchModel> listCheck = [];
              listCheck.addAll(widget.listSelected);
              Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
                return SelectMultipleScreen(AppUrl.getUserForCreateJob,
                    'Tìm kiếm ${widget.isType ? 'người giám sát' : 'người phối hợp'}',
                    listSelected: listCheck,
                    params: widget.params, onSharedSearchSelected: (item) {
                  this.setState(() {
                    widget.listSelected = item;
                  });
                });
              }));
            },
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: isNullOrEmpty(widget.listSelected) ||
                      widget.listSelected.length == 0
                  ? EmptyScreen()
                  : ListView.separated(
                      itemCount: widget.listSelected.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(widget.listSelected[index].name),
                          trailing: IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                widget.listSelected.removeAt(index);
                              });
                            },
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SaveButton(
                title: 'Lưu'.toUpperCase(),
                onTap: () {
                  if (this.widget.onSharedSearchSelected != null)
                    this.widget.onSharedSearchSelected(widget.listSelected);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

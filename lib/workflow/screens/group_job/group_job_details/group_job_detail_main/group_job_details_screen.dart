import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/one_signal_manager.dart';
import 'package:workflow_manager/main.dart';
import 'package:workflow_manager/workflow/screens/group_job/create_group/create_group_screen.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_job_detail_main/group_job_details_screen_provider.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_job_details_screen/group_job_detai_head_screen.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_tab_controller/group_tab_controller.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';

class GroupJobDetailsScreen extends StatefulWidget {
  int groupId;
  Function _reload;

  reloadData() {
    if (_reload != null) {
      _reload();
    }
  }

  GroupJobDetailsScreen(this.groupId);

  @override
  _GroupJobDetailsScreenState createState() => _GroupJobDetailsScreenState();
}

class _GroupJobDetailsScreenState extends State<GroupJobDetailsScreen>
    with SingleTickerProviderStateMixin {
  GroupJobDetailsScreenProvider _groupDetailsScreenProvider =
      GroupJobDetailsScreenProvider();

  reloadData() {
    _groupDetailsScreenProvider.loadById(widget.groupId);
  }

  bool isVisible = false;

  @override
  void initState() {
    super.initState();
    eventBus.on<NotiData>().listen((event) {
      if (isVisible) {
        Navigator.pop(context);
      }
      pushPage(context, GroupJobDetailsScreen(event.id));
    });
    widget._reload = reloadData;
    reloadData();
  }

  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("grouptask"),
      onVisibilityChanged: (info) {
        isVisible = info.visibleFraction == 1;
      },
      child: ChangeNotifierProvider.value(
          value: _groupDetailsScreenProvider,
          child: Consumer(
            builder: (context,
                GroupJobDetailsScreenProvider groupJobDetailsScreenProvider,
                child) {
              return Scaffold(
                  key: _key,
                  // resizeToAvoidBottomPadding: false,
                  appBar: AppBar(
                    title: Text(
                      "Chi tiết nhóm công việc".toString(),
                    ),
                    actions: [
                      Visibility(
                        visible: (_groupDetailsScreenProvider
                                    ?.groupDetailModel?.role ??
                                2) ==
                            1,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () async {
                            int i = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreateGroupScreen(false,
                                      groupJobDetailModel:
                                          _groupDetailsScreenProvider
                                              .groupDetailModel),
                                ));
                            if (i == 1) {
                              reloadData();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  body: groupJobDetailsScreenProvider.groupDetailModel == null
                      ? EmptyScreen()
                      : SafeArea(
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onPanDown: (_) {
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                            child: CustomScrollView(
                              slivers: [
                                SliverList(
                                  delegate: SliverChildListDelegate([
                                    GroupJobDetailHeadScreen(
                                        groupJobDetailsScreenProvider
                                            .groupDetailModel)
                                  ]),
                                ),
                                GroupTabController(widget.groupId)
                              ],
                            ),
                          ),
                        ));
            },
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
    removeScreenName(widget);
  }
}

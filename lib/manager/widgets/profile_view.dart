import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';
import 'package:workflow_manager/base/utils/base_sharepreference.dart';
import 'package:workflow_manager/manager/models/events/update_image_event.dart';
import 'package:workflow_manager/workflow/models/response/login_response.dart';

import '../../main.dart';

class ProfileView extends StatefulWidget {

  ProfileView() : super(key: GlobalKey()) {
    if ((key as GlobalKey).currentState != null) {
      ((key as GlobalKey).currentState as _ProfileViewState).getProfile();
    }
  }

  @override
  State<StatefulWidget> createState() {
    return _ProfileViewState();
  }
}

class _ProfileViewState extends State<ProfileView> {
  User _user;

  String root;

  @override
  void initState() {
    super.initState();
    getRootUrl();
    getProfile();
    // eventBus.on<UpdateProfileEvent>().listen((event) {
    //   getProfile();
    // });
  }

  void getProfile() async {
    User user = await SharedPreferencesClass.getUser();
    setState(() {
      _user = user;
    });
  }

  getRootUrl() async {
    root = await SharedPreferencesClass.get(SharedPreferencesClass.ROOT_KEY);
  }

  @override
  Widget build(BuildContext context) {
    getProfile();
    return SafeArea(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 66,
              height: 66,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: Padding(
                padding: EdgeInsets.all(2),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(_user?.avatar ?? ""),
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  "Xin chào",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
            Padding(
                padding: EdgeInsets.only(left: 16,top: 8, right: 16),
                child: Text(
                  _user?.name ?? "'",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                )),
            Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  _user?.email ?? "",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                )),
          ],
        ),
      ),
    );
  }
}

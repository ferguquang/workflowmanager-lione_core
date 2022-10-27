import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';

class DrawbleScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DrawbleState();
  }
}

class DrawbleState extends State<DrawbleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _headerWidget(),
            _builderWidget(0, Icons.folder_sharp, 'Kho dữ liệu'),
            _builderWidget(1, Icons.person, 'Tài liệu cá nhân'),
            _builderWidget(2, Icons.group, 'Tài liệu được chia sẻ cho tôi'),
            _builderWidget(3, Icons.access_time_rounded, 'Gần đây'),
            _builderWidget(4, Icons.star, 'Tài liệu đã ghim'),
            _builderWidget(5, Icons.notifications, 'Thông báo'),
            _builderWidget(6, Icons.help, 'Trợ giúp'),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            _builderWidget(7, Icons.home, 'Trở về trang chính'),
            _builderWidget(8, Icons.subdirectory_arrow_right, 'Đăng xuất'),
          ],
        ),
      ),
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/icon_cover.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 66,
            height: 66,
            child: CircleNetworkImage(
                url:
                    'https://www.talkwalker.com/images/2020/blog-headers/image-analysis.png' ??
                        ""),
          ),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Text(
              'name',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            iconSize: 30,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget _builderWidget(position, icon, text) {
    return InkWell(
      onTap: () {
        switch (position) {
          case 0:
            break;

          case 1:
            break;

          case 2:
            break;

          case 3:
            break;

          case 4:
            break;

          case 5:
            break;

          case 6:
            break;

          case 7:
            break;

          case 8:
            break;

          case 9:
            break;

          case 10:
            break;
        }
        Navigator.of(context).pop();
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24,
              color: Colors.black,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}

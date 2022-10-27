import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';

class ChangeStatusPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return showNow(context);
  }

  //  customdialog
  showNow(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Scaffold(
          backgroundColor: Colors.black45,
          body: Center(
            child: Wrap(
              children: [
                Container(
                  margin: EdgeInsets.all(20),
                  alignment: Alignment.center,
                  // width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Chuyển trạng thái công việc".toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        decoration: TextDecoration.none),
                                  )),
                                  Container(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.clear_sharp,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                "Bạn phải bổ sung thông tin công việc để chuyển công việc Chưa xác định sang trạng thái khác",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    decoration: TextDecoration.none),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                    labelText: 'Ngày kết thúc',
                                    suffixIcon: Icon(
                                      Icons.date_range,
                                      size: 20,
                                    )),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                    labelText: 'Người nhận vi.ệc',
                                    suffixIcon: Icon(
                                      Icons.arrow_drop_down_rounded,
                                      size: 30,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                child: FlatButton(
                                  child: Text(
                                    "Đóng".toUpperCase(),
                                    style: TextStyle(
                                        color: "555555".toColor(),
                                        fontSize: 14),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                decoration: BoxDecoration(
                                  color: "E9ECEF".toColor(),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10)),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 50,
                                child: FlatButton(
                                  child: Text(
                                    "Chuyển trạng thái".toUpperCase(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  onPressed: () {
                                    Navigator.of(buildContext).pop();
                                  },
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}

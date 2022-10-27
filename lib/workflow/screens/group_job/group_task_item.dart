import 'package:flutter/material.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/response/list_group_task_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/list_column_group_tab_screen.dart';

class GroupTaskItem extends StatelessWidget {
  GroupTask groupTask;
  int position;

  void Function(GroupTask, int) onUpdate;

  GroupTaskItem({@required this.groupTask, this.position, this.onUpdate});
  BuildContext context;

  @override
  Widget build(BuildContext _context) {
    this.context = _context;
    return _buildItemGroupJob();
  }

  Widget _buildItemGroupJob() {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: groupTask.isShowFunction,
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: InkWell(
                  onTap: () {
                    onUpdate(groupTask, position);
                  },
                  child: SizedBox(
                    child: groupTask.isSelected
                        ? Icon(Icons.check_circle_outline,
                            color: groupTask.isSelected
                                ? Colors.blue
                                : Colors.grey,
                            size: 24)
                        : SizedBox(
                            width: 24,
                            height: 24,
                            child:
                                Image.asset('assets/images/icon_circle.png')),
                  )),
            ),
          ),
          // Image.asset("assets/images/ic_group_item.png"),
          SVGImage(svgName: 'group-item'),
          // Icon(Icons.list, color: Colors.blue,),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  groupTask.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 4, bottom: 4),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            size: 20,
                            color: Colors.grey,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 7),
                          ),
                          Text(
                            '${getDate(groupTask?.startDate)} - ${getDate(groupTask?.endDate)}',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: SVGImage(svgName: "create-by"),
                            // child: Image.asset('assets/images/ic_create_by.png'),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                          ),
                          Expanded(
                            child: Text(
                              groupTask?.createdName,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.group_outlined,
                          size: 20,
                          color: Colors.grey,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 7),
                        ),
                        Text(
                          '${groupTask?.totalMember} thành viên',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.work_outline_rounded,
                          color: Colors.grey,
                          size: 20,
                        ),
                        Expanded(
                          child: RichText(
                              text: TextSpan(
                                  text: '  Công việc quá hạn: ',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                  children: [
                                TextSpan(
                                    text: '${groupTask?.totalJobExpires}',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold)),
                              ])),
                        ),
                        InkWell(
                          onTap: () {
                            // truyền là 12 do đây là trạng thái quá hạn
                            pushPage(
                                this.context,
                                ListColumnGroupTabScreen(
                                  idGroup: groupTask?.iD,
                                  nameGroupJob: groupTask?.name,
                                  idStatus: 12,
                                ));
                          },
                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Text('Xem',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.blue,
                                    color: Colors.blue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

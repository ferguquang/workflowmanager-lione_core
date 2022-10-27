import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/circle_network_image.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/ui/toast_view.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/businessManagement/model/response/detail_management_response.dart';

import 'comments_opportunity_repository.dart';

// hoạt động dùng chung cho cơ hội và hợp đồng
class CommentsOpportunityScreen extends StatefulWidget {
  List<Comments> comments;
  bool isOnlyView;
  int idOpportunity;
  bool isOpportunityAndContract; // cơ hội: true, hợp đồng false
  String avatar;
  String root;
  bool isComment;
  CommentsOpportunityScreen(this.comments, this.isOnlyView, this.idOpportunity,
      this.isOpportunityAndContract, this.isComment,
      {this.avatar, this.root});

  @override
  _CommentsOpportunityScreenState createState() =>
      _CommentsOpportunityScreenState();
}

class _CommentsOpportunityScreenState extends State<CommentsOpportunityScreen> {
  var nameController = TextEditingController();
  CommentsOpportunityRepository _repository = CommentsOpportunityRepository();
  List<Comments> listData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listData = widget.comments;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _repository,
      child: Consumer(
        builder: (context, CommentsOpportunityRepository __repository1, child) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: isNullOrEmpty(listData)
                        ? EmptyScreen()
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: listData?.length ?? 0,
                            itemBuilder: (context, index) {
                              Comments item = listData[index];
                              return _itemComments(item);
                            },
                            separatorBuilder: (context, index) {
                              return Divider();
                            },
                          ),
                  ),
                  _itemChat(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _itemChat() {
    return Visibility(
      // visible: widget.isComment ?? false,
      visible: !widget.isOnlyView ? widget.isComment ?? false : false,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleNetworkImage(
                  height: 48, width: 48, url: widget.avatar ?? ''),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(width: 0.5, color: Colors.grey)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        maxLines: null,
                        controller: nameController,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _eventCallBackApiAddComment();
                      },
                      icon: Icon(
                        Icons.send,
                        color: Colors.blue,
                        size: 20,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemComments(Comments item) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CircleNetworkImage(
                height: 48, width: 48, url: '${item?.user?.avatar}' ?? ''),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item?.user?.name,
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Text(item?.body,
                    style: TextStyle(
                      color: Colors.black,
                    )),
                Row(
                  children: [
                    Text(
                      '${convertTimeStampToHumanDate(item?.created, Constant.ddMMyyyyHHmm2)}   ' ??
                          '',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          nameController.text = "@${item?.user?.name} ";
                        });
                      },
                      child: Text('Trả lời',
                          style: TextStyle(
                            color: Colors.blue,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
          Visibility(
            visible: !widget.isOnlyView && item?.isDelete ?? false,
            child: IconButton(
              onPressed: () {
                if (!widget.isOnlyView && item.isDelete) {
                  _eventCallBackApiDeleteComment(item);
                }
              },
              icon: Icon(
                Icons.clear,
                size: 16,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  _eventCallBackApiDeleteComment(Comments item) {
    ConfirmDialogFunction(
        content: 'Bạn có muốn xóa bình luận không?',
        context: context,
        onAccept: () async {
          bool status = await _repository.getDeleteCommentsOpportunity(
              item?.iD, widget.isOpportunityAndContract);
          if (status) {
            setState(() {
              listData?.remove(item);
            });
          }
        }).showConfirmDialog();
  }

  _eventCallBackApiAddComment() async {
    if (nameController.text.length == 0) {
      ToastMessage.show('Nội dung $textNotLeftBlank', ToastStyle.error);
      return;
    }

    Comments model = await _repository.getAddCommentsOpportunity(
        widget.idOpportunity,
        nameController.text,
        widget.isOpportunityAndContract);
    if (model != null) {
      setState(() {
        model.user?.avatar = "${widget.root}${model.user?.avatar}";
        listData?.add(model);
        nameController = TextEditingController();
        FocusScope.of(context).unfocus();
      });
    }
  }
}

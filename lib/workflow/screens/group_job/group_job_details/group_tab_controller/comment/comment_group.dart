import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/response/list_comment_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_tab_controller/comment/comment_group_item.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_details/group_tab_controller/comment/comment_group_repository.dart';

class CommentGroupWidget extends StatefulWidget {
  int taskId;

  CommentGroupWidget(this.taskId);

  @override
  _CommentGroupWidgetState createState() => _CommentGroupWidgetState();
}

class _CommentGroupWidgetState extends State<CommentGroupWidget> {
  TextEditingController contentCommentController = TextEditingController();
  CommentGroupRepository commentRepository = CommentGroupRepository();
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _getListComment();
  }

  ListView _commentListView(data) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      controller: _controller,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return CommentGroupItem(
          commentParent: data[index],
          position: index,
          onLikeOrDislike: (Comment comment, int position) {
            commentRepository.likeOrDislikeComment(comment, position);
          },
          onLikeOrDislikeCommentChildren: (Comment comment, int position,
              CommentChildren commentChildren, int positionChildren) {
            commentRepository.likeOrDislikeCommentChildren(
                comment, position, commentChildren, positionChildren);
          },
          onDeleteComment: (Comment comment) {
            commentRepository.deleteComment(comment);
          },
          onDeleteCommentChildren:
              (int positionParent, CommentChildren commentChildren) {
            commentRepository.deleteCommentChildren(
                commentChildren, positionParent);
          },
          onAddCommentChildren:
              (int positionParent, Map<String, dynamic> params) {
            commentRepository.addCommentChildren(positionParent, params);
          },
          onUploadFileChildren: (int positionParent) {
            commentRepository.uploadFileChildren(context, positionParent);
          },
          onDeleteUploadfileChildren: (int positionParent) {
            commentRepository.clearFileChildren(positionParent);
          },
          // onExpand: (Comment comment, int position) {
          //   commentRepository.expandComment(comment, position);
          // },
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Future<void> _getListComment() async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['IDGroupJob'] = widget.taskId;
    commentRepository.getListComment(params);
  }

  void addComment() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['FileName'] = commentRepository.uploadModel == null
        ? ''
        : commentRepository.uploadModel.fileName;
    params['FilePath'] = commentRepository.uploadModel == null
        ? ''
        : commentRepository.uploadModel.filePath;
    params['Parent'] = '0';
    params['IDGroupJob'] = widget.taskId;
    params['Body'] = contentCommentController.text;

    commentRepository.addComment(params);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (BuildContext context) {
      return commentRepository;
    }, child: Consumer(
      builder: (BuildContext context, CommentGroupRepository repository,
          Widget child) {
        return Column(
          children: [
            Expanded(
              child: repository.list.length == 0
                  ? EmptyScreen()
                  : ListView(
                      children: [
                        _commentListView(repository.list),
                      ],
                    ),
            ),
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: IconButton(
                          icon: Icon(
                            Icons.add_circle_outline_outlined,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            commentRepository.uploadFile(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          width: 4,
                          child: TextField(
                            // textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            controller: contentCommentController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: 'Nhập bình luận',
                              fillColor: Colors.black26,
                              hintStyle: TextStyle(color: Colors.black26),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.send_outlined,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            if (isNullOrEmpty(contentCommentController.text))
                              return;
                            // FocusScope.of(context).unfocus();
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            addComment();

                            Timer(Duration(milliseconds: 300), () {
                              _controller
                                  .jumpTo(_controller.position.maxScrollExtent);
                              contentCommentController.text = '';
                              commentRepository.clearFile();
                            });
                          })
                    ],
                  ),
                  Visibility(
                    visible: repository.uploadModel == null ? false : true,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Row(
                              children: [
                                Icon(Icons.assignment, color: Colors.blue),
                                Expanded(
                                  child: Text(repository.uploadModel != null
                                      ? '${repository.uploadModel.fileName}'
                                      : ''),
                                )
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey,
                              size: 16,
                            ),
                            onPressed: () {
                              commentRepository.clearFile();
                            })
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    ));
  }
}

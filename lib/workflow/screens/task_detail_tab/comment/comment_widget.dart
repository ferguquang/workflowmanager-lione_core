import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workflow_manager/base/ui/empty_screen.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/workflow/models/response/list_comment_response.dart';
import 'package:workflow_manager/workflow/screens/task_detail_tab/comment/comment_repository.dart';

import 'comment_item.dart';

class CommentWidget extends StatefulWidget {
  int taskId;

  CommentWidget(this.taskId);

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  TextEditingController contentCommentController = TextEditingController();
  CommentRepository commentRepository = CommentRepository();
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _getListComment();
  }

  ListView _commentListView(data) {
    return ListView.separated(
      shrinkWrap: true,
      controller: _controller,
      itemCount: data.length,
      itemBuilder: (context, index) {
        return CommentItem(
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
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Future<void> _getListComment() async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['IDJob'] = widget.taskId;
    commentRepository.getListComment(params);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (BuildContext context) {
      return commentRepository;
    }, child: Consumer(
      builder:
          (BuildContext context, CommentRepository repository, Widget child) {
        return Column(
          children: [
            Expanded(
              child: repository.list.length == 0
                  ? EmptyScreen()
                  : _commentListView(repository.list),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 16),
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
                            // keyboardType: TextInputType.multiline,
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
                            Map<String, dynamic> params =
                                new Map<String, dynamic>();
                            params['FileName'] = repository.uploadModel == null
                                ? ''
                                : repository.uploadModel.fileName;
                            params['FilePath'] = repository.uploadModel == null
                                ? ''
                                : repository.uploadModel.filePath;
                            params['Parent'] = '0';
                            params['IDJob'] = widget.taskId;
                            params['Body'] = contentCommentController.text;

                            commentRepository.addComment(params);

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
                  ),
                ],
              ),
            )
          ],
        );
      },
    ));
  }
}

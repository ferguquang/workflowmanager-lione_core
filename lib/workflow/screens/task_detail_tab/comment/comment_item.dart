import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workflow_manager/base/extension/string.dart';
import 'package:workflow_manager/base/ui/confirm_dialog_widget.dart';
import 'package:workflow_manager/base/ui/svg_image.dart';
import 'package:workflow_manager/base/utils/app_constant.dart';
import 'package:workflow_manager/base/utils/common_function.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/workflow/models/response/list_comment_response.dart';

class CommentItem extends StatelessWidget {
  Comment commentParent;
  int position;
  TextEditingController contentCommentController = TextEditingController();
  FocusNode _focus = new FocusNode();

  void Function(Comment, int) onLikeOrDislike;
  void Function(Comment, int, CommentChildren, int)
      onLikeOrDislikeCommentChildren;
  void Function(Comment) onDeleteComment;
  void Function(int, CommentChildren) onDeleteCommentChildren;
  void Function(int, Map<String, dynamic>) onAddCommentChildren;
  void Function(int) onUploadFileChildren;
  void Function(int) onDeleteUploadfileChildren;

  CommentItem(
      {this.commentParent,
      this.position,
      this.onLikeOrDislike,
      this.onLikeOrDislikeCommentChildren,
      this.onDeleteComment,
      this.onDeleteCommentChildren,
      this.onAddCommentChildren,
      this.onUploadFileChildren,
      this.onDeleteUploadfileChildren});

  Widget placeHolder() {
    return Container(height: 32, width: 32, child: SVGImage(svgName: "user"));
  }

  @override
  Widget build(BuildContext context) {
    contentCommentController.text = commentParent.textInput;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 4, 16, 4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: CachedNetworkImage(
                  placeholder: (context, url) {
                    return placeHolder();
                  },
                  imageUrl: commentParent.avatarUrl,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 4, bottom: 4),
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: commentParent?.userName ?? '',
                                style: TextStyle(color: Colors.blue),
                              ),
                              TextSpan(
                                text:
                                    ('   ${commentParent?.created?.toDateTimeFormat(format: Constant.ddMMyyyyHHmm)}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isNotNullOrEmpty(commentParent.body),
                        child: Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: "#E9ECEF".toColor(),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0.0),
                                  topRight: Radius.circular(4.0),
                                  bottomLeft: Radius.circular(4.0),
                                  bottomRight: Radius.circular(4.0))),
                          child: Text(commentParent.body),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  onLikeOrDislike(commentParent, position);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                        !commentParent.isLike
                                            ? 'Thích'
                                            : 'Bỏ thích',
                                        style: TextStyle(
                                            color: commentParent.isLike
                                                ? Colors.blue
                                                : Colors.black)),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                          commentParent.listJobDiscussLike !=
                                                  null
                                              ? '${commentParent.listJobDiscussLike.length}'
                                              : '0',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                      height: 16,
                                      width: 16,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                              ),
                              InkWell(
                                onTap: () {
                                  String repValue =
                                      '${commentParent.userName} ';
                                  contentCommentController.text = repValue;
                                  contentCommentController.selection =
                                      TextSelection.collapsed(
                                          offset: repValue.length);
                                  FocusScope.of(context).requestFocus(_focus);
                                },
                                child: Text('Trả lời',
                                    style: TextStyle(color: Colors.black)),
                              ),
                              Visibility(
                                visible: commentParent.canDelete,
                                child: InkWell(
                                  onTap: () {
                                    ConfirmDialogFunction(
                                        content:
                                            'Bạn có muốn xóa bình luận này không?',
                                        context: context,
                                        onAccept: () {
                                          onDeleteComment(commentParent);
                                        }).showConfirmDialog();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Xóa'),
                                  ),
                                ),
                              )
                            ],
                          )),
                      Visibility(
                        visible: commentParent.jobDiscussFile == null ||
                                commentParent.jobDiscussFile.fileName == null
                            ? false
                            : true,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  if (commentParent.jobDiscussFile != null) {
                                    FileUtils.instance.downloadFileAndOpen(
                                        commentParent.jobDiscussFile.fileName,
                                        commentParent.jobDiscussFile.filePath,
                                        context);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.assignment, color: Colors.blue),
                                    Expanded(
                                      child: Text(commentParent
                                                  .jobDiscussFile !=
                                              null
                                          ? '${commentParent.jobDiscussFile.fileName}'
                                          : ''),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Visibility(
                            child: Visibility(
                                visible: commentParent.listChildren == null ||
                                        commentParent.listChildren.length == 0
                                    ? false
                                    : true,
                                child: _childCommentListView(
                                    commentParent.listChildren,
                                    position,
                                    context)),
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
                                          onUploadFileChildren(position);
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
                                          onChanged: (text) {
                                            commentParent.textInput = text;
                                          },
                                          focusNode: _focus,
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(
                                            hintText: 'Nhập trả lời',
                                            fillColor: Colors.black26,
                                            hintStyle: TextStyle(
                                                color: Colors.black26),
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
                                          if (isNullOrEmpty(
                                              contentCommentController.text))
                                            return;
                                          FocusScope.of(context).unfocus();
                                          Map<String, dynamic> params =
                                              new Map<String, dynamic>();
                                          params['FileName'] =
                                              commentParent.uploadModel != null
                                                  ? commentParent
                                                      .uploadModel.fileName
                                                  : '';
                                          params['FilePath'] =
                                              commentParent.uploadModel != null
                                                  ? commentParent
                                                      .uploadModel.filePath
                                                  : '';
                                          params['Parent'] = commentParent.iD;
                                          params['IDJob'] = commentParent.iDJob;
                                          params['Body'] =
                                              contentCommentController.text;
                                          onAddCommentChildren(
                                              position, params);
                                          contentCommentController.text = '';
                                          commentParent.textInput = '';
                                        })
                                  ],
                                ),
                                Visibility(
                                  visible: commentParent.uploadModel == null
                                      ? false
                                      : true,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            FileUtils.instance
                                                .downloadFileAndOpen(
                                                    commentParent.jobDiscussFile
                                                        .fileName,
                                                    commentParent.jobDiscussFile
                                                        .filePath,
                                                    context);
                                          },
                                          child: Row(
                                            children: [
                                              Icon(Icons.assignment,
                                                  color: Colors.blue),
                                              Expanded(
                                                child: Text(commentParent
                                                            .uploadModel !=
                                                        null
                                                    ? '${commentParent.uploadModel.fileName}'
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
                                            onDeleteUploadfileChildren(
                                                position);
                                          })
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // list con
  ListView _childCommentListView(List<CommentChildren> listData,
      int positionParent, BuildContext context) {
    return ListView.separated(
      // inner ListView
      shrinkWrap: true, // 1st add
      physics: ClampingScrollPhysics(), // 2nd add
      itemCount: listData.length,
      itemBuilder: (_, positionChildren) {
        if (listData == null || listData.length == 0) {
          return SizedBox();
        }
        CommentChildren commentChildren = listData[positionChildren];
        return Container(
          child: Row(
            children: [
              CachedNetworkImage(
                placeholder: (context, url) => placeHolder(),
                imageUrl: commentChildren.avatarUrl,
                imageBuilder: (context, imageProvider) {
                  return Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 8, bottom: 8),
                        child: RichText(
                          text: TextSpan(
                            text: '',
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                text: commentChildren.userName ?? '',
                                style: TextStyle(color: Colors.blue),
                              ),
                              TextSpan(
                                text:
                                    ('   ${commentChildren.created.toDateTimeFormat(format: Constant.ddMMyyyyHHmm)}'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isNotNullOrEmpty(commentChildren.body),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: "#E9ECEF".toColor(),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0.0),
                                  topRight: Radius.circular(4.0),
                                  bottomLeft: Radius.circular(4.0),
                                  bottomRight: Radius.circular(4.0))),
                          child: Text(commentChildren.body),
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  onLikeOrDislikeCommentChildren(
                                      commentParent,
                                      position,
                                      commentChildren,
                                      positionChildren);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                        !commentChildren.isLike
                                            ? 'Thích'
                                            : 'Bỏ thích',
                                        style: TextStyle(
                                            color: commentChildren.isLike
                                                ? Colors.blue
                                                : Colors.black)),
                                    Padding(
                                      padding: EdgeInsets.all(4),
                                    ),
                                    // đây chỉ là khoảng trắng thôi
                                    Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                          '${commentChildren.listJobDiscussLike.length}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12)),
                                      height: 16,
                                      width: 16,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.blue),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8),
                              ),
                              InkWell(
                                onTap: () {
                                  String repValue =
                                      '${commentChildren.userName} ';
                                  contentCommentController.text = repValue;
                                  contentCommentController.selection =
                                      TextSelection.collapsed(
                                          offset: repValue.length);
                                  FocusScope.of(context).requestFocus(_focus);
                                },
                                child: Text('Trả lời',
                                    style: TextStyle(color: Colors.black)),
                              ),
                              Visibility(
                                visible: commentChildren.canDelete,
                                child: InkWell(
                                  onTap: () {
                                    ConfirmDialogFunction(
                                        content:
                                            'Bạn có muốn xóa bình luận này không?',
                                        context: context,
                                        onAccept: () {
                                          // onDeleteComment(commentChildren);
                                          onDeleteCommentChildren(
                                              positionParent, commentChildren);
                                        }).showConfirmDialog();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Text('Xóa'),
                                  ),
                                ),
                              )
                            ],
                          )),
                      Visibility(
                        visible: commentChildren.jobDiscussFile == null ||
                                commentChildren.jobDiscussFile.fileName == null
                            ? false
                            : true,
                        child: Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  if (commentChildren.jobDiscussFile != null) {
                                    FileUtils.instance.downloadFileAndOpen(
                                        commentChildren.jobDiscussFile.fileName,
                                        commentChildren.jobDiscussFile.filePath,
                                        context);
                                  }
                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.assignment, color: Colors.blue),
                                    Expanded(
                                      child: Text(commentChildren
                                                  .jobDiscussFile !=
                                              null
                                          ? '${commentChildren.jobDiscussFile.fileName}'
                                          : ''),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}

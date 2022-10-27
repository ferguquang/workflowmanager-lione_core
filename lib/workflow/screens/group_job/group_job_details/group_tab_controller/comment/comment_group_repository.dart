import 'package:flutter/material.dart';
import 'package:workflow_manager/base/network/api_caller.dart';
import 'package:workflow_manager/base/network/app_url.dart';
import 'package:workflow_manager/base/utils/file_utils.dart';
import 'package:workflow_manager/workflow/models/response/list_comment_response.dart';
import 'package:workflow_manager/workflow/models/response/message_response.dart';
import 'package:workflow_manager/workflow/models/response/upload_response.dart';

class CommentGroupRepository with ChangeNotifier {
  ApiCaller apiCaller = ApiCaller.instance;

  List<Comment> _list = [];
  UploadModel _uploadModel;

  List<Comment> get list => _list;

  UploadModel get uploadModel => _uploadModel;

  Future<void> getListComment(Map<String, dynamic> params) async {
    final responseJSON =
        await apiCaller.get(AppUrl.groupGetListDiscuss, params: params);
    DiscussResponse responseJobHistory = DiscussResponse.fromJson(responseJSON);
    if (responseJobHistory.isSuccess()) {
      _list = responseJobHistory.data;
      notifyListeners();
    }
  }

  Future<void> addComment(Map<String, dynamic> params) async {
    final responseJSON =
        await apiCaller.postFormData(AppUrl.groupAddDiscuss, params);
    ResponseAddComment response = ResponseAddComment.fromJson(responseJSON);
    Comment comment = response.data;
    list.insert(list.length, comment);
    notifyListeners();
  }

  Future<void> addCommentChildren(
      int positionParent, Map<String, dynamic> params) async {
    final responseJSON =
        await apiCaller.postFormData(AppUrl.groupAddDiscuss, params);
    ResponseAddCommentChildren response =
        ResponseAddCommentChildren.fromJson(responseJSON);
    CommentChildren commentChildren = response.data;
    list[positionParent]
        .listChildren
        .insert(list[positionParent].listChildren.length, commentChildren);
    list[positionParent].uploadModel = null;
    notifyListeners();
  }

  Future<void> clearFile() async {
    _uploadModel = null;
    notifyListeners();
  }

  Future<void> clearFileChildren(int positionParent) async {
    list[positionParent].uploadModel = null;
    notifyListeners();
  }

  Future<void> uploadFile(BuildContext context) async {
    var file = await FileUtils.instance.uploadFileFromSdcard(context);
    if (file != null) {
      _uploadModel = file;
      notifyListeners();
    }
  }

  Future<void> uploadFileChildren(
      BuildContext context, int positionParent) async {
    var file = await FileUtils.instance.uploadFileFromSdcard(context);
    if (file != null) {
      list[positionParent].uploadModel = file;
      notifyListeners();
    }
  }

  Future<void> deleteComment(Comment comment) async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['ID'] = comment.iD;
    final responseJSON =
        await apiCaller.delete(AppUrl.groupDeleteDiscuss, params);
    MessageResponse response = MessageResponse.fromJson(responseJSON);
    if (response.booleanValue) {
      list.removeWhere((item) => item.iD == comment.iD);
      notifyListeners();
    }
  }

  Future<void> deleteCommentChildren(
      CommentChildren comment, int positionParent) async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['ID'] = comment.iD;
    final responseJSON =
        await apiCaller.delete(AppUrl.groupDeleteDiscuss, params);
    MessageResponse response = MessageResponse.fromJson(responseJSON);
    if (response.booleanValue) {
      list[positionParent]
          .listChildren
          .removeWhere((element) => element.iD == comment.iD);
      notifyListeners();
    }
  }

  void expandComment(Comment comment, int position) {
    comment.isExpand = !comment.isExpand;
    list[list.indexWhere((element) => element.iD == comment.iD)] = comment;
    notifyListeners();
  }

  Future<void> likeOrDislikeComment(Comment comment, int position) async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['IDGroupJobDiscuss'] = comment.iD;
    params['IDGroupJob'] = comment.idGroupJob;
    params['IsLike'] = !comment.isLike;

    final responseJSON =
        await apiCaller.postFormData(AppUrl.groupLikeOrDislike, params);
    MessageResponse responseMessage = MessageResponse.fromJson(responseJSON);
    if (responseMessage.booleanValue) {
      comment.isLike = !comment.isLike;
      list[list.indexWhere((element) => element.iD == comment.iD)] = comment;

      // cập nhật số lượng like của comment:
      if (comment.isLike) {
        list[position].listGroupJobDiscussLike.add(new ListJobDiscussLike());
      } else {
        if (list[position].listGroupJobDiscussLike.length > 0) {
          list[position].listGroupJobDiscussLike.removeAt(0);
        }
      }

      notifyListeners();
    }
  }

  Future<void> likeOrDislikeCommentChildren(Comment comment, int position,
      CommentChildren commentChildren, int positionChildren) async {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params['IDGroupJobDiscuss'] = commentChildren.iD;
    params['IDGroupJob'] = commentChildren.idGroupJob;
    params['IsLike'] = !commentChildren.isLike;

    final responseJSON =
        await apiCaller.postFormData(AppUrl.groupLikeOrDislike, params);
    MessageResponse responseMessage = MessageResponse.fromJson(responseJSON);
    if (responseMessage.booleanValue) {
      commentChildren.isLike = !commentChildren.isLike;
      list[position].listChildren[list[position]
              .listChildren
              .indexWhere((element) => element.iD == commentChildren.iD)] =
          commentChildren;

      if (commentChildren.isLike) {
        list[position]
            .listChildren[positionChildren]
            .listGroupJobDiscussLike
            .add(new ListJobDiscussLike());
      } else {
        list[position]
            .listChildren[positionChildren]
            .listGroupJobDiscussLike
            .removeAt(0);
      }

      notifyListeners();
    }
  }
}

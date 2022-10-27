import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/response/upload_response.dart';
import 'package:workflow_manager/workflow/models/message.dart';

class DiscussResponse extends BaseResponse {
  List<Comment> data;

  DiscussResponse.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    if (json['Data'] != null) {
      data = new List<Comment>();
      json['Data'].forEach((v) {
        data.add(new Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class Comment {
  String avatarUrl;
  int iD;
  int iDJob;
  int idGroupJob;
  String body;
  String created;
  int createdBy;
  int parent;
  String userName;
  List<ListJobDiscussLike> _listJobDiscussLike;
  List<ListJobDiscussLike> _listGroupJobDiscussLike;
  JobDiscussFile _jobDiscussFile;
  JobDiscussFile _groupJobDiscussFile;
  List<CommentChildren> _listChildren;
  bool isLike;
  bool canDelete;
  int iDChannel;
  UploadModel uploadModel;
  String textInput;

  bool isExpand = true;

  Comment(
      this.avatarUrl,
      this.iD,
      this.idGroupJob,
      this.iDJob,
      this.body,
      this.created,
      this.createdBy,
      this.parent,
      this.userName,
      this._listJobDiscussLike,
      this._listGroupJobDiscussLike,
      this._jobDiscussFile,
      this._groupJobDiscussFile,
      this._listChildren,
      this.isLike,
      this.canDelete,
      this.iDChannel,
      this.textInput,
      this.uploadModel,
      this.isExpand);

  List<CommentChildren> get listChildren {
    if (_listChildren == null) {
      _listChildren = [];
    }
    return _listChildren;
  }

  List<ListJobDiscussLike> get listGroupJobDiscussLike {
    if (_listGroupJobDiscussLike == null) {
      _listGroupJobDiscussLike = [];
    }
    return _listGroupJobDiscussLike;
  }

  List<ListJobDiscussLike> get listJobDiscussLike {
    if (_listJobDiscussLike == null) {
      _listJobDiscussLike = [];
    }
    return _listJobDiscussLike;
  }

  JobDiscussFile get jobDiscussFile {
    if (_jobDiscussFile == null) {
      _jobDiscussFile = JobDiscussFile();
    }
    return _jobDiscussFile;
  }

  JobDiscussFile get groupJobDiscussFile {
    if (_groupJobDiscussFile == null) {
      _groupJobDiscussFile = JobDiscussFile();
    }
    return _groupJobDiscussFile;
  }

  Comment.fromJson(Map<String, dynamic> json) {
    avatarUrl = json['AvatarUrl'];
    iD = json['ID'];
    iDJob = json['IDJob'];
    idGroupJob = json['IDGroupJob'];
    body = json['Body'];
    created = json['Created'];
    createdBy = json['CreatedBy'];
    parent = json['Parent'];
    userName = json['UserName'];
    if (json['ListJobDiscussLike'] != null) {
      _listJobDiscussLike = new List<ListJobDiscussLike>();
      json['ListJobDiscussLike'].forEach((v) {
        listJobDiscussLike.add(new ListJobDiscussLike.fromJson(v));
      });
    }
    if (json['ListGroupJobDiscussLike'] != null) {
      _listGroupJobDiscussLike = new List<ListJobDiscussLike>();
      json['ListGroupJobDiscussLike'].forEach((v) {
        _listGroupJobDiscussLike.add(new ListJobDiscussLike.fromJson(v));
      });
    }
    _jobDiscussFile = json['JobDiscussFile'] != null ? new JobDiscussFile.fromJson(json['JobDiscussFile']) : null;
    _groupJobDiscussFile = json['GroupJobDiscussFile'] != null ? new JobDiscussFile.fromJson(json['GroupJobDiscussFile']) : null;

    if (json['ListChildren'] != null) {
      _listChildren = new List<CommentChildren>();
      json['ListChildren'].forEach((v) {
        listChildren.add(new CommentChildren.fromJson(v));
      });
    }
    isLike = json['IsLike'];
    canDelete = json['CanDelete'];
    iDChannel = json['IDChannel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AvatarUrl'] = this.avatarUrl;
    data['ID'] = this.iD;
    data['IDJob'] = this.iDJob;
    data['IDGroupJob'] = this.idGroupJob;
    data['Body'] = this.body;
    data['Created'] = this.created;
    data['CreatedBy'] = this.createdBy;
    data['Parent'] = this.parent;
    data['UserName'] = this.userName;
    if (this.listJobDiscussLike != null) {
      data['ListJobDiscussLike'] =
          this.listJobDiscussLike.map((v) => v.toJson()).toList();
    }
    if (this.jobDiscussFile != null) {
      data['JobDiscussFile'] = this.jobDiscussFile.toJson();
    }
    if (this.groupJobDiscussFile != null) {
      data['GroupJobDiscussFile'] = this.groupJobDiscussFile.toJson();
    }
    if (this.listChildren != null) {
      data['ListChildren'] = this.listChildren.map((v) => v.toJson()).toList();
    }
    data['IsLike'] = this.isLike;
    data['IDChannel'] = this.iDChannel;
    return data;
  }
}

class ListJobDiscussLike {
  int iD;
  int iDChannel;
  int iDJobDiscuss;
  String created;
  int createdBy;

  ListJobDiscussLike(
      {this.iD,
        this.iDChannel,
        this.iDJobDiscuss,
        this.created,
        this.createdBy});

  ListJobDiscussLike.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDJobDiscuss = json['IDJobDiscuss'];
    created = json['Created'];
    createdBy = json['CreatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['IDJobDiscuss'] = this.iDJobDiscuss;
    data['Created'] = this.created;
    data['CreatedBy'] = this.createdBy;
    return data;
  }
}

class JobDiscussFile {
  int iD;
  int idGroupJobDiscuss;
  String fileName;
  String filePath;
  String created;
  int createdBy;

  JobDiscussFile(
      {this.iD, this.fileName, this.filePath, this.created, this.createdBy});

  JobDiscussFile.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    idGroupJobDiscuss = json['IDGroupJobDiscuss'];
    fileName = json['FileName'];
    filePath = json['FilePath'];
    created = json['Created'];
    createdBy = json['CreatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['FileName'] = this.fileName;
    data['FilePath'] = this.filePath;
    data['Created'] = this.created;
    data['CreatedBy'] = this.createdBy;
    return data;
  }
}

class CommentChildren {
  String avatarUrl;
  int iD;
  int idGroupJob;
  int iDChannel;
  int iDJob;
  String body;
  String created;
  int createdBy;
  int parent;
  String userName;
  List<ListJobDiscussLike> _listJobDiscussLike;
  List<ListJobDiscussLike> _listGroupJobDiscussLike;
  JobDiscussFile _jobDiscussFile;
  JobDiscussFile _groupJobDiscussFile;
  bool isLike;
  bool canDelete;

  CommentChildren(
      this.avatarUrl,
      this.iD,
      this.idGroupJob,
      this.iDChannel,
      this.iDJob,
      this.body,
      this.created,
      this.createdBy,
      this.parent,
      this.userName,
      this._listJobDiscussLike,
      this._listGroupJobDiscussLike,
      this._jobDiscussFile,
      this._groupJobDiscussFile,
      this.isLike,
      this.canDelete);


  List<ListJobDiscussLike> get listGroupJobDiscussLike {
    if (_listGroupJobDiscussLike == null) {
      _listGroupJobDiscussLike = [];
    }
    return _listGroupJobDiscussLike;
  }

  List<ListJobDiscussLike> get listJobDiscussLike {
    if (_listJobDiscussLike == null) {
      _listJobDiscussLike = [];
    }
    return _listJobDiscussLike;
  }

  JobDiscussFile get jobDiscussFile {
    if (_jobDiscussFile == null) {
      _jobDiscussFile = JobDiscussFile();
    }
    return _jobDiscussFile;
  }

  JobDiscussFile get groupJobDiscussFile {
    if (_groupJobDiscussFile == null) {
      _groupJobDiscussFile = JobDiscussFile();
    }
    return _groupJobDiscussFile;
  }

  CommentChildren.fromJson(Map<String, dynamic> json) {
    avatarUrl = json['AvatarUrl'];
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDJob = json['IDJob'];
    idGroupJob = json['IDGroupJob'];
    body = json['Body'];
    created = json['Created'];
    createdBy = json['CreatedBy'];
    parent = json['Parent'];
    userName = json['UserName'];
    if (json['ListJobDiscussLike'] != null) {
      _listJobDiscussLike = new List<ListJobDiscussLike>();
      json['ListJobDiscussLike'].forEach((v) {
        listJobDiscussLike.add(new ListJobDiscussLike.fromJson(v));
      });
    }
    if (json['ListGroupJobDiscussLike'] != null) {
      _listGroupJobDiscussLike = new List<ListJobDiscussLike>();
      json['ListGroupJobDiscussLike'].forEach((v) {
        _listGroupJobDiscussLike.add(new ListJobDiscussLike.fromJson(v));
      });
    }
    _jobDiscussFile = json['JobDiscussFile'] != null ? new JobDiscussFile.fromJson(json['JobDiscussFile']) : null;
    _groupJobDiscussFile = json['GroupJobDiscussFile'] != null ? new JobDiscussFile.fromJson(json['GroupJobDiscussFile']) : null;

    isLike = json['IsLike'];
    canDelete = json['CanDelete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AvatarUrl'] = this.avatarUrl;
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['IDJob'] = this.iDJob;
    data['Body'] = this.body;
    data['Created'] = this.created;
    data['CreatedBy'] = this.createdBy;
    data['Parent'] = this.parent;
    data['UserName'] = this.userName;
    if (this.listJobDiscussLike != null) {
      data['ListJobDiscussLike'] =
          this.listJobDiscussLike.map((v) => v.toJson()).toList();
    }
    data['JobDiscussFile'] = this.jobDiscussFile;

    data['IsLike'] = this.isLike;
    data['CanDelete'] = this.canDelete;
    return data;
  }
}

class ResponseAddComment {
  int status;
  Comment data;
  List<Message> messages;

  ResponseAddComment({this.status, this.data, this.messages});

  ResponseAddComment.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    data = json['Data'] != null ? new Comment.fromJson(json['Data']) : null;
    if (json['Messages'] != null) {
      messages = new List<Message>();
      json['Messages'].forEach((v) {
        messages.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseAddCommentChildren {
  int status;
  CommentChildren data;
  List<Message> messages;

  ResponseAddCommentChildren({this.status, this.data, this.messages});

  ResponseAddCommentChildren.fromJson(Map<String, dynamic> json) {
    status = json['Status'];
    data = json['Data'] != null ? new CommentChildren.fromJson(json['Data']) : null;
    if (json['Messages'] != null) {
      messages = new List<Message>();
      json['Messages'].forEach((v) {
        messages.add(new Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
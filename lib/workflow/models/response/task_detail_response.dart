import 'package:workflow_manager/base/models/base_response.dart';

class TaskDetailsResponse extends BaseResponse {
  TaskDetailModel data;

  TaskDetailsResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new TaskDetailModel.fromJson(json['Data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    if (this.messages != null) {
      data['Messages'] = this.messages;
    }
    return data;
  }
}

class TaskDetailModel {
  int totalJobFile;
  String priority;
  JobGroup jobGroup;
  String assigner;
  String executer;
  String supervisor;
  String coExecuter;
  List<String> coExcuters;
  List<String> supervisors;
  List<int> idCOExcuters;
  List<int> idSupervisors;
  Job job;
  List<ListDiscussAPI> listDiscussAPI;
  JobExtension jobExtension;
  JobStatus jobStatus;
  int totalChildrenJob;
  int totalJobDetail;
  bool isExistJobExtension;
  String kanbanName;
  bool isDelete;
  bool isSave;
  bool isEdit;
  int viewType;
  int role;
  String urlJobFlow;

  TaskDetailModel(
      {this.totalJobFile,
      this.priority,
      this.jobGroup,
      this.assigner,
      this.executer,
      this.supervisor,
      this.coExecuter,
      this.job,
      this.listDiscussAPI,
      this.jobExtension,
    this.jobStatus,
    this.totalChildrenJob,
    this.totalJobDetail,
    this.isExistJobExtension,
    this.kanbanName,
    this.isDelete,
    this.isSave,
    this.isEdit,
    this.viewType,
    this.role,
    this.urlJobFlow,
    this.coExcuters,
    this.supervisors});

  TaskDetailModel.fromJson(Map<String, dynamic> json) {
    totalJobFile = json['TotalJobFile'];
    priority = json['Priority'];
    jobGroup = json['JobGroup'] != null
        ? new JobGroup.fromJson(json['JobGroup'])
        : null;
    assigner = json['Assigner'];
    executer = json['Executer'];
    supervisor = json['Supervisor'];
    urlJobFlow = json['UrlJobFlow'];
    // supervisor = json['Supervisor'];
    coExecuter = json['CoExecuter'];
    viewType = json['ViewType'];
    job = json['Job'] != null ? new Job.fromJson(json['Job']) : null;
    if (json['ListDiscussAPI'] != null) {
      listDiscussAPI = new List<ListDiscussAPI>();
      json['ListDiscussAPI'].forEach((v) {
        listDiscussAPI.add(new ListDiscussAPI.fromJson(v));
      });
    }
    if (json['Supervisors'] != null) {
      supervisors = new List<String>();
      json['Supervisors'].forEach((v) {
        supervisors.add(v);
      });
    }
    if (json['CoExecuters'] != null) {
      coExcuters = new List<String>();
      json['CoExecuters'].forEach((v) {
        coExcuters.add(v);
      });
    }
    if (json['IDSupervisors'] != null) {
      idSupervisors = new List<int>();
      json['IDSupervisors'].forEach((v) {
        idSupervisors.add(v);
      });
    }
    if (json['IDCoexecutors'] != null) {
      idCOExcuters = new List<int>();
      json['IDCoexecutors'].forEach((v) {
        idCOExcuters.add(v);
      });
    }
    jobExtension = json['JobExtension'] != null
        ? new JobExtension.fromJson(json['JobExtension'])
        : null;
    jobStatus = json['JobStatus'] != null
        ? new JobStatus.fromJson(json['JobStatus'])
        : null;
    totalChildrenJob = json['TotalChildrenJob'];
    totalJobDetail = json['TotalJobDetail'];
    isExistJobExtension = json['IsExistJobExtension'];
    kanbanName = json['KanbanName'];
    isDelete = json['IsDelete'];
    isSave = json['IsSave'];
    isEdit = json['IsEdit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TotalJobFile'] = this.totalJobFile;
    data['Priority'] = this.priority;
    if (this.jobGroup != null) {
      data['JobGroup'] = this.jobGroup.toJson();
    }
    data['Assigner'] = this.assigner;
    data['Executer'] = this.executer;
    data['Supervisor'] = this.supervisor;
    data['CoExecuter'] = this.coExecuter;
    data['UrlJobFlow'] = this.urlJobFlow;
    data['CoExecuters'] = this.coExcuters;
    data['Supervisors'] = this.supervisors;
    data['IDCoexecutors'] = this.idCOExcuters;
    data['IDSupervisors'] = this.idSupervisors;
    if (this.job != null) {
      data['Job'] = this.job.toJson();
    }
    if (this.listDiscussAPI != null) {
      data['ListDiscussAPI'] =
          this.listDiscussAPI.map((v) => v.toJson()).toList();
    }
    if (this.jobExtension != null) {
      data['JobExtension'] = this.jobExtension.toJson();
    }
    if (this.jobStatus != null) {
      data['JobStatus'] = this.jobStatus.toJson();
    }
    data['TotalChildrenJob'] = this.totalChildrenJob;
    data['TotalJobDetail'] = this.totalJobDetail;
    data['IsExistJobExtension'] = this.isExistJobExtension;
    data['KanbanName'] = this.kanbanName;
    data['ViewType'] = this.viewType;
    return data;
  }
}

class JobGroup {
  int iD;
  String name;

  JobGroup({this.iD, this.name});

  JobGroup.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    return data;
  }
}

class Job {
  int iD;
  int iDChannel;
  int iDJobFlow;
  int iDGroupJob;
  int iDExecutor;
  int type;
  String name;
  String describe;
  int priority;
  String created;
  int createdBy;
  String startDate;
  String endDate;
  String finished;
  String started;
  int status;
  double rating;
  int parent;
  double percentCompleted;
  bool isArchive;
  int iDGroupJobCol;
  bool isTemplate;
  bool isActive;
  int progressStatus;
  int iDCoexecutor;
  int iDSupervisor;

  Job({
    this.iD,
    this.iDChannel,
    this.iDJobFlow,
    this.iDGroupJob,
    this.iDExecutor,
    this.type,
    this.name,
    this.describe,
    this.priority,
    this.created,
    this.createdBy,
    this.startDate,
    this.endDate,
    this.finished,
    this.status,
    this.rating,
    this.parent,
    this.percentCompleted,
    this.isArchive,
    this.iDGroupJobCol,
    this.isTemplate,
    this.isActive,
    this.progressStatus,
    this.iDCoexecutor,
    this.iDSupervisor,
  });

  Job.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDJobFlow = json['IDJobFlow'];
    iDGroupJob = json['IDGroupJob'];
    iDExecutor = json['IDExecutor'];
    type = json['Type'];
    name = json['Name'];
    describe = json['Describe'];
    priority = json['Priority'];
    created = json['Created'];
    createdBy = json['CreatedBy'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    finished = json['Finished'];
    started = json['Started'];
    status = json['Status'];
    rating = json['Rating'];
    parent = json['Parent'];
    percentCompleted = json['PercentCompleted'];
    isArchive = json['IsArchive'];
    iDGroupJobCol = json['IDGroupJobCol'];
    isTemplate = json['IsTemplate'];
    isActive = json['IsActive'];
    progressStatus = json['ProgressStatus'];
    iDCoexecutor = json['IDCoexecutor'];
    iDSupervisor = json['IDSupervisor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Started'] = started;
    data['IDChannel'] = this.iDChannel;
    data['IDJobFlow'] = this.iDJobFlow;
    data['IDGroupJob'] = this.iDGroupJob;
    data['IDExecutor'] = this.iDExecutor;
    data['Type'] = this.type;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['Priority'] = this.priority;
    data['Created'] = this.created;
    data['CreatedBy'] = this.createdBy;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    data['Finished'] = this.finished;
    data['Status'] = this.status;
    data['Rating'] = this.rating;
    data['Parent'] = this.parent;
    data['PercentCompleted'] = this.percentCompleted;
    data['IsArchive'] = this.isArchive;
    data['IDGroupJobCol'] = this.iDGroupJobCol;
    data['IsTemplate'] = this.isTemplate;
    data['IsActive'] = this.isActive;
    data['ProgressStatus'] = this.progressStatus;
    data['IDCoexecutor'] = this.iDCoexecutor;
    data['IDSupervisor'] = this.iDSupervisor;
    return data;
  }
}

class ListDiscussAPI {
  List<ListDiscussLike> listDiscussLike;
  List<ListDiscussFile> listDiscussFile;
  List<JobDiscusses> jobDiscusses;

  ListDiscussAPI(
      {this.listDiscussLike, this.listDiscussFile, this.jobDiscusses});

  ListDiscussAPI.fromJson(Map<String, dynamic> json) {
    if (json['ListDiscussLike'] != null) {
      listDiscussLike = new List<ListDiscussLike>();
      json['ListDiscussLike'].forEach((v) {
        listDiscussLike.add(new ListDiscussLike.fromJson(v));
      });
    }
    if (json['ListDiscussFile'] != null) {
      listDiscussFile = new List<ListDiscussFile>();
      json['ListDiscussFile'].forEach((v) {
        listDiscussFile.add(new ListDiscussFile.fromJson(v));
      });
    }
    if (json['JobDiscusses'] != null) {
      jobDiscusses = new List<JobDiscusses>();
      json['JobDiscusses'].forEach((v) {
        jobDiscusses.add(new JobDiscusses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listDiscussLike != null) {
      data['ListDiscussLike'] =
          this.listDiscussLike.map((v) => v.toJson()).toList();
    }
    if (this.listDiscussFile != null) {
      data['ListDiscussFile'] =
          this.listDiscussFile.map((v) => v.toJson()).toList();
    }
    if (this.jobDiscusses != null) {
      data['JobDiscusses'] = this.jobDiscusses.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListDiscussLike {
  int iD;
  int iDChannel;
  int iDJobDiscuss;

  ListDiscussLike({this.iD, this.iDChannel, this.iDJobDiscuss});

  ListDiscussLike.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDJobDiscuss = json['IDJobDiscuss'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['IDJobDiscuss'] = this.iDJobDiscuss;
    return data;
  }
}

class ListDiscussFile {
  int iD;
  int iDChannel;
  int iDJobDiscuss;
  String fileName;
  String filePath;

  ListDiscussFile({this.iD,
    this.iDChannel,
    this.iDJobDiscuss,
    this.fileName,
    this.filePath});

  ListDiscussFile.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDJobDiscuss = json['IDJobDiscuss'];
    fileName = json['FileName'];
    filePath = json['FilePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['IDJobDiscuss'] = this.iDJobDiscuss;
    data['FileName'] = this.fileName;
    data['FilePath'] = this.filePath;
    return data;
  }
}

class JobDiscusses {
  int iD;
  int iDChannel;
  int iDJob;
  String body;
  String created;
  int createdBy;
  int parent;
  String nameUser;

  JobDiscusses(
      {this.iD,
      this.iDChannel,
      this.iDJob,
      this.body,
      this.created,
      this.createdBy,
      this.parent,
      this.nameUser});

  JobDiscusses.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDJob = json['IDJob'];
    body = json['Body'];
    created = json['Created'];
    createdBy = json['CreatedBy'];
    parent = json['Parent'];
    nameUser = json['NameUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['IDJob'] = this.iDJob;
    data['Body'] = this.body;
    data['Created'] = this.created;
    data['CreatedBy'] = this.createdBy;
    data['Parent'] = this.parent;
    data['NameUser'] = this.nameUser;
    return data;
  }
}

class JobExtension {
  int iD;
  int iDChannel;
  int iDJob;
  String reason;
  String deadline;
  String newDeadline;
  int status;
  String created;
  int createdBy;

  JobExtension({this.iD,
    this.iDChannel,
    this.iDJob,
    this.reason,
    this.deadline,
    this.newDeadline,
    this.status,
    this.created,
    this.createdBy});

  JobExtension.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDJob = json['IDJob'];
    reason = json['Reason'];
    deadline = json['Deadline'];
    newDeadline = json['NewDeadline'];
    status = json['Status'];
    created = json['Created'];
    createdBy = json['CreatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['IDJob'] = this.iDJob;
    data['Reason'] = this.reason;
    data['Deadline'] = this.deadline;
    data['NewDeadline'] = this.newDeadline;
    data['Status'] = this.status;
    data['Created'] = this.created;
    data['CreatedBy'] = this.createdBy;
    return data;
  }
}

class JobStatus {
  int key;
  String describe;
  String color;
  String value;

  JobStatus({this.key, this.describe, this.color, this.value});

  JobStatus.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    describe = json['Describe'];
    color = json['Color'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['Describe'] = this.describe;
    data['Color'] = this.color;
    data['Value'] = this.value;
    return data;
  }
}

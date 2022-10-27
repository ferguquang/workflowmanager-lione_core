import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/workflow/models/response/filter_task_response.dart';
import 'package:workflow_manager/workflow/screens/group_job/group_job_response/shared_search_response.dart';

class GetDataForEditResponse extends BaseResponse {
  GetDataForEditModel data;

  GetDataForEditResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new GetDataForEditModel.fromJson(json['Data'])
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

class GetDataForEditModel {
  JobEdit job;
  List<Priorities> priorities;
  List<ListStatus> listStatus;
  List<SharedSearchModel> jobSupervisors;
  SharedSearchModel jobExecutors;
  List<SharedSearchModel> jobCombination;
  SharedSearchModel jobGroups;
  GroupJobColEdit groupJobCol;
  String jobGroupName;
  ListStatus currentStatus;

  GetDataForEditModel(
      {this.job,
      this.priorities,
      this.listStatus,
      this.jobSupervisors,
      this.jobExecutors,
      this.jobCombination,
      this.jobGroups,
      this.groupJobCol,
      this.jobGroupName,
      this.currentStatus});

  GetDataForEditModel.fromJson(Map<String, dynamic> json) {
    job = json['Job'] != null ? new JobEdit.fromJson(json['Job']) : null;
    if (json['Priorities'] != null) {
      priorities = new List<Priorities>();
      json['Priorities'].forEach((v) {
        priorities.add(new Priorities.fromJson(v));
      });
    }
    if (json['ListStatus'] != null) {
      listStatus = new List<ListStatus>();
      json['ListStatus'].forEach((v) {
        listStatus.add(new ListStatus.fromJson(v));
      });
    }
    if (json['JobSupervisors'] != null) {
      jobSupervisors = new List<SharedSearchModel>();
      json['JobSupervisors'].forEach((v) {
        jobSupervisors.add(new SharedSearchModel.fromJson(v));
      });
    }
    jobExecutors = json['JobExecutors'] != null
        ? new SharedSearchModel.fromJson(json['JobExecutors'])
        : null;
    if (json['JobCombination'] != null) {
      jobCombination = new List<SharedSearchModel>();
      json['JobCombination'].forEach((v) {
        jobCombination.add(new SharedSearchModel.fromJson(v));
      });
    }
    jobGroups = json['JobGroups'];
    groupJobCol = json['GroupJobCol'] != null
        ? new GroupJobColEdit.fromJson(json['GroupJobCol'])
        : null;
    jobGroupName = json['JobGroupName'];
    currentStatus = json['CurrentStatus'] != null
        ? new ListStatus.fromJson(json['CurrentStatus'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.job != null) {
      data['Job'] = this.job.toJson();
    }
    if (this.priorities != null) {
      data['Priorities'] = this.priorities.map((v) => v.toJson()).toList();
    }
    if (this.listStatus != null) {
      data['ListStatus'] = this.listStatus.map((v) => v.toJson()).toList();
    }
    if (this.jobSupervisors != null) {
      data['JobSupervisors'] =
          this.jobSupervisors.map((v) => v.toJson()).toList();
    }
    if (this.jobExecutors != null) {
      data['JobExecutors'] = this.jobExecutors.toJson();
    }
    if (this.jobCombination != null) {
      data['JobCombination'] =
          this.jobCombination.map((v) => v.toJson()).toList();
    }
    data['JobGroups'] = this.jobGroups;
    data['GroupJobCol'] = this.groupJobCol;
    data['JobGroupName'] = this.jobGroupName;
    if (this.currentStatus != null) {
      data['CurrentStatus'] = this.currentStatus.toJson();
    }
    return data;
  }
}

class JobEdit {
  int iD;
  int iDChannel;
  // Null iDJobFlow;
  Null iDJobStep; //
  // Null jobNodeKey;
  int iDDept;
  int iDGroupJob;
  int iDExecutor;
  // Null iDOrk;
  int type;
  String name;
  // Null topic;
  String describe;
  int priority;
  String created;
  int createdBy;
  // Null updated;
  int updatedBy;
  String startDate;
  String endDate;
  // Null started;
  // Null finished;
  int status;
  double rating;
  // Null ratingNote;
  int parent;
  // Null parents;
  // Null fileCount;
  // Null jobCount;
  // Null reworkCount;
  // Null additionCount;
  int executorCount;
  String searchMeta;
  double percentCompleted;
  // Null closed;
  // Null rejected;
  // Null pendingDate;
  // Null cancelDate;
  double totalDay;
  bool isSendMailRemind;
  // Null remindDate;
  // Null sented;
  int sentMailRemindCount;
  // Null nearlyExpired;
  // Null isArchive;
  // Null personalSort;
  // Null iDProject;
  // Null iDProjectMilestone;
  // Null iDDoc;
  // Null iDCategory;
  // Null iDBrand;
  // Null iDCoexecutor;
  // Null iDSupervisor;
  int iDGroupJobCol;
  int weight;
  bool isTemplate;
  bool isActive;
  int progressStatus;
  bool keepConnectionAlive;
  // Null connection;
  // Null lastSQL;
  // Null lastArgs;
  String lastCommand;
  bool enableAutoSelect;
  bool enableNamedParams;
  int commandTimeout;
  int oneTimeCommandTimeout;

  JobEdit(
      {this.iD,
      this.iDChannel,
      // this.iDJobFlow,
      this.iDJobStep,
      // this.jobNodeKey,
      this.iDDept,
      this.iDGroupJob,
      this.iDExecutor,
      // this.iDOrk,
      this.type,
      this.name,
      // this.topic,
      this.describe,
      this.priority,
      this.created,
      this.createdBy,
      // this.updated,
      this.updatedBy,
      this.startDate,
      this.endDate,
      // this.started,
      // this.finished,
      this.status,
      this.rating,
      // this.ratingNote,
      this.parent,
      // this.parents,
      // this.fileCount,
      // this.jobCount,
      // this.reworkCount,
      // this.additionCount,
      this.executorCount,
      this.searchMeta,
      this.percentCompleted,
      // this.closed,
      // this.rejected,
      // this.pendingDate,
      // this.cancelDate,
      this.totalDay,
      this.isSendMailRemind,
      // this.remindDate,
      // this.sented,
      this.sentMailRemindCount,
      // this.nearlyExpired,
      // this.isArchive,
      // this.personalSort,
      // this.iDProject,
      // this.iDProjectMilestone,
      // this.iDDoc,
      // this.iDCategory,
      // this.iDBrand,
      // this.iDCoexecutor,
      // this.iDSupervisor,
      this.iDGroupJobCol,
      this.weight,
      this.isTemplate,
      this.isActive,
      this.progressStatus,
      this.keepConnectionAlive,
      // this.connection,
      // this.lastSQL,
      // this.lastArgs,
      this.lastCommand,
      this.enableAutoSelect,
      this.enableNamedParams,
      this.commandTimeout,
      this.oneTimeCommandTimeout});

  JobEdit.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    // iDJobFlow = json['IDJobFlow'];
    iDJobStep = json['IDJobStep'];
    // jobNodeKey = json['JobNodeKey'];
    iDDept = json['IDDept'];
    iDGroupJob = json['IDGroupJob'];
    iDExecutor = json['IDExecutor'];
    // iDOrk = json['IDOrk'];
    type = json['Type'];
    name = json['Name'];
    // topic = json['Topic'];
    describe = json['Describe'];
    priority = json['Priority'];
    created = json['Created'];
    createdBy = json['CreatedBy'];
    // updated = json['Updated'];
    updatedBy = json['UpdatedBy'];
    startDate = json['StartDate'];
    endDate = json['EndDate'];
    // started = json['Started'];
    // finished = json['Finished'];
    status = json['Status'];
    rating = json['Rating'];
    // ratingNote = json['RatingNote'];
    parent = json['Parent'];
    // parents = json['Parents'];
    // fileCount = json['FileCount'];
    // jobCount = json['JobCount'];
    // reworkCount = json['ReworkCount'];
    // additionCount = json['AdditionCount'];
    executorCount = json['ExecutorCount'];
    searchMeta = json['SearchMeta'];
    percentCompleted = json['PercentCompleted'];
    // closed = json['Closed'];
    // rejected = json['Rejected'];
    // pendingDate = json['PendingDate'];
    // cancelDate = json['CancelDate'];
    totalDay = json['TotalDay'];
    isSendMailRemind = json['IsSendMailRemind'];
    // remindDate = json['RemindDate'];
    // sented = json['Sented'];
    sentMailRemindCount = json['SentMailRemindCount'];
    // nearlyExpired = json['NearlyExpired'];
    // isArchive = json['IsArchive'];
    // personalSort = json['PersonalSort'];
    // iDProject = json['IDProject'];
    // iDProjectMilestone = json['IDProjectMilestone'];
    // iDDoc = json['IDDoc'];
    // iDCategory = json['IDCategory'];
    // iDBrand = json['IDBrand'];
    // iDCoexecutor = json['IDCoexecutor'];
    // iDSupervisor = json['IDSupervisor'];
    iDGroupJobCol = json['IDGroupJobCol'];
    weight = json['Weight'];
    isTemplate = json['IsTemplate'];
    isActive = json['IsActive'];
    progressStatus = json['ProgressStatus'];
    keepConnectionAlive = json['KeepConnectionAlive'];
    // connection = json['Connection'];
    // lastSQL = json['LastSQL'];
    // lastArgs = json['LastArgs'];
    lastCommand = json['LastCommand'];
    enableAutoSelect = json['EnableAutoSelect'];
    enableNamedParams = json['EnableNamedParams'];
    commandTimeout = json['CommandTimeout'];
    oneTimeCommandTimeout = json['OneTimeCommandTimeout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    // data['IDJobFlow'] = this.iDJobFlow;
    data['IDJobStep'] = this.iDJobStep;
    // data['JobNodeKey'] = this.jobNodeKey;
    data['IDDept'] = this.iDDept;
    data['IDGroupJob'] = this.iDGroupJob;
    data['IDExecutor'] = this.iDExecutor;
    // data['IDOrk'] = this.iDOrk;
    data['Type'] = this.type;
    data['Name'] = this.name;
    // data['Topic'] = this.topic;
    data['Describe'] = this.describe;
    data['Priority'] = this.priority;
    data['Created'] = this.created;
    data['CreatedBy'] = this.createdBy;
    // data['Updated'] = this.updated;
    data['UpdatedBy'] = this.updatedBy;
    data['StartDate'] = this.startDate;
    data['EndDate'] = this.endDate;
    // data['Started'] = this.started;
    // data['Finished'] = this.finished;
    data['Status'] = this.status;
    data['Rating'] = this.rating;
    // data['RatingNote'] = this.ratingNote;
    data['Parent'] = this.parent;
    // data['Parents'] = this.parents;
    // data['FileCount'] = this.fileCount;
    // data['JobCount'] = this.jobCount;
    // data['ReworkCount'] = this.reworkCount;
    // data['AdditionCount'] = this.additionCount;
    data['ExecutorCount'] = this.executorCount;
    data['SearchMeta'] = this.searchMeta;
    data['PercentCompleted'] = this.percentCompleted;
    // data['Closed'] = this.closed;
    // data['Rejected'] = this.rejected;
    // data['PendingDate'] = this.pendingDate;
    // data['CancelDate'] = this.cancelDate;
    data['TotalDay'] = this.totalDay;
    data['IsSendMailRemind'] = this.isSendMailRemind;
    // data['RemindDate'] = this.remindDate;
    // data['Sented'] = this.sented;
    data['SentMailRemindCount'] = this.sentMailRemindCount;
    // data['NearlyExpired'] = this.nearlyExpired;
    // data['IsArchive'] = this.isArchive;
    // data['PersonalSort'] = this.personalSort;
    // data['IDProject'] = this.iDProject;
    // data['IDProjectMilestone'] = this.iDProjectMilestone;
    // data['IDDoc'] = this.iDDoc;
    // data['IDCategory'] = this.iDCategory;
    // data['IDBrand'] = this.iDBrand;
    // data['IDCoexecutor'] = this.iDCoexecutor;
    // data['IDSupervisor'] = this.iDSupervisor;
    data['IDGroupJobCol'] = this.iDGroupJobCol;
    data['Weight'] = this.weight;
    data['IsTemplate'] = this.isTemplate;
    data['IsActive'] = this.isActive;
    data['ProgressStatus'] = this.progressStatus;
    data['KeepConnectionAlive'] = this.keepConnectionAlive;
    // data['Connection'] = this.connection;
    // data['LastSQL'] = this.lastSQL;
    // data['LastArgs'] = this.lastArgs;
    data['LastCommand'] = this.lastCommand;
    data['EnableAutoSelect'] = this.enableAutoSelect;
    data['EnableNamedParams'] = this.enableNamedParams;
    data['CommandTimeout'] = this.commandTimeout;
    data['OneTimeCommandTimeout'] = this.oneTimeCommandTimeout;
    return data;
  }
}

class ListStatus {
  int key;
  String value;
  bool isSelected;

  ListStatus({this.key, this.value, this.isSelected = false});

  ListStatus.fromJson(Map<String, dynamic> json) {
    key = json['Key'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Key'] = this.key;
    data['Value'] = this.value;
    return data;
  }
}

class GroupJobColEdit {
  int iD;
  int iDChannel;
  int iDGroupJob;
  String colTitle;
  int priority;
  String created;
  int createdBy;
  bool keepConnectionAlive;
  Null connection;
  Null lastSQL;
  Null lastArgs;
  String lastCommand;
  bool enableAutoSelect;
  bool enableNamedParams;
  int commandTimeout;
  int oneTimeCommandTimeout;

  GroupJobColEdit(
      {this.iD,
      this.iDChannel,
      this.iDGroupJob,
      this.colTitle,
      this.priority,
      this.created,
      this.createdBy,
      this.keepConnectionAlive,
      this.connection,
      this.lastSQL,
      this.lastArgs,
      this.lastCommand,
      this.enableAutoSelect,
      this.enableNamedParams,
      this.commandTimeout,
      this.oneTimeCommandTimeout});

  GroupJobColEdit.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDGroupJob = json['IDGroupJob'];
    colTitle = json['ColTitle'];
    priority = json['Priority'];
    created = json['Created'];
    createdBy = json['CreatedBy'];
    keepConnectionAlive = json['KeepConnectionAlive'];
    connection = json['Connection'];
    lastSQL = json['LastSQL'];
    lastArgs = json['LastArgs'];
    lastCommand = json['LastCommand'];
    enableAutoSelect = json['EnableAutoSelect'];
    enableNamedParams = json['EnableNamedParams'];
    commandTimeout = json['CommandTimeout'];
    oneTimeCommandTimeout = json['OneTimeCommandTimeout'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['IDChannel'] = this.iDChannel;
    data['IDGroupJob'] = this.iDGroupJob;
    data['ColTitle'] = this.colTitle;
    data['Priority'] = this.priority;
    data['Created'] = this.created;
    data['CreatedBy'] = this.createdBy;
    data['KeepConnectionAlive'] = this.keepConnectionAlive;
    data['Connection'] = this.connection;
    data['LastSQL'] = this.lastSQL;
    data['LastArgs'] = this.lastArgs;
    data['LastCommand'] = this.lastCommand;
    data['EnableAutoSelect'] = this.enableAutoSelect;
    data['EnableNamedParams'] = this.enableNamedParams;
    data['CommandTimeout'] = this.commandTimeout;
    data['OneTimeCommandTimeout'] = this.oneTimeCommandTimeout;
    return data;
  }
}

// class JobSupervisors {
//   int iD;
//   String name;
//
//   JobSupervisors({this.iD, this.name});
//
//   JobSupervisors.fromJson(Map<String, dynamic> json) {
//     iD = json['ID'];
//     name = json['Name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['ID'] = this.iD;
//     data['Name'] = this.name;
//     return data;
//   }
// }

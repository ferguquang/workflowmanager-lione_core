import 'package:workflow_manager/base/models/base_response.dart';
import 'package:workflow_manager/procedures/models/response/handler_info.dart';
import 'package:workflow_manager/procedures/models/response/position.dart';
import 'package:workflow_manager/procedures/models/response/user.dart';

class ActionProcedureResponse {}

// DataIsResentInfo (từ chối)
class RegisterIsResentInfoResponse extends BaseResponse {
  DataIsResentInfo data;

  RegisterIsResentInfoResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataIsResentInfo.fromJson(json['Data'])
        : null;
  }
}

class DataIsResentInfo {
  int iDServiceRecord;
  String title;
  int iDServiceRecordWfStep;

  DataIsResentInfo(
      {this.iDServiceRecord, this.title, this.iDServiceRecordWfStep});

  DataIsResentInfo.fromJson(Map<String, dynamic> json) {
    iDServiceRecord = json['IDServiceRecord'];
    title = json['Title'];
    iDServiceRecordWfStep = json['IDServiceRecordWfStep'];
  }
}

// IsResolve
class RecordIsResolveResponse extends BaseResponse {
  DataIsResolve dataIsResolve;

  RecordIsResolveResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    dataIsResolve =
        json['Data'] != null ? new DataIsResolve.fromJson(json['Data']) : null;
  }
}

class DataIsResolve {
  Resolve resolve;

  DataIsResolve.fromJson(Map<String, dynamic> json) {
    resolve =
        json['Resolve'] != null ? new Resolve.fromJson(json['Resolve']) : null;
  }
}

class Resolve {
  int idStep;
  int iDSchemaCondition;

  Resolve({this.idStep, this.iDSchemaCondition});

  Resolve.fromJson(Map<String, dynamic> json) {
    idStep = json['IDStep'];
    iDSchemaCondition = json['IDSchemaCondition'];
  }
}

// IsDoneInfo
class IsDoneInfoResponse extends BaseResponse {
  int status;
  DataIsDoneInfo data;

  IsDoneInfoResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data =
        json['Data'] != null ? new DataIsDoneInfo.fromJson(json['Data']) : null;
  }
}

class DataIsDoneInfo {
  bool isPermit;
  int iDServiceRecordWfStep;
  bool isAssignNewExecutor;
  bool isRequiredNote;
  bool isParallelAssign;
  List<StepAssignParallels> stepAssignParallels;
  List<User> users;
  List<HandlerInfo> depts;
  List<Position> postions;
  List<HandlerInfo> teams;

  DataIsDoneInfo(
      {this.isPermit,
      this.iDServiceRecordWfStep,
      this.isAssignNewExecutor,
      this.isRequiredNote,
      this.isParallelAssign,
      this.stepAssignParallels,
      this.users,
      this.depts,
      this.postions,
      this.teams});

  DataIsDoneInfo.fromJson(Map<String, dynamic> json) {
    isPermit = json['IsPermit'];
    iDServiceRecordWfStep = json['IDServiceRecordWfStep'];
    isAssignNewExecutor = json['IsAssignNewExecutor'];
    isRequiredNote = json['IsRequiredNote'];
    if (json['Users'] != null) {
      users = new List<User>();
      json['Users'].forEach((v) {
        users.add(new User.fromJson(v));
      });
    }
    isParallelAssign = json['IsParallelAssign'];
    if (json['StepAssignParallels'] != null) {
      stepAssignParallels = new List<StepAssignParallels>();
      json['StepAssignParallels'].forEach((v) {
        stepAssignParallels.add(new StepAssignParallels.fromJson(v));
      });
    }
    if (json['Depts'] != null) {
      depts = new List<HandlerInfo>();
      json['Depts'].forEach((v) {
        depts.add(new HandlerInfo.fromJson(v));
      });
    }
    if (json['Positions'] != null) {
      postions = new List<Position>();
      json['Positions'].forEach((v) {
        postions.add(new Position.fromJson(v));
      });
    }
    if (json['Teams'] != null) {
      teams = new List<HandlerInfo>();
      json['Teams'].forEach((v) {
        teams.add(new HandlerInfo.fromJson(v));
      });
    }
  }
}

// add action(require action):
class IsRequireAdditionResponse extends BaseResponse {
  DataIsRequireAddition data;

  IsRequireAdditionResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataIsRequireAddition.fromJson(json['Data'])
        : null;
  }
}

class DataIsRequireAddition {
  List<SelectSteps> selectSteps;

  DataIsRequireAddition({this.selectSteps});

  DataIsRequireAddition.fromJson(Map<String, dynamic> json) {
    if (json['SelectSteps'] != null) {
      selectSteps = new List<SelectSteps>();
      json['SelectSteps'].forEach((v) {
        selectSteps.add(new SelectSteps.fromJson(v));
      });
    }
  }
}

class SelectSteps {
  String name;
  int iDServiceRecordWfStepAddition;

  SelectSteps({this.name, this.iDServiceRecordWfStepAddition});

  SelectSteps.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    iDServiceRecordWfStepAddition = json['IDServiceRecordWfStepAddition'];
  }
}

// require action:
class IsDoneRequireAdditionResponse extends BaseResponse {
  DataIsDoneRequireAddition data;

  IsDoneRequireAdditionResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    data = json['Data'] != null
        ? new DataIsDoneRequireAddition.fromJson(json['Data'])
        : null;
  }
}

class DataIsDoneRequireAddition {
  AdditionalRequired additionalRequired;

  DataIsDoneRequireAddition({this.additionalRequired});

  DataIsDoneRequireAddition.fromJson(Map<String, dynamic> json) {
    additionalRequired = json['AdditionalRequired'] != null
        ? new AdditionalRequired.fromJson(json['AdditionalRequired'])
        : null;
  }
}

class AdditionalRequired {
  int iDServiceRecordWfStepRequired;
  int iDServiceRecordWfStepAddition;

  AdditionalRequired(
      {this.iDServiceRecordWfStepRequired, this.iDServiceRecordWfStepAddition});

  AdditionalRequired.fromJson(Map<String, dynamic> json) {
    iDServiceRecordWfStepRequired = json['IDServiceRecordWfStepRequired'];
    iDServiceRecordWfStepAddition = json['IDServiceRecordWfStepAddition'];
  }
}

class StepAssignParallels {
  int iD;
  int iDChannel;
  int iDService;
  int iDServiceRecord;
  int iDServiceRecordWf;
  int iDServiceType;
  String name;
  String describe;
  int step;
  int day;
  int hour;
  int minute;
  bool isAllCompleted;
  bool isEnableAssign;
  int typeCompleted;
  String endDate;
  Null doneDate;
  Null received;
  String planEndDate;
  int nodeKey;
  String figure;
  String category;
  String location;
  bool isDeletable;
  bool isStep;
  int createdBy;
  String created;
  int updatedBy;
  String updated;
  String searchMeta;
  int iDTemp;
  String fill;
  bool hasChildWf;
  bool isParallelStep;
  int startParallelStep;
  bool isOwnDept;
  bool keepConnectionAlive;
  Null connection;
  Null lastSQL;
  Null lastArgs;
  String lastCommand;
  bool enableAutoSelect;
  bool enableNamedParams;
  int commandTimeout;
  int oneTimeCommandTimeout;

  StepAssignParallels(
      {this.iD,
      this.iDChannel,
      this.iDService,
      this.iDServiceRecord,
      this.iDServiceRecordWf,
      this.iDServiceType,
      this.name,
      this.describe,
      this.step,
      this.day,
      this.hour,
      this.minute,
      this.isAllCompleted,
      this.isEnableAssign,
      this.typeCompleted,
      this.endDate,
      this.doneDate,
      this.received,
      this.planEndDate,
      this.nodeKey,
      this.figure,
      this.category,
      this.location,
      this.isDeletable,
      this.isStep,
      this.createdBy,
      this.created,
      this.updatedBy,
      this.updated,
      this.searchMeta,
      this.iDTemp,
      this.fill,
      this.hasChildWf,
      this.isParallelStep,
      this.startParallelStep,
      this.isOwnDept,
      this.keepConnectionAlive,
      this.connection,
      this.lastSQL,
      this.lastArgs,
      this.lastCommand,
      this.enableAutoSelect,
      this.enableNamedParams,
      this.commandTimeout,
      this.oneTimeCommandTimeout});

  StepAssignParallels.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    iDChannel = json['IDChannel'];
    iDService = json['IDService'];
    iDServiceRecord = json['IDServiceRecord'];
    iDServiceRecordWf = json['IDServiceRecordWf'];
    iDServiceType = json['IDServiceType'];
    name = json['Name'];
    describe = json['Describe'];
    step = json['Step'];
    day = json['Day'];
    hour = json['Hour'];
    minute = json['Minute'];
    isAllCompleted = json['IsAllCompleted'];
    isEnableAssign = json['IsEnableAssign'];
    typeCompleted = json['TypeCompleted'];
    endDate = json['EndDate'];
    doneDate = json['DoneDate'];
    received = json['Received'];
    planEndDate = json['PlanEndDate'];
    nodeKey = json['NodeKey'];
    figure = json['Figure'];
    category = json['Category'];
    location = json['Location'];
    isDeletable = json['IsDeletable'];
    isStep = json['IsStep'];
    createdBy = json['CreatedBy'];
    created = json['Created'];
    updatedBy = json['UpdatedBy'];
    updated = json['Updated'];
    searchMeta = json['SearchMeta'];
    iDTemp = json['IDTemp'];
    fill = json['Fill'];
    hasChildWf = json['HasChildWf'];
    isParallelStep = json['IsParallelStep'];
    startParallelStep = json['StartParallelStep'];
    isOwnDept = json['IsOwnDept'];
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
    data['IDService'] = this.iDService;
    data['IDServiceRecord'] = this.iDServiceRecord;
    data['IDServiceRecordWf'] = this.iDServiceRecordWf;
    data['IDServiceType'] = this.iDServiceType;
    data['Name'] = this.name;
    data['Describe'] = this.describe;
    data['Step'] = this.step;
    data['Day'] = this.day;
    data['Hour'] = this.hour;
    data['Minute'] = this.minute;
    data['IsAllCompleted'] = this.isAllCompleted;
    data['IsEnableAssign'] = this.isEnableAssign;
    data['TypeCompleted'] = this.typeCompleted;
    data['EndDate'] = this.endDate;
    data['DoneDate'] = this.doneDate;
    data['Received'] = this.received;
    data['PlanEndDate'] = this.planEndDate;
    data['NodeKey'] = this.nodeKey;
    data['Figure'] = this.figure;
    data['Category'] = this.category;
    data['Location'] = this.location;
    data['IsDeletable'] = this.isDeletable;
    data['IsStep'] = this.isStep;
    data['CreatedBy'] = this.createdBy;
    data['Created'] = this.created;
    data['UpdatedBy'] = this.updatedBy;
    data['Updated'] = this.updated;
    data['SearchMeta'] = this.searchMeta;
    data['IDTemp'] = this.iDTemp;
    data['Fill'] = this.fill;
    data['HasChildWf'] = this.hasChildWf;
    data['IsParallelStep'] = this.isParallelStep;
    data['StartParallelStep'] = this.startParallelStep;
    data['IsOwnDept'] = this.isOwnDept;
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

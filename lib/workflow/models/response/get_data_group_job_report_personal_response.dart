import 'package:workflow_manager/base/models/base_response.dart';

import 'get_data_group_job_report_response.dart';

class GetDataGroupJobReportPersonalResponse extends BaseResponse {
  // int status;
  ReportDataPersonal data;
  // List<Message> messages;

  // GetDataGroupJobReportPersonalResponse(
  //     {this.status, this.data, this.messages});

  GetDataGroupJobReportPersonalResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    // status = json['Status'];
    data = json['Data'] != null
        ? new ReportDataPersonal.fromJson(json['Data'])
        : null;
    // if (json['Messages'] != null) {
    //   messages = new List<Message>();
    //   json['Messages'].forEach((v) {
    //     messages.add(new Message.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['Status'] = this.status;
    if (this.data != null) {
      data['Data'] = this.data.toJson();
    }
    // if (this.messages != null) {
    //   data['Messages'] = this.messages.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class ReportDataPersonal {
  ListDataChart listDataChart;
  double rate;
  String performanceRank;
  PerformanceJobGroupAPI performanceJobGroupAPI;
  List<ListDataChartLine> listDataChartLine;
  UserPersonal userPersonal;

  ReportDataPersonal(
      {this.listDataChart,
      this.rate,
      this.performanceRank,
      this.performanceJobGroupAPI,
      this.listDataChartLine,
      this.userPersonal});

  ReportDataPersonal.fromJson(Map<String, dynamic> json) {
    listDataChart = json['ListDataChart'] != null
        ? new ListDataChart.fromJson(json['ListDataChart'])
        : null;
    rate = json['Rate'];
    performanceRank = json['PerformanceRank'];
    performanceJobGroupAPI = json['Performance'] != null
        ? new PerformanceJobGroupAPI.fromJson(json['Performance'])
        : null;
    if (json['ListDataChartLine'] != null) {
      listDataChartLine = new List<ListDataChartLine>();
      json['ListDataChartLine'].forEach((v) {
        listDataChartLine.add(new ListDataChartLine.fromJson(v));
      });
    }
    userPersonal = json['UserPersonal'] != null
        ? new UserPersonal.fromJson(json['UserPersonal'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listDataChart != null) {
      data['ListDataChart'] = this.listDataChart.toJson();
    }
    data['Rate'] = this.rate;
    data['PerformanceRank'] = this.performanceRank;
    if (this.performanceJobGroupAPI != null) {
      data['Performance'] = this.performanceJobGroupAPI.toJson();
    }
    if (this.listDataChartLine != null) {
      data['ListDataChartLine'] =
          this.listDataChartLine.map((v) => v.toJson()).toList();
    }
    if (this.userPersonal != null) {
      data['UserPersonal'] = this.userPersonal.toJson();
    }
    return data;
  }
}
/*
class ListDataChart {
  List<Chart> chart;
  int totalCount;

  ListDataChart({this.chart, this.totalCount});

  ListDataChart.fromJson(Map<String, dynamic> json) {
    if (json['Chart'] != null) {
      chart = new List<Chart>();
      json['Chart'].forEach((v) {
        chart.add(new Chart.fromJson(v));
      });
    }
    totalCount = json['TotalCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.chart != null) {
      data['Chart'] = this.chart.map((v) => v.toJson()).toList();
    }
    data['TotalCount'] = this.totalCount;
    return data;
  }
}

class Chart {
  String label;
  String fill;
  int parent;
  // List<JobChildren> children;
  int count;

  Chart({this.label, this.fill, this.parent/*, this.children*/, this.count});

  Chart.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    fill = json['fill'];
    parent = json['Parent'];
    // if (json['children'] != null) {
    //   children = new List<JobChildren>();
    //   json['children'].forEach((v) {
    //     children.add(new JobChildren.fromJson(v));
    //   });
    // }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['fill'] = this.fill;
    data['Parent'] = this.parent;
    // if (this.children != null) {
    //   data['children'] = this.children.map((v) => v.toJson()).toList();
    // }
    data['count'] = this.count;
    return data;
  }
}

class JobChildren {
  String label;
  String fill;
  int parent;
  List<JobChildren> children;
  int count;

  JobChildren({this.label, this.fill, this.parent, this.children, this.count});

  JobChildren.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    fill = json['fill'];
    parent = json['Parent'];
    if (json['children'] != null) {
      children = new List<JobChildren>();
      json['children'].forEach((v) {
        children.add(new JobChildren.fromJson(v));
      });
    }
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['fill'] = this.fill;
    data['Parent'] = this.parent;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    data['count'] = this.count;
    return data;
  }
}
*/
/*
class PerformanceJobGroupAPI {
  String color;
  double performance;

  PerformanceJobGroupAPI({this.color, this.performance});

  PerformanceJobGroupAPI.fromJson(Map<String, dynamic> json) {
    color = json['Color'];
    performance = json['Performance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Color'] = this.color;
    data['Performance'] = this.performance;
    return data;
  }
}
*/

/*
class ListDataChartLine {
  int x;
  String y;

  ListDataChartLine({this.x, this.y});

  ListDataChartLine.fromJson(Map<String, dynamic> json) {
    x = json['X'];
    y = json['Y'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['X'] = this.x;
    data['Y'] = this.y;
    return data;
  }
}
*/
class UserPersonal {
  int iD;
  String userName;
  String deptName;
  Null position;
  Null userCode;
  String phoneNumber;
  String email;
  String imgSrc;
  int performance;
  int rate;

  UserPersonal(
      {this.iD,
      this.userName,
      this.deptName,
      this.position,
      this.userCode,
      this.phoneNumber,
      this.email,
      this.imgSrc,
      this.performance,
      this.rate});

  UserPersonal.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    userName = json['UserName'];
    deptName = json['DeptName'];
    position = json['Position'];
    userCode = json['UserCode'];
    phoneNumber = json['PhoneNumber'];
    email = json['Email'];
    imgSrc = json['ImgSrc'];
    performance = json['Performance'];
    rate = json['Rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['UserName'] = this.userName;
    data['DeptName'] = this.deptName;
    data['Position'] = this.position;
    data['UserCode'] = this.userCode;
    data['PhoneNumber'] = this.phoneNumber;
    data['Email'] = this.email;
    data['ImgSrc'] = this.imgSrc;
    data['Performance'] = this.performance;
    data['Rate'] = this.rate;
    return data;
  }
}

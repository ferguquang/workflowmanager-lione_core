import 'package:workflow_manager/base/models/base_response.dart';

import 'get_data_group_job_report_response.dart';

class GetDataDetailGroupJobReportModel extends BaseResponse {
  // int status;
  DetailGroupJobReportData data;
  // List<Message> messages;

  // GetDataDetailGroupJobReportModel({this.status, this.data, this.messages});

  GetDataDetailGroupJobReportModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    // status = json['Status'];
    data = json['Data'] != null
        ? new DetailGroupJobReportData.fromJson(json['Data'])
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

class DetailGroupJobReportData {
  ListDataChart listDataChart;
  PerformanceChart performanceChart;
  List<ListDataChartLine> listDataChartLine;
  List<ListReportUserJobGroupManagerAPI> listReportUserJobGroupManagerAPI;
  List<ListJob> listJob;

  DetailGroupJobReportData(
      {this.listDataChart,
      this.performanceChart,
      this.listDataChartLine,
      this.listReportUserJobGroupManagerAPI,
      this.listJob});

  DetailGroupJobReportData.fromJson(Map<String, dynamic> json) {
    listDataChart = json['ListDataChart'] != null
        ? new ListDataChart.fromJson(json['ListDataChart'])
        : null;
    performanceChart = json['PerformanceChart'] != null
        ? new PerformanceChart.fromJson(json['PerformanceChart'])
        : null;
    if (json['ListDataChartLine'] != null) {
      listDataChartLine = new List<ListDataChartLine>();
      json['ListDataChartLine'].forEach((v) {
        listDataChartLine.add(new ListDataChartLine.fromJson(v));
      });
    }
    if (json['ListReportUserJobGroupManagerAPI'] != null) {
      listReportUserJobGroupManagerAPI =
          new List<ListReportUserJobGroupManagerAPI>();
      json['ListReportUserJobGroupManagerAPI'].forEach((v) {
        listReportUserJobGroupManagerAPI
            .add(new ListReportUserJobGroupManagerAPI.fromJson(v));
      });
    }
    if (json['ListJob'] != null) {
      listJob = new List<ListJob>();
      json['ListJob'].forEach((v) {
        listJob.add(new ListJob.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.listDataChart != null) {
      data['ListDataChart'] = this.listDataChart.toJson();
    }
    if (this.performanceChart != null) {
      data['PerformanceChart'] = this.performanceChart.toJson();
    }
    if (this.listDataChartLine != null) {
      data['ListDataChartLine'] =
          this.listDataChartLine.map((v) => v.toJson()).toList();
    }
    if (this.listReportUserJobGroupManagerAPI != null) {
      data['ListReportUserJobGroupManagerAPI'] =
          this.listReportUserJobGroupManagerAPI.map((v) => v.toJson()).toList();
    }
    if (this.listJob != null) {
      data['ListJob'] = this.listJob.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PerformanceChart {
  PerformanceJobGroupAPI performance;
  double rate;
  String performanceRank;

  PerformanceChart({this.performance, this.rate, this.performanceRank});

  PerformanceChart.fromJson(Map<String, dynamic> json) {
    performance = json['Performance'] != null
        ? new PerformanceJobGroupAPI.fromJson(json['Performance'])
        : null;
    rate = json['Rate'];
    performanceRank = json['PerformanceRank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.performance != null) {
      data['Performance'] = this.performance.toJson();
    }
    data['Rate'] = this.rate;
    data['PerformanceRank'] = this.performanceRank;
    return data;
  }
}

/*
class Chart {
  String label;
  String fill;
  int parent;
  List<Children> children;
  int count;

  Chart({this.label, this.fill, this.parent, this.children, this.count});

  Chart.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    fill = json['fill'];
    parent = json['Parent'];
    if (json['children'] != null) {
      children = new List<Children>();
      json['children'].forEach((v) {
        children.add(new Children.fromJson(v));
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

class Children {
  String label;
  String fill;
  int parent;
  List<Null> children;
  int count;

  Children({this.label, this.fill, this.parent, this.children, this.count});

  Children.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    fill = json['fill'];
    parent = json['Parent'];
    if (json['children'] != null) {
      children = new List<Null>();
      json['children'].forEach((v) {
        children.add(new Null.fromJson(v));
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

class Performance {
  String color;
  int performance;

  Performance({this.color, this.performance});

  Performance.fromJson(Map<String, dynamic> json) {
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
class ListReportUserJobGroupManagerAPI {
  int iD;
  String name;
  int totalJob;
  PerformanceJobGroupAPI performance;

  ListReportUserJobGroupManagerAPI(
      {this.iD, this.name, this.totalJob, this.performance});

  ListReportUserJobGroupManagerAPI.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    totalJob = json['TotalJob'];
    performance = json['Performance'] != null
        ? new PerformanceJobGroupAPI.fromJson(json['Performance'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ID'] = this.iD;
    data['Name'] = this.name;
    data['TotalJob'] = this.totalJob;
    if (this.performance != null) {
      data['Performance'] = this.performance.toJson();
    }
    return data;
  }
}

class ListJob {
  String jobName;
  Status status;
  Status progress;
  String userName;

  ListJob({this.jobName, this.status, this.progress, this.userName});

  ListJob.fromJson(Map<String, dynamic> json) {
    jobName = json['JobName'];
    status =
        json['Status'] != null ? new Status.fromJson(json['Status']) : null;
    progress =
        json['Progress'] != null ? new Status.fromJson(json['Progress']) : null;
    userName = json['UserName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['JobName'] = this.jobName;
    if (this.status != null) {
      data['Status'] = this.status.toJson();
    }
    if (this.progress != null) {
      data['Progress'] = this.progress.toJson();
    }
    data['UserName'] = this.userName;
    return data;
  }
}

class Status {
  String name;
  String color;

  Status({this.name, this.color});

  Status.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    color = json['Color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Color'] = this.color;
    return data;
  }
}

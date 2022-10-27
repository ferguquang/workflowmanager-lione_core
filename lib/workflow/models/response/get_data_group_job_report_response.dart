import 'package:workflow_manager/base/models/base_response.dart';

class GetDataGroupJobReportResponse extends BaseResponse {
  // int status;
  DataGroupJobReportModel data;
  // List<Message> messages;

  // GetDataGroupJobReportResponse({this.status, this.data, this.messages});

  GetDataGroupJobReportResponse.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    // status = json['Status'];
    data = json['Data'] != null
        ? new DataGroupJobReportModel.fromJson(json['Data'])
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

class DataGroupJobReportModel {
  ListDataChart listDataChart;
  double rate;
  String performanceRank;
  PerformanceJobGroupAPI performanceJobGroupAPI;
  List<ListDataChartLine> listDataChartLine;

  DataGroupJobReportModel(
      {this.listDataChart,
      this.rate,
      this.performanceRank,
      this.performanceJobGroupAPI,
      this.listDataChartLine});

  DataGroupJobReportModel.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

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
  int count;
  List<Children> children;

  Chart({this.label, this.fill, this.parent, this.count, this.children});

  Chart.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    fill = json['fill'];
    parent = json['Parent'];
    count = json['count'];
    if (json['children'] != null) {
      children = new List<Children>();
      json['children'].forEach((v) {
        children.add(new Children.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['fill'] = this.fill;
    data['Parent'] = this.parent;
    data['count'] = this.count;
    if (this.children != null) {
      data['children'] = this.children.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Children {
  String label;
  String fill;
  int parent;
  int count;

  Children({this.label, this.fill, this.parent, this.count});

  Children.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    fill = json['fill'];
    parent = json['Parent'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.label;
    data['fill'] = this.fill;
    data['Parent'] = this.parent;
    data['count'] = this.count;
    return data;
  }
}

class PerformanceJobGroupAPI {
  String color;
  int performance;

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

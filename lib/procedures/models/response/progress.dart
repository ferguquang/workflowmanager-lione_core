class Progress {
  bool isLate = false;
  String dateLineString = "";

  Progress.fromJson(Map<String, dynamic> json) {
    isLate = json['IsLate'];
    dateLineString = json['DateLineString'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['IsLate'] = isLate;
    json['DateLineString'] = dateLineString;
    return json;
  }
}

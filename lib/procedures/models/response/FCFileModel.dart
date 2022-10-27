class FCFileModel {
  String fileName;
  String filePath;

  FCFileModel(this.fileName, this.filePath);

  FCFileModel.fromJson(Map<String, dynamic> json) {
    fileName = json['FileName'];
    filePath = json['FilePath'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['FileName'] = fileName;
    json['FilePath'] = filePath;
    return json;
  }
}

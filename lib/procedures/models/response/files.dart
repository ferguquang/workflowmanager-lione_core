class Files {
  String fileName = null;
  String filePath = null;

  Files(this.fileName, this.filePath);

  Files.fromJson(Map<String, dynamic> json) {
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

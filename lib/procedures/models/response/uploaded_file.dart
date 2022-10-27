class UploadedFile {
  int iD;
  String uploadedFileName;
  String uploadedFilePath;
  String extension;
  bool isSigned = false;

  UploadedFile(
      {this.iD,
      this.uploadedFileName,
      this.uploadedFilePath,
      this.extension,
      this.isSigned});

  UploadedFile.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    uploadedFileName = json['UploadedFileName'];
    uploadedFilePath = json['UploadedFilePath'];
    extension = json['Extension'];
    isSigned = json['IsSigned'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['ID'] = iD;
    json['UploadedFileName'] = uploadedFileName;
    json['UploadedFilePath'] = uploadedFilePath;
    json['Extension'] = extension;
    json['IsSigned'] = isSigned;
    return json;
  }
}

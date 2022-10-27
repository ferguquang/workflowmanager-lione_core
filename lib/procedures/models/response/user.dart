class User {
  int iD;
  String name;
  String avatar;
  String email;
  String phone;
  String address;
  bool isRemovable = true;
  int iDDept;

  User.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    name = json['Name'];
    avatar = json['Avatar'];
    email = json['Email'];
    phone = json['Phone'];
    address = json['Address'];
    isRemovable = json['IsRemovable'];
    iDDept = json['IDDept'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = Map();
    json['ID'] = iD;
    json['Name'] = name;
    json['Avatar'] = avatar;
    json['Email'] = email;
    json['Phone'] = phone;
    json['Address'] = address;
    json['IsRemovable'] = isRemovable;
    json['IDDept'] = iDDept;
    return json;
  }
}

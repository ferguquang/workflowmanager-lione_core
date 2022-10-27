class NewTripParams {
  String name;
  String phone;
  String vehicle;
  String fromLocation;
  String toLocation;
  String price;
  String time;
  List<String> arrayDay;

  Map<String, dynamic> getParams() {
    Map<String, dynamic> params = new Map<String, dynamic>();
    params["name"] = name;
    params["phone"] = phone;
    params["vehicle"] = vehicle;
    params["fromLocation"] = fromLocation;
    params["toLocation"] = toLocation;
    params["price"] = price;
    params["time"] = time;
    params["arrayDay"] = arrayDay;
    return params;
  }

}
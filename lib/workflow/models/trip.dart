import 'package:flutter/cupertino.dart';

// create new trip
class NewTripResponse {
  bool success;
  Trip trip;

  NewTripResponse({ this.success, this.trip });

  factory NewTripResponse.fromJson(Map<String, dynamic> json) {
    return NewTripResponse(
      success: json["success"] as bool,
      trip: Trip.fromJson(json["data"])
    );
  }
}

// get list trip
class ListTripResponse {
  bool success;

  ListTripData data;

  ListTripResponse({this.success, this.data});

  factory ListTripResponse.fromJson(Map<String, dynamic> json) {
    return ListTripResponse(
        success: json["success"] as bool,
        data: ListTripData.fromJson(json["data"])
    );
  }

}

class ListTripData {
  List<Trip> arrayTrip;

  ListTripData(this.arrayTrip);

  factory ListTripData.fromJson(Map<String, dynamic> json) {
    var tripsJson = json["trips"] as List;
    List<Trip> _trips = List<Trip>.from(tripsJson.map((json) => Trip.fromJson(json)));
    return ListTripData(
        _trips
    );
  }

}

class Trip {
  String id;
  String name;
  String phone;
  String vehicle;
  String fromLocation;
  String toLocation;
  double price;
  String time;
  List<String> days;

  Trip({
    this.id,
    this.name,
    this.phone,
    this.vehicle,
    this.fromLocation,
    this.toLocation,
    this.price,
    this.time,
    this.days
  });

  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip (
      id: json["_id"] as String,
      name: json["name"] as String,
      phone: json["phone"] as String,
      vehicle: json["vehicle"] as String,
      fromLocation: json["fromLocation"] as String,
      toLocation: json["toLocation"] as String,
      price: json["price"].toDouble() as double,
      time: json["time"] as String,
      days: List<String>.from(json["days"])
    );
  }

}


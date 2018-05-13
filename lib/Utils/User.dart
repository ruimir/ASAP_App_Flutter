import 'dart:convert';

class User {
  String status;
  String jwtKey;

  User({this.status, this.jwtKey});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User
      (
      status: json['status'],
      jwtKey: json['jwtKey'],
    );
  }

  User.map(dynamic obj) {
    this.status = "OK";
    this.jwtKey = obj["jwtKey"];
  }


  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["status"] = status;
    map["jwtKey"] = jwtKey;

    return map;
  }
}

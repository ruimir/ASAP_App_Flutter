import 'dart:convert';

class RegisterData {
  String status;
  String error;

  RegisterData({this.status, this.error});

  factory RegisterData.fromJson(Map<String, dynamic> json) {
    return new RegisterData(
      status: json['status'],
      error: json['error'],
    );
  }

  RegisterData.map(dynamic obj) {
    this.status = "OK";
    this.error = obj["error"];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["status"] = status;
    map["error"] = error;

    return map;
  }
}

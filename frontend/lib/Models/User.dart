import 'package:flutter/material.dart';

class User {
  String userID;
  String name;
  String email;
  String city;
  String country;
  String state;
  String address;
  DateTime dob;

  User({
    @required this.userID,
    @required this.name,
    @required this.email,
    this.city,
    this.country,
    this.state,
    this.address,
    this.dob,
  });

  User.fromJson(Map<String, dynamic> json)
      : this.userID = json['userID'],
        this.email = json['email'],
        this.name = json['name'],
        this.city = json['city'],
        this.country = json['country'],
        this.state = json['state'],
        this.address = json['address'],
        this.dob = json['dob'].toDate();
}

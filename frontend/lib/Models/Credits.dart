import 'package:flutter/material.dart';

class Credits with ChangeNotifier {
  String userID;
  String plantID;
  String placeID;
  int credits;
  String reason;
  DateTime date;
  String image;

  Credits({
    this.userID,
    this.plantID,
    this.placeID,
    this.credits,
    this.reason,
    this.date,
    this.image,
  });

  Credits.fromJson(Map<String, dynamic> json)
      : this.userID = json['userID'],
        this.plantID = json['plantID'],
        this.placeID = json['placeID'],
        this.credits = json['credits'].toint(),
        this.reason = json['reason'],
        this.image = json['image'],
        this.date = json['date'].toDate();
}

import 'package:flutter/material.dart';

class Credits {
  String userID;
  String plantID;
  String placeID;
  int credits;
  String reason;
  DateTime date;

  Credits({
    @required this.userID,
    @required this.plantID,
    @required this.placeID,
    @required this.credits,
    @required this.reason,
    @required this.date,
  });

  Credits.fromJson(Map<String, dynamic> json)
      : this.userID = json['userID'],
        this.plantID = json['plantID'],
        this.placeID = json['placeID'],
        this.credits = json['credits'].toint(),
        this.reason = json['reason'],
        this.date = json['date'].toDate();
}

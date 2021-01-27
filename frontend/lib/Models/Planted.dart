import 'package:flutter/material.dart';

class Planted {
  String userID;
  String plantID;
  String placeID;
  String latitude;
  String longitude;
  List<String> media;
  DateTime date;

  Planted({
    @required this.userID,
    @required this.plantID,
    @required this.placeID,
    this.latitude,
    this.longitude,
    this.media,
    this.date,
  });

  Planted.fromJson(Map<String, dynamic> json)
      : this.userID = json['userID'],
        this.plantID = json['plantID'],
        this.placeID = json['placeID'],
        this.latitude = json['latitude'],
        this.longitude = json['longitude'],
        this.media = List.from(json['media']),
        this.date = json['date'].toDate();
}

import 'package:flutter/material.dart';

class Place {
  String placeID;
  String ownerID;
  bool isPublic;
  String city;
  String latitude;
  String longitude;

  Place({
    @required this.placeID,
    @required this.ownerID,
    @required this.isPublic,
    this.latitude,
    this.longitude,
  });

  Place.fromJson(Map<String, dynamic> json)
      : this.placeID = json['placeID'],
        this.ownerID = json['ownerID'],
        this.isPublic = json['isPublic'],
        this.latitude = json['latitude'],
        this.longitude = json['longitude'];
}

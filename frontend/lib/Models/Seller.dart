import 'package:flutter/material.dart';

class Seller {
  String sellerID;
  String name;
  String latitude;
  String longitude;
  List<String> availablePlants;

  Seller({
    @required this.sellerID,
    @required this.name,
    @required this.latitude,
    @required this.longitude,
  });

  Seller.fromJson(Map<String, dynamic> json)
      : this.sellerID = json['sellerID'],
        this.name = json['name'],
        this.latitude = json['latitude'],
        this.longitude = json['longitude'];
}

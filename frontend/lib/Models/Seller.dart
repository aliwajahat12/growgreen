import 'package:flutter/material.dart';

class Seller with ChangeNotifier {
  String sellerID;
  String name;
  String latitude;
  String longitude;
  List<String> availablePlants;

  Seller({
    this.sellerID,
    this.name,
    this.latitude,
    this.longitude,
  });

  Seller.fromJson(Map<String, dynamic> json)
      : this.sellerID = json['sellerID'],
        this.name = json['name'],
        this.latitude = json['latitude'],
        this.longitude = json['longitude'];
}

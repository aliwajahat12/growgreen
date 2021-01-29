import 'package:flutter/material.dart';

class Plant with ChangeNotifier {
  String plantID;
  String name;
  String pic;
  List<String> growthRequirements;
  List<int> credits;

  Plant({
    this.plantID,
    this.name,
    this.pic,
    this.growthRequirements,
    this.credits,
  });

  Plant.fromJson(Map<String, dynamic> json)
      : this.plantID = json['plantID'],
        this.name = json['name'],
        this.pic = json['pic'],
        this.growthRequirements = json['growthRequirements'],
        this.credits = json['credits'];
}

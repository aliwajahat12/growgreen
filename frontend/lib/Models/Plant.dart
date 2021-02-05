import 'dart:convert';

import 'package:flutter/material.dart';

import 'User.dart';
import 'package:http/http.dart' as http;

class Plant with ChangeNotifier {
  String plantID;
  String name;
  String picture;
  int wateringInterval;
  double wateringAmount;
  double soilPh;
  int plantingCredits;
  int wateringCredits;

  Plant({
    this.plantID,
    this.name,
    this.picture,
    this.wateringInterval,
    this.wateringAmount,
    this.soilPh,
    this.plantingCredits,
    this.wateringCredits,
  });

  Plant.fromJson(Map<String, dynamic> json)
      : this.plantID = json['_id'],
        this.name = json['name'],
        this.picture = json['picture'],
        this.wateringInterval = json['wateringInterval'],
        this.wateringAmount = json['wateringAmount'],
        this.soilPh = json['soilPh'].toDouble(),
        this.plantingCredits = json['plantingCredits'],
        this.wateringCredits = json['wateringCredits'];

  Future<List<Plant>> getPlantList() async {
    List<Plant> _plants = [];
    try {
      print('In Func');
      final response = await http.get(backendLink + 'plant/');
      print(response);
      final responseData = jsonDecode(response.body);
      Iterable list = responseData['plants'];
      _plants = list.map((model) => Plant.fromJson(model)).toList();
    } catch (e) {
      print(e);
    }
    print('Done ');
    return [..._plants];
  }
}

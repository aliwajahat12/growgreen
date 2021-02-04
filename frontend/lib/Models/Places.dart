import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:growgreen/Models/User.dart';
import 'package:growgreen/Models/utils.dart';
import 'package:http/http.dart' as http;

class Place {
  String placeID;
  String ownerID;
  bool isPublic;
  String name;
  String image;
  double latitude;
  double longitude;

  Place({
    this.placeID,
    this.ownerID,
    this.isPublic,
    this.name,
    this.image,
    this.latitude,
    this.longitude,
  });

  Place.fromJson(Map<String, dynamic> json)
      : this.placeID = json['_id'],
        this.ownerID = json['ownerId'],
        this.isPublic = json['isPublic'],
        this.name = json['placeName'],
        this.image = json['placeImage'],
        this.latitude = json['lat'].toDouble(),
        this.longitude = json['long'].toDouble();
}

class Places with ChangeNotifier {
  List<Place> _placeslist;

  Future<List<Place>> getPlaces(String userID) async {
    _placeslist = [];
    try {
      final response = await http.get(backendLink + 'place/$userID');
      final responseData = jsonDecode(response.body);
      Iterable list = responseData['place'];
      _placeslist = list.map((model) => Place.fromJson(model)).toList();
      // _placeslist.forEach((e) {
      //   print('${e.isPublic} ${e.latitude} ${e.longitude} ${e.name}');
      // });
    } catch (e) {
      print(e);
    }
    return [..._placeslist];
  }

  Future<String> addPlace(
      File imageFile, String id, Map<String, dynamic> data) async {
    String msg = '';
    try {
      final imageUrl = await addImage(imageFile, id);
      print(data);
      final response = await http.post(backendLink + 'place/', body: {
        'ownerId': data['ownerId'],
        'isPublic': data['isPublic'].toString(),
        'lat': data['lat'].toString(),
        'long': data['long'].toString(),
        'placeName': data['placeName'],
        'placeImage': backendLinkImage + imageUrl,
        // 'placeImage': '/media/image-upload-1612102786024.jpg'
      });
      print('Returned From Post');
      final responseBody = jsonDecode(response.body);
      print(responseBody);
    } catch (e) {
      msg = e.toString();
      print('Error Returned: $e');
    }

    return msg;
  }
}

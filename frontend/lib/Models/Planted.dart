import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:growgreen/Models/Credits.dart';
import 'package:growgreen/Models/utils.dart';
import 'package:http/http.dart' as http;

import 'User.dart';

class Planted {
  String plantedID;
  String userID;
  String plantID;
  String placeID;
  String nickname;
  String latitude;
  String longitude;
  String media;
  DateTime date;

  Planted({
    this.plantedID,
    this.userID,
    this.plantID,
    this.placeID,
    this.nickname,
    this.latitude,
    this.longitude,
    this.media,
    this.date,
  });

  Planted.fromJson(Map<String, dynamic> json)
      : this.userID = json['userID'],
        this.plantedID = json['plantedID'],
        this.plantID = json['plantID'],
        this.placeID = json['placeID'],
        this.nickname = json['nickname'],
        this.latitude = json['latitude'],
        this.longitude = json['longitude'],
        this.media = json['media'],
        // this.media = List.from(json['media']),
        this.date = json['date'].toDate();
}

class Planteds with ChangeNotifier {
  List<Planted> _plantedList = [];
  Future<String> addUserPlant(
      File imageFile, String id, Map<String, dynamic> data) async {
    String msg = '';

    try {
      final imageUrl = await addImage(imageFile, id);
      print(data);
      final response =
          await http.post(backendLink + 'planted/${data['userId']}', body: {
        'plantId': data['plantId'],
        'lat': data['lat'].toString(),
        'long': data['long'].toString(),
        'nickname': data['nickname'],
        'media': data['plantPic'],
      });
      // print('Returned From Post');
      final responseBody = jsonDecode(response.body);
      print(responseBody);
      if (responseBody['status'] == 'fail') {
        msg = responseBody['reason'];
      } else {
        _plantedList.add(
          Planted(
            plantedID: responseBody['planted_id'],
            userID: data['userId'],
            latitude: data['lat'],
            longitude: data['long'],
            placeID: data['placeId'],
            plantID: data['plantId'],
            nickname: data['nickname'],
            media: data['plantPic'],
            // media: backendLinkImage + imageUrl,
          ),
        );
        Map data1 = {
          'userID': data['userId'],
          'plantID': responseBody['plantId'],
          'placeID': responseBody['place_id'],
          'credits': data['credits'],
          'reason':
              'Added A New Place At Lat: ${data['lat'].toString()} Long: ${data['long'].toString()}',
          'image': backendLinkImage + imageUrl,
        };
        msg = await Credits.addCredits(data1);
      }
    } catch (e) {
      msg = e.toString();
      notifyListeners();
      print('Error Returned: $e');
    }
    return msg;
  }

  Future<List<Planted>> getPlanted(String userID) async {
    _plantedList = [];
    try {
      final response = await http.get(backendLink + 'planted/$userID');
      final responseData = jsonDecode(response.body);
      Iterable list = responseData['planted'];
      _plantedList = list.map((model) => Planted.fromJson(model)).toList();
    } catch (e) {
      print(e);
    }
    return [..._plantedList];
  }
}

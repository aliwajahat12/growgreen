import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:growgreen/Models/utils.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'User.dart';

class Planted {
  String plantedID;
  String userID;
  String plantID;
  String placeID;
  String nickname;
  String latitude;
  String longitude;
  String image;
  DateTime date;
  String plantName;

  Planted(
      {this.plantedID,
      this.userID,
      this.plantID,
      this.placeID,
      this.nickname,
      this.latitude,
      this.longitude,
      this.image,
      this.date,
      this.plantName});

  Planted.fromJson(Map<String, dynamic> json)
      : this.userID = json['userID'],
        this.plantedID = json['plantedID'],
        this.plantID = json['plantID'],
        this.placeID = json['placeID'],
        this.nickname = json['nickname'],
        this.latitude = json['latitude'],
        this.longitude = json['longitude'],
        this.image = json['image'],
        this.plantName = json['plantId']['name'],
        // this.image = List.from(json['image']),
        this.date = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
            .parse(json['date'], true)
            .toLocal();
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
        final newPlant = responseBody['newPlant'];
        _plantedList.add(
          Planted(
            plantedID: newPlant['_id'],
            userID: data['userId'],
            latitude: data['lat'].toString(),
            longitude: data['long'].toString(),
            placeID: data['placeId'],
            plantID: data['plantId'],
            nickname: data['nickname'],
            image: data['plantPic'],
            // image: backendLinkImage + imageUrl,
          ),
        );
        Map<String, dynamic> data1 = {
          'userID': data['userId'],
          // 'plantID': data['plantId'],
          'plantedId': newPlant['_id'],
          'placeID': newPlant['placeId'],
          'credits': data['credits'],
          'isRelatedToPlanted': true,
          'reason':
              'Added A New Plant At Lat: ${data['lat'].toString()} Long: ${data['long'].toString()}',
          'image': backendLinkImage + imageUrl,
        };
        print('Data1 $data1');
        // msg = await Credits.addCredits(data1);
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
    if (_plantedList.isEmpty) {
      try {
        print(userID);
        final response = await http.get(backendLink + 'planted/$userID');
        final responseData = jsonDecode(response.body);
        // print(responseData);
        Iterable list = responseData['planted_details'];
        _plantedList = list.map((model) => Planted.fromJson(model)).toList();
      } catch (e) {
        print(e);
      }
      // _plantedList.forEach((e) {
      //   print(e.plantedID + e.image);
      // });
      // print(_plantedList);
    }
    return [..._plantedList];
  }
}

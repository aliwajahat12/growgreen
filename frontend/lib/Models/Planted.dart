import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:growgreen/Util/AddImageToFirebase.dart';
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
  String location;

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
      this.location,
      this.plantName});

  Planted.fromJson(Map<String, dynamic> json)
      : this.userID = json['userID'],
        this.plantedID = json['_id'],
        this.plantID = json['plantID'],
        this.placeID = json['placeID'],
        this.nickname = json['nickname'],
        // this.latitude = json['placeId']['lat'] ?? '0.0',
        // this.longitude = json['placeId']['long'] ?? '0.0',
        this.image = json['image'],
        this.location = json['location'],
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
      // final imageUrl = await addImage(imageFile, id);
      final imageUrl = await uploadImage(imageFile, id);
      print(data);
      final response =
          await http.post(backendLink + 'planted/${data['userId']}', body: {
        'plantId': data['plantId'],
        'lat': data['lat'].toString(),
        'long': data['long'].toString(),
        'nickname': data['nickname'],
        'media': data['plantPic'],
        'location': data['location'],
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
            location: data['location'],
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
          'image': imageUrl,
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

  List<Planted> getPlantedLocal() {
    return [..._plantedList];
  }

  Future<List<Planted>> getPlanted(String userID) async {
    _plantedList = [];
    if (_plantedList.isEmpty) {
      try {
        print(backendLink + 'planted/userId/$userID');
        final response = await http.get(backendLink + 'planted/userId/$userID');
        final responseData = jsonDecode(response.body);
        // if (responseData['status'] != 'fail') {
        // print(responseData);
        // print(responseData['status']);
        Iterable list = responseData['planted_details'];
        _plantedList = list.map((model) => Planted.fromJson(model)).toList();
        // }
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

  Future<Planted> getPlantDetails(String plantedId) async {
    print('In getplantedDetails');
    Planted plantDetail;
    print(backendLink + 'planted/plantId/$plantedId');
    try {
      final response =
          await http.get(backendLink + 'planted/plantId/$plantedId');
      final responseData = jsonDecode(response.body);
      // print(responseData);
      plantDetail = Planted.fromJson(responseData['plant']);
    } catch (e) {
      print(e);
    }
    return plantDetail;
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';

import 'User.dart';
import 'package:http/http.dart' as http;

class Credits with ChangeNotifier {
  String userID;
  String plantedID;
  // String placeID;
  int credits;
  String reason;
  DateTime date;
  String image;
  int approvalStage;

  Credits(
      {this.userID,
      this.plantedID,
      // this.placeID,
      this.credits,
      this.reason,
      this.date,
      this.image,
      this.approvalStage});

  Credits.fromJson(Map<String, dynamic> json)
      : this.userID = json['userID'],
        this.plantedID = json['plantedID'] ?? null,
        // this.placeID = json['placeID'],
        this.credits = json['credits'].toint(),
        this.reason = json['reason'],
        this.image = json['image'],
        this.approvalStage = json['approvalStage'],
        this.date = json['date'].toDate();

  static Future<String> addCredits(Map<String, dynamic> data) async {
    String msg = '';
    // final imageUrl = await addImage(imageFile, data['userID']);
    try {
      // print(data);
      print(backendLink + 'credit/');
      final data1 = {
        'userId': data['userId'],
        'plantedId': data['plantedId'],
        'isRelatedToPlanted': data['isRelatedToPlanted'],
        'credits': data['credits'],
        'reason': data['reason'],
        'image': data['image'],
        // 'date': DateTime.now().toIso8601String(),
      };
      print(data1);
      final response = await http.post(
        backendLink + 'credit/',
        body: data1.toString(),
      );
      print('Return From Credits Post Req');
      final responseBody = jsonDecode(response.body);
      print(responseBody);
      if (responseBody['status'] == 'fail') {
        msg = responseBody['reason'];
      }
    } catch (e) {
      msg = e.toString();
      print('Error Returned: $e');
    }
    return msg;
  }

  Future<List<Credits>> getPlantedCredits(String plantedId) async {
    List<Credits> _plantedCredits = [];
    try {
      print('In Func');
      print(backendLink + 'credit/$plantedId');
      final response = await http.get(backendLink + 'credit/$plantedId');
      // print(response);
      final responseData = jsonDecode(response.body);
      if (responseData['status'] != 'fail') {
        print('Success');
        Iterable list = responseData['foundPlantsCredits'];
        if (list.length > 0)
          _plantedCredits =
              list.map((model) => Credits.fromJson(model)).toList();
      }
    } catch (e) {
      print(e);
    }
    print('Done ');
    return [..._plantedCredits];
  }
}

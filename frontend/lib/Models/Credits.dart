import 'dart:convert';
import 'package:flutter/material.dart';

import 'User.dart';
import 'package:http/http.dart' as http;

class Credits with ChangeNotifier {
  String userID;
  String plantID;
  String placeID;
  int credits;
  String reason;
  DateTime date;
  String image;

  Credits({
    this.userID,
    this.plantID,
    this.placeID,
    this.credits,
    this.reason,
    this.date,
    this.image,
  });

  Credits.fromJson(Map<String, dynamic> json)
      : this.userID = json['userID'],
        this.plantID = json['plantID'],
        this.placeID = json['placeID'],
        this.credits = json['credits'].toint(),
        this.reason = json['reason'],
        this.image = json['image'],
        this.date = json['date'].toDate();

  static Future<String> addCredits(Map<String, dynamic> data) async {
    String msg = '';
    // final imageUrl = await addImage(imageFile, data['userID']);
    try {
      print(data);
      print(backendLink + 'credit/');
      final response = await http.post(
        backendLink + 'credit/',
        body: {
          'userId': data['userID'],
          'plantId': data['plantID'],
          'isRelatedToPlanted': data['isRelatedToPlanted'].toString(),
          'credits': data['credits'].toString(),
          'reason': data['reason'],
          'image': data['image'],
          'date': DateTime.now().toIso8601String(),
        },
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
}

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
      final response = await http.post(
        backendLink + 'credits/',
        body: {
          'userID': data['userID'],
          'plantID': data['plantID'],
          'placeID': data['placeID'],
          'credits': data['credits'],
          'reason': data['reason'],
          'image': data['image'],
          'date': DateTime.now(),
        },
      );
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

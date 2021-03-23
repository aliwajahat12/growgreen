import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

const backendLink = 'http://10.0.2.2:3000/api/';
const backendLinkImage = 'http://10.0.2.2:3000/';
// const backendLink = 'https://growgreen.azurewebsites.net/api/';
// const backendLinkImage = 'https://growgreen.azurewebsites.net/';

class User with ChangeNotifier {
  String userID;
  String name;
  String email;
  String city;
  String country;
  String address;
  DateTime dob;
  String image;

  User(
      {this.userID,
      this.name,
      this.email,
      this.city,
      this.country,
      this.address,
      this.dob,
      this.image});

  // User.fromJson(Map<String, dynamic> json)
  //     : this.userID = json['userID'],
  //       this.email = json['email'],
  //       this.name = json['name'],
  //       this.city = json['city'],
  //       this.country = json['country'],
  //       this.address = json['address'],
  //       this.dob = json['dob'].toDate();

  Future<String> signUp(String name, String email, String pass) async {
    String msg = '';
    try {
      final response = await http.post(backendLink + 'user/signup',
          body: {'email': email, 'name': name, 'passwd': pass});
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] != 'success')
        msg = responseBody['status'];
      else
        this.userID = responseBody['user_id'];
    } catch (e) {
      msg = e.toString();
      print(e);
    }
    return msg;
  }

  Future<String> signIn(String email, String pass) async {
    String msg = '';
    try {
      final response = await http.post(backendLink + 'user/signin',
          // final response = await http.post('http://localhost:3000/api/user/signin/',
          body: {'email': email, 'passwd': pass});
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] != 'success')
        msg = responseBody['status'];
      else
        this.userID = responseBody['user_id'];
    } catch (e) {
      msg = e.toString();
      print(e);
    }
    return msg;
  }

  Future<void> getUserDetails() async {
    try {
      final response = await http.get(backendLink + 'user/$userID');
      final responseBody1 = jsonDecode(response.body);
      final responseBody = responseBody1['user'];

      this.name = responseBody['name'];
      this.email = responseBody['email'];
      this.address = responseBody['address'];
      this.city = responseBody['city'];
      // this.dob = responseBody['dob'].toDate();
      this.dob = DateFormat("yyyy-MM-ddTHH:mm:ssZ")
          .parse(responseBody['dob'], true)
          .toLocal();
      this.image = responseBody['avatar'];
      this.country = responseBody['country'];
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUserCredits() async {
    int credits = 0;
    // print(userID);
    try {
      final response = await http.get(backendLink + 'user/$userID/credits');
      final responseBody = jsonDecode(response.body);
      credits = responseBody['userCredits'] == null
          ? 0
          : responseBody['userCredits'].toInt();
    } catch (e) {
      print(e);
    }
    return credits;
  }

  Future<String> updateUserInfo(
      String newName, String newCity, String newAdd, DateTime newDob) async {
    String msg = '';
    try {
      final response = await http.put(backendLink + 'user/$userID', body: {
        'name': newName,
        'address': newAdd,
        'city': newCity,
        'dob': newDob.toIso8601String(),
      });
      final responseBody = jsonDecode(response.body);
      if (responseBody['status'] != null)
        // msg = responseBody['error'];
        msg = responseBody.toString();
      else {
        name = newName;
        address = newAdd;
        city = newCity;
        dob = newDob;
      }
    } catch (e) {
      print(e.toString());
      msg = e.toString();
    }
    return msg;
  }
}

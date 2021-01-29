import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:growgreen/Models/User.dart';

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

  Future<String> addPlace(File imageFile, String id) async {
    String msg = '';
    try {
      // open a bytestream
      var stream =
          // ignore: deprecated_member_use
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      // get file length
      var length = await imageFile.length();

      // string to uri
      var uri = Uri.parse(backendLink + 'upload/$id');

      // create multipart request
      var request = new http.MultipartRequest("POST", uri);

      // multipart that takes file
      var multipartFile = new http.MultipartFile('myFile', stream, length,
          filename: basename(imageFile.path));

      // add file to multipart
      request.files.add(multipartFile);

      // send
      var response = await request.send();
      print(response.statusCode);

      // listen for response
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } catch (e) {
      print(e.toString());
      msg = e.toString();
    }
    return msg;
  }
}

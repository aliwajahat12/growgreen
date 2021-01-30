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
    String url = backendLink + 'upload/$id/';
    // try {
    //   // open a bytestream
    //   var stream =
    //       // new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    //       new http.ByteStream(Stream.castFrom(imageFile.openRead()));
    //   // get file length
    //   var length = await imageFile.length();
    //   // string to uri
    //   var uri = Uri.parse(backendLink + 'upload/$id/');
    //   // create multipart request
    //   var request = new http.MultipartRequest("POST", uri);
    //   // multipart that takes file
    //   var multipartFile = new http.MultipartFile('image-upload', stream, length,
    //       filename: basename(imageFile.path));
    //   // add file to multipart
    //   request.files.add(multipartFile);
    //   // send
    //   var response = await request.send();
    //   print(response.statusCode);
    //   // listen for response
    //   response.stream.transform(utf8.decoder).listen((value) {
    //     print(value);
    //   });
    // }
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.files.add(http.MultipartFile('image-upload',
          imageFile.readAsBytes().asStream(), imageFile.lengthSync(),
          filename: imageFile.path.split("/").last));
      var res = await request.send();
      // print(res.stream.);

      final response = await http.Response.fromStream(res);
      final responseData = jsonDecode(response.body);
      print(responseData);
      // listen for response
      // res.stream.transform(utf8.decoder).listen((value) {
      //   print('1-  $value');
      // });
    } catch (e) {
      print('Error In Func: $e');
      msg = e.toString();
    }
    return msg;
  }
}

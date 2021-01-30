import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'User.dart';

Future<String> addImage(File imageFile, String id) async {
  String msg = '';
  String url = backendLink + 'upload/$id/';
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
    if (responseData['status'] == 'success')
      msg = responseData['url'];
    else {
      msg = responseData['reason'];
    }
  } catch (e) {
    print('Error In Func: $e');
    msg = e.toString();
  }
  return msg;
}

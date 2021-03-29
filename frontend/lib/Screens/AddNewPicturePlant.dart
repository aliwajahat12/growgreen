import 'dart:io';

import 'package:flutter/material.dart';
import 'package:growgreen/Models/Credits.dart';
import 'package:growgreen/Models/User.dart';
import 'package:growgreen/Screens/HomeScreen.dart';
import 'package:growgreen/Util/AddImageToFirebase.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddNewPicturePlant extends StatelessWidget {
  static const routeName = '/addNewPicturePlant';
  @override
  Widget build(BuildContext context) {
    final arg =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final imageFile = arg['imageFile'] as PickedFile;
    final plantedId = arg['plantedId'] as String;

    final userId = Provider.of<User>(context, listen: false).userID;
    Future<void> uploadImageAndGiveCredits() async {
      final imageUrl = await uploadImage(File(imageFile.path), userId);
      final data1 = {
        'userId': userId,
        'plantedID': plantedId,
        // 'placeID': responseBody['place_id'],
        'credits': 50,
        'isRelatedToPlanted': true,
        'reason': 'Watered Plant, Planted ID : $plantedId',
        // 'image': backendLinkImage + imageUrl,
        'image': imageUrl,
      };
      await Credits.addCredits(data1);
    }

    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: FutureBuilder(
        future: uploadImageAndGiveCredits(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Please Wait Till The System Verifies The Plant Growth',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'Plant Growth Succeeded.\nPoints Earned: 50',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                          (Route<dynamic> route) => false);
                    },
                    child: Text('Back To Home'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

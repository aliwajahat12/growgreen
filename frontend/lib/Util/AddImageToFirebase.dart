import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

Future<dynamic> uploadImage(File imageFile, String imagePathAndName) async {
  final ref =
      FirebaseStorage.instance.ref().child('ProfilePic/$imagePathAndName');
  await ref.putFile(imageFile).onComplete;
  final imageUrl = await ref.getDownloadURL();
  return imageUrl;
  // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
  // StorageReference reference =
  //     FirebaseStorage.instance.ref().child('CaseCampaign/$caseid/$fileName');
  // StorageUploadTask uploadTask =
  //     reference.putData((await imageFile.getByteData()).buffer.asUint8List());
  // StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
  // // print(storageTaskSnapshot.ref.getDownloadURL());
  // return storageTaskSnapshot.ref.getDownloadURL();
}

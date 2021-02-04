import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:growgreen/Models/Plant.dart';
import 'package:growgreen/Models/User.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/camera-screen';
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  bool isInit = false;
  PickedFile _imageFile;
  // ignore: unused_field
  dynamic _pickImageError;
  // ignore: unused_field
  String _retrieveDataError;
  Position _currentPosition;
  String _currentAddress = '';

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Future<void> _onImageButtonPressed(ImageSource source, bool fromButton,
      {BuildContext context}) async {
    if (!isInit || fromButton) {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
          maxWidth: 600,
          maxHeight: 600,
          imageQuality: 100,
        );
        await _getCurrentLocation();
        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
      isInit = true;
    }
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  notPickedImageText(String text) {
    return Center(
        child: Text(
      text,
      textAlign: TextAlign.center,
    ));
  }

  // Text _getRetrieveErrorWidget() {
  //   if (_retrieveDataError != null) {
  //     final Text result = Text(_retrieveDataError);
  //     _retrieveDataError = null;
  //     return result;
  //   }
  //   return null;
  // }

  // Widget _previewImage() {
  //   final Text retrieveError = _getRetrieveErrorWidget();
  //   if (retrieveError != null) {
  //     return retrieveError;
  //   }
  //   if (_imageFile != null) {
  //     return Image.file(
  //       File(_imageFile.path),
  //       fit: BoxFit.cover,
  //     );
  //   } else if (_pickImageError != null) {
  //     return Text(
  //       'Pick image error: $_pickImageError',
  //       textAlign: TextAlign.center,
  //     );
  //   } else {
  //     return notPickedImageText('You have not yet picked an image.');
  //   }
  // }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imageFile = response.file;
      });
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      // setState(() {
      _currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
      // });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      // setState(() {
      _currentPosition = position;
      print(_currentPosition);
      // });
      await _getAddressFromLatLng();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getImageAndLocation(ImageSource source,
      {BuildContext context}) async {
    await _onImageButtonPressed(ImageSource.camera, false, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    imagePlacer(double height, String link, int i) {
      return Container(
        height: height,
        width: height,
        padding: EdgeInsets.symmetric(horizontal: 5),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
              color: i == 0 ? Colors.white : Color(0xFF218754), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: i == 0
              ? Image.file(
                  File(_imageFile.path),
                  fit: BoxFit.cover,
                )
              : Image.network(
                  link,
                  fit: BoxFit.contain,
                ),
        ),
      );
    }

    plantSelection(int i) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: size.height * 0.20,
          decoration: BoxDecoration(
            color: i == 0 ? Color(0xFF218754) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Row(
            children: [
              imagePlacer(
                  size.height * 0.15,
                  'https://atlas-content-cdn.pixelsquid.com/stock-images/potted-plant-flower-pot-mdm41mF-600.jpg',
                  i),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    i == 0 ? 'New Plant' : 'Giant Sequoia',
                    style: TextStyle(
                      color: i == 0 ? Colors.white : Color(0xFF218754),
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    i == 0
                        ? _currentAddress
                        : 'Block 2 Gulistan e jauhar Karach',
                    style: TextStyle(
                      color: i == 0 ? Colors.white : Color(0xFF218754),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                onPressed: () async {
                  print('Going In Func');
                  await Provider.of<Plant>(context, listen: false).addPlace(
                      File(_imageFile.path),
                      Provider.of<User>(context, listen: false).userID);
                  print('Return From Func');
                },
                icon: Icon(
                  Icons.arrow_forward_ios,
                  color: i == 0 ? Colors.white : Color(0xFF218754),
                ),
              ),
            ],
          ),
        ),
      );
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
      body: SafeArea(
        child: FutureBuilder<void>(
          future: getImageAndLocation(ImageSource.camera, context: context),
          // ignore: missing_return
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(child: CircularProgressIndicator());
              // return notPickedImageText('You have not yet picked an image.');
              case ConnectionState.done:
                if (_imageFile == null) {
                  Navigator.of(context).pop();
                } else {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: size.height * 0.2,
                          color: theme.primaryColor,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: 5,
                              itemBuilder: (ctx, i) => plantSelection(i)),
                        ),
                      ],
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

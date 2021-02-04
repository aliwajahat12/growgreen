import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:growgreen/Models/Planted.dart';
import 'package:growgreen/Models/User.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../SuccessMessageDialog.dart';

class AddNewPlantScreen extends StatefulWidget {
  static const routeName = '/add-plant';
  @override
  _AddNewPlantScreenState createState() => _AddNewPlantScreenState();
}

class _AddNewPlantScreenState extends State<AddNewPlantScreen> {
  FocusNode nameFocusNode;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  // ignore: unused_field
  String _nickname;
  bool _isLoading = false;
  Position _currentPosition;
  String _currentAddress = '';
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  bool isPublic = true;
  int _radioPublicPrivate = 0;

  @override
  initState() {
    nameFocusNode = FocusNode();
    super.initState();
  }

  @override
  dispose() {
    nameFocusNode.dispose();
    super.dispose();
  }

  Future<void> confirmationDialogBox(
      PickedFile imageFile, String userID) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          height: 400.0,
          width: 300.0,
          child: FutureBuilder(
              future: _submit(imageFile, userID),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  final msg = snap.data as String ?? 'Error';
                  // final msg = 'abc';
                  if (msg == '') {
                    return successMessage(context, 'Your Plant Has Been Added');
                  } else {
                    return errorMsg(context, msg);
                  }
                }
              }),
        ),
      ),
    );
  }

  Future<String> _submit(PickedFile imageFile, String userID) async {
    nameFocusNode.unfocus();
    String msg;
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();

      msg = await addPlanted(imageFile, userID);
      // if (msg == '') {
      //   Navigator.of(context).pop();
    } else {
      print('Invalid Entry');
      _failSnackbar(msg);
      // }
    }
    return msg;
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioPublicPrivate = value;

      switch (_radioPublicPrivate) {
        case 0:
          isPublic = true;
          break;
        case 1:
          isPublic = false;
          break;
      }
    });
  }

  Widget _choseFromPublicPrivate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Category', style: new TextStyle(fontSize: 20.0)),
        Radio(
          value: 0,
          groupValue: _radioPublicPrivate,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Public',
          style: new TextStyle(fontSize: 16.0),
        ),
        new Radio(
          value: 1,
          groupValue: _radioPublicPrivate,
          onChanged: _handleRadioValueChange1,
        ),
        new Text(
          'Private',
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
      ],
    );
  }

  Widget _displayLocation() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: _currentAddress == null
          ? CircularProgressIndicator()
          : Text(
              _currentAddress,
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 18),
            ),
    );
  }

  Widget _namefield() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: nameFocusNode,
        // initialValue: name,
        onFieldSubmitted: (_) => nameFocusNode.unfocus(),
        onSaved: (val) => _nickname = val.trim(),
        validator: (val) => val.isEmpty ? 'Field Can not be Left Empty' : null,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          labelText: 'Place Name',
          hintText: 'Enter Place Name',
        ),
      ),
    );
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      _currentAddress = "${place.name}, ${place.locality}, ${place.country}";
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getCurrentLocation() async {
    if (_currentPosition == null) {
      try {
        final position = await geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best);

        _currentPosition = position;
        print(_currentPosition);
        await _getAddressFromLatLng();
      } catch (e) {
        print(e);
      }
    }
  }

  Widget _formActionButton(PickedFile imageFile, String userID) {
    return Padding(
      padding: EdgeInsets.only(top: 40),
      child: _isLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 55,
                  child: RaisedButton(
                    onPressed: () async {
                      await confirmationDialogBox(imageFile, userID);
                      // _submit(imageFile, userID);
                    },
                    child: Text(
                      'Submit',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white, fontSize: 22),
                    ),
                    elevation: 2.0,
                    color: Color(0xFF218754),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _failSnackbar(String e) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Error + $e',
          textAlign: TextAlign.center,
          style: TextStyle(),
        ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<String> addPlanted(PickedFile imageFile, String userID) async {
    var msg = '';
    setState(() {
      _isLoading = true;
    });

    final data = {
      'nickname': _nickname,
      'long': _currentPosition.longitude,
      'lat': _currentPosition.latitude,
      'userId': userID,
      'plantId': '_plantId',
      'credits': 100,
    };
    msg = await Provider.of<Planteds>(context, listen: false)
        .addUserPlant(File(imageFile.path), userID, data);

    setState(() {
      _isLoading = false;
    });
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<User>(context);
    final imageFile = ModalRoute.of(context).settings.arguments as PickedFile;
    final size = MediaQuery.of(context).size;
    _getCurrentLocation();
    Widget _previewImage() {
      return imageFile != null
          ? Container(
              margin: const EdgeInsets.only(top: 20, bottom: 5),
              height: size.height * 0.3,
              width: size.width * 0.7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(
                  File(imageFile.path),
                  fit: BoxFit.cover,
                ),
              ),
            )
          : null;
    }

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              _previewImage(),
              _displayLocation(),
              _choseFromPublicPrivate(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _namefield(),
                          _formActionButton(imageFile, userInfo.userID),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

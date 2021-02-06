import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:growgreen/Models/Plant.dart';
import 'package:growgreen/Models/Planted.dart';
import 'package:growgreen/Models/User.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../widgets/SuccessMessageDialog.dart';

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
  String _currentAddress;
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  bool isPublic = true;
  Plant _selectedPlant;
  List<Plant> _plantList = [];

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
              future: _submitNewPlace(imageFile, userID),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  print('Snap Data ${snap.data}');
                  final msg = snap.data as String ?? 'Error';
                  // final msg = 'abc';
                  if (msg == '') {
                    return successMessage(context,
                        'Your Plantation Has Been Recorded, Keep Up The Good Work!');
                  } else {
                    return errorMsg(context, msg);
                  }
                }
              }),
        ),
      ),
    );
  }

  Future<String> _submitNewPlace(PickedFile imageFile, String userID) async {
    // nameFocusNode.unfocus();
    print('In Func');
    String msg = '';
    print('In Submit');
    final form = _formkey.currentState;
    print('Form');
    // if (form.validate()) {
    print('Form Validated');
    form.save();

    msg = await addPlant(imageFile, userID);
    // if (msg == '') {
    //   Navigator.of(context).pop();
    // } else {
    // msg = 'Form Not Validated';
    // print('Invalid Entry');
    // _failSnackbar(msg);
    // }
    // }
    print('Returning $msg');
    return msg;
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
        // validator: (val) => val.isEmpty ? 'Field Can not be Left Empty' : null,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          labelText: 'Enter Plant Nickname',
          hintText: 'Enter nickname',
        ),
      ),
    );
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.name}, ${place.locality}, ${place.country}";
      });
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

  Future<void> loadPlants() async {
    if (_plantList.isEmpty) {
      final receivedPlantsList =
          await Provider.of<Plant>(context, listen: false).getPlantList();
      print(receivedPlantsList);
      setState(() {
        _plantList = receivedPlantsList;
      });
    }
  }

  getPlantName() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: _plantList.isEmpty
          ? CircularProgressIndicator()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_selectedPlant == null
                    ? 'Select Plant'
                    : _selectedPlant.name),
                DropdownButton<Plant>(
                  items: _plantList.map((e) {
                    return new DropdownMenuItem<Plant>(
                      value: e,
                      child: Text(e.name),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedPlant = val;
                    });
                  },
                ),
              ],
            ),
    );
  }

  Widget _formActionButton(PickedFile imageFile, String userID) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: _isLoading
          ? CircularProgressIndicator()
          : Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 55,
                  child: RaisedButton(
                    onPressed: () async {
                      nameFocusNode.unfocus();
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

  // void _failSnackbar(String e) {
  //   final snackBar = SnackBar(
  //       behavior: SnackBarBehavior.floating,
  //       content: Text(
  //         'Error + $e',
  //         textAlign: TextAlign.center,
  //         style: TextStyle(),
  //       ));
  //   _scaffoldKey.currentState.showSnackBar(snackBar);
  // }

  Future<String> addPlant(PickedFile imageFile, String userID) async {
    var msg = '';
    print('In Add Plant');
    // setState(() {
    //   _isLoading = true;
    // });

    if (_selectedPlant == null) {
      msg = 'Please Select Plant';
      return msg;
    }

    final data = {
      'nickname': _nickname,
      'long': _currentPosition.longitude,
      'lat': _currentPosition.latitude,
      'userId': userID,
      'plantId': _selectedPlant.plantID,
      'credits': _selectedPlant.plantingCredits,
      'plantPic': _selectedPlant.picture,
    };
    msg = await Provider.of<Planteds>(context, listen: false)
        .addUserPlant(File(imageFile.path), userID, data);
    print('Return $msg');

    // setState(() {
    //   _isLoading = false;
    // });
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

    loadPlants();
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: GestureDetector(
                  onTap: () {
                    nameFocusNode.unfocus();
                  },
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _namefield(),
                            getPlantName(),
                            _formActionButton(imageFile, userInfo.userID),
                          ],
                        ),
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

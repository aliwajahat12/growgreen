import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:growgreen/Models/Places.dart';
import 'package:growgreen/Models/User.dart';
import 'package:provider/provider.dart';

import '../widgets/SuccessMessageDialog.dart';

class AddNewPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';
  @override
  _AddNewPlaceScreenState createState() => _AddNewPlaceScreenState();
}

class _AddNewPlaceScreenState extends State<AddNewPlaceScreen> {
  FocusNode nameFocusNode;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  // ignore: unused_field
  String _name;
  bool _isLoading = false;
  Position _currentPosition;
  String _currentAddress = '';
  String latLong = '';
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  bool isPublic = true;
  // int _radioPublicPrivate = 0;

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

  Future<String> _submit(
      // PickedFile imageFile,
      String userID) async {
    print('In Submit');
    // nameFocusNode.unfocus();
    var msg = '';
    final form = _formkey.currentState;
    form.save();

    msg = await addPlace(
        // imageFile,
        userID);
    return msg;
  }

  Widget _displayLocation() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15.0),
      child: _currentAddress == null
          ? CircularProgressIndicator()
          : Column(
              children: [
                Text(
                  "Current Location",
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 18),
                ),
                Text(
                  latLong,
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 18),
                ),
                Text(
                  _currentAddress,
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 18),
                ),
              ],
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
        onSaved: (val) => _name = val.trim(),
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
      setState(() {
        _currentAddress = "${place.name}, ${place.locality}, ${place.country}";
        latLong = "${_currentPosition.latitude},${_currentPosition.longitude}";
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

  Widget _formActionButton(
      // PickedFile imageFile,
      String userID) {
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
                      await confirmationDialogBox(
                          // imageFile,
                          userID);
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

  Future<String> addPlace(
      // PickedFile imageFile,
      String userID) async {
    var msg = '';
    // setState(() {
    //   _isLoading = true;
    // });
    final data = {
      'placeName': _name,
      'isPublic': true,
      'long': _currentPosition.longitude,
      'lat': _currentPosition.latitude,
      'ownerId': userID,
      'image':
          'https://maps.googleapis.com/maps/api/staticmap?center=${_currentPosition.latitude},${_currentPosition.longitude}&zoom=21&size=512x512&format=jpg&maptype=satellite&key=AIzaSyCr0-s_qBQozzmLIAzQvnUWwRSQUMuhwN4',
    };
    msg = await Provider.of<Places>(context, listen: false).addPlace(
        // File(imageFile.path),
        userID,
        data);

    // setState(() {
    //   _isLoading = false;
    // });
    return msg;
  }

  Future<void> confirmationDialogBox(
      // PickedFile imageFile,
      String userID) async {
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
              future: _submit(
                  // imageFile,
                  userID),
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
                        'Your Place Has Been Recorded, Keep Up The Good Work!');
                  } else {
                    return errorMsg(context, msg);
                  }
                }
              }),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<User>(context);
    // final imageFile = ModalRoute.of(context).settings.arguments as PickedFile;
    final size = MediaQuery.of(context).size;
    _getCurrentLocation();
    Widget _previewImage() {
      return _currentAddress != ''
          ? Container(
              margin: const EdgeInsets.only(top: 20, bottom: 5),
              height: size.height * 0.3,
              width: size.width * 0.7,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  // File(imageFile.path),
                  'https://maps.googleapis.com/maps/api/staticmap?center=${_currentPosition.latitude},${_currentPosition.longitude}&zoom=21&size=512x512&format=jpg&maptype=satellite&key=AIzaSyCr0-s_qBQozzmLIAzQvnUWwRSQUMuhwN4',
                  fit: BoxFit.contain,
                ),
              ),
            )
          : Container();
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
          child: Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _previewImage(),
                _displayLocation(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _namefield(),
                            _formActionButton(
                                // imageFile,
                                userInfo.userID),
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
      ),
    );
  }
}

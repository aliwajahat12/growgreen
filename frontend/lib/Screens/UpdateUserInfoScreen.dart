import 'package:flutter/material.dart';
import 'package:growgreen/Models/User.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UpdateUserInfoScreen extends StatefulWidget {
  static const routeName = '/update-info';
  @override
  _UpdateUserInfoScreenState createState() => _UpdateUserInfoScreenState();
}

class _UpdateUserInfoScreenState extends State<UpdateUserInfoScreen> {
  FocusNode nameFocusNode, cityFocusNode, addressFocusNode;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  // ignore: unused_field
  String _name, _city, _address;
  DateTime _dob = DateTime.now();
  bool _isLoading = false;

  @override
  initState() {
    nameFocusNode = FocusNode();
    cityFocusNode = FocusNode();
    addressFocusNode = FocusNode();
    super.initState();
  }

  @override
  dispose() {
    nameFocusNode.dispose();
    cityFocusNode.dispose();
    addressFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    nameFocusNode.unfocus();
    cityFocusNode.unfocus();
    addressFocusNode.unfocus();

    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      var msg = await _updateUserInfo();
      if (msg == '') {
        // if (!isLogin) {
        Navigator.of(context).pop();
      } else {
        print('Invalid Entry');
        _failSnackbar(msg);
      }
    }
  }

  _displayImage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Image.asset(
          'assets/logoWhite.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _namefield(String name) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: nameFocusNode,
        initialValue: name,
        onFieldSubmitted: (_) => cityFocusNode.requestFocus(),
        onSaved: (val) => _name = val.trim(),
        validator: (val) => val.isEmpty ? 'Field Can not be Left Empty' : null,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          labelText: 'Full Name',
          hintText: 'Enter Full Name',
        ),
      ),
    );
  }

  Widget _cityfield(String city) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: cityFocusNode,
        initialValue: city,
        onFieldSubmitted: (_) => addressFocusNode.requestFocus(),
        onSaved: (val) => _city = val.trim(),
        validator: (val) => val.isEmpty ? 'Field Can not be Left Empty' : null,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          labelText: 'City',
          hintText: 'Enter City',
        ),
      ),
    );
  }

  Widget _addressfield(String address) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        initialValue: address,
        focusNode: addressFocusNode,
        onFieldSubmitted: (_) => addressFocusNode.unfocus(),
        onSaved: (val) => _address = val.trim(),
        validator: (val) => val.isEmpty ? 'Field Can not be Left Empty' : null,
        keyboardType: TextInputType.multiline,
        maxLines: 3,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          labelText: 'Address',
          hintText: 'Enter Address',
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime dob) async {
    FocusScope.of(context).unfocus();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: dob,
        firstDate: DateTime(1950),
        lastDate: DateTime.now());
    if (picked != null && picked != _dob)
      setState(() {
        _dob = picked;
      });
  }

  Widget _dobWidget(context, DateTime dob) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date Of Birth'),
            Text(
              '${DateFormat.yMMMd().format(_dob)}' ??
                  '${DateFormat.yMMMd().format(dob)}',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => _selectDate(context, dob),
          icon: Icon(
            Icons.date_range,
            size: 35,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _formActionButton() {
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
                    onPressed: _submit,
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

  Future<String> _updateUserInfo() async {
    var msg = '';
    setState(() {
      _isLoading = true;
    });
    msg = await Provider.of<User>(context, listen: false)
        .updateUserInfo(_name, _city, _address, _dob);
    print('After Update Msg : $msg');

    setState(() {
      _isLoading = false;
    });
    return msg;
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<User>(context);
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
              _displayImage(),
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
                          _namefield(userInfo.name),
                          _cityfield(userInfo.city),
                          _addressfield(userInfo.address),
                          _dobWidget(context, userInfo.dob),
                          _formActionButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // ),
      ),
    );
  }
}

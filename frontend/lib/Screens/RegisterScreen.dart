import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register-screen';
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FocusNode emailFocusNode, passwordFocusNode, nameFocusNode;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  bool _showpass = false;
  // ignore: unused_field
  String _email, _pass, _name;
  bool _isLoading = false;
  bool isLogin = true;

  @override
  initState() {
    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();
    nameFocusNode = FocusNode();
    super.initState();
  }

  @override
  dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    nameFocusNode.dispose();
    super.dispose();
  }

  void _submit() async {
    emailFocusNode.unfocus();
    nameFocusNode.unfocus();
    passwordFocusNode.unfocus();

    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      var msg = await _registerUser();
      // .then((value) {
      if (msg == '') {
        if (!isLogin) {
          // Navigator.of(context)
          //     .pushReplacementNamed(RegisterUserDetailScreen.routeName);
        } else {
          // Navigator.of(context).pushNamedAndRemoveUntil(
          //     NavigationScreen.routeName, (route) => false);
          // Navigator.popUntil(
          //     context, ModalRoute.withName(Navigator.defaultRouteName));
        }
        // });
      } else {
        print('Invalid Entry');
        _failSnackbar(msg);
      }
    }
  }

  _displayImage() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      child: Image.asset(
        'assets/logoHorizontal.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget switchLoginSignup() {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      width: mediaQuery.width * 0.604,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).accentColor, width: 0.7),
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: mediaQuery.height * 0.1,
            width: mediaQuery.width * 0.3,
            child: RaisedButton(
              elevation: 0,
              onPressed: isLogin
                  ? null
                  : () {
                      setState(() {
                        isLogin = true;
                      });
                    },
              child: Text(
                'Sign In',
                style: TextStyle(
                  color: isLogin ? Colors.white : Theme.of(context).accentColor,
                  fontSize: 25,
                ),
              ),
              color: isLogin ? Theme.of(context).accentColor : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
            ),
          ),
          Container(
            height: mediaQuery.height * 0.1,
            width: mediaQuery.width * 0.3,
            child: RaisedButton(
              elevation: 0,
              onPressed: !isLogin
                  ? null
                  : () {
                      setState(() {
                        isLogin = false;
                      });
                    },
              child: Text(
                'Sign Up',
                style: TextStyle(
                  color:
                      !isLogin ? Colors.white : Theme.of(context).accentColor,
                  fontSize: 25,
                ),
              ),
              color: !isLogin ? Theme.of(context).accentColor : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emailfield() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        focusNode: emailFocusNode,
        keyboardType: TextInputType.emailAddress,
        onFieldSubmitted: (_) => passwordFocusNode.requestFocus(),
        onSaved: (val) => _email = val.trim(),
        validator: (val) => !val.contains('@') ? 'Invalid Email Address' : null,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          labelText: 'Email',
          hintText: 'Enter Email Address',
        ),
      ),
    );
  }

  Widget _namefield() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        focusNode: nameFocusNode,
        onFieldSubmitted: (_) => _submit(),
        onSaved: (val) => _name = val.trim(),
        validator: (val) => val.isEmpty ? 'Field Can not be Lfe Empty' : null,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          labelText: 'Full Name',
          hintText: 'Enter Full Name',
          // icon: Icon(Icons.phone)
        ),
      ),
    );
  }

  Widget _passwordfield() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(top: 20),
      child: TextFormField(
        textInputAction: isLogin ? TextInputAction.done : TextInputAction.next,
        focusNode: passwordFocusNode,
        onSaved: (val) => _pass = val.trim(),
        validator: (val) => val.length < 6 ? 'Password Too Short' : null,
        obscureText: _showpass ? false : true,
        onFieldSubmitted: (a) =>
            isLogin ? _submit() : nameFocusNode.requestFocus(),
        decoration: InputDecoration(
          suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _showpass = !_showpass;
                });
              },
              child: Icon(_showpass ? Icons.visibility_off : Icons.visibility)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          labelText: 'Password',
          hintText: 'Enter password. Min Length 6',
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
                      isLogin ? 'Sign In' : 'Sign Up',
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
          e,
          textAlign: TextAlign.center,
          style: TextStyle(),
        ));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<String> _registerUser() async {
    var msg = '';
    setState(() {
      _isLoading = true;
    });
    if (isLogin) {
      // msg = await Provider.of<UserClass.User>(context, listen: false)
      //     .signIn(_email, _pass);
    } else {
      // msg = await Provider.of<UserClass.User>(context, listen: false)
      //     .registerUser(_email, _pass, _phone);
      // .then((value) => Navigator.of(context)
      //     .pushNamed(RegisterUserDetailScreen.routeName));
    }
    print('After SignIn SignUp Msg : $msg');
    // _successSnackbar();
    // if (FirebaseAuth.instance.currentUser == null) {
    //   _redirectUser();
    // } else {
    // print(responseData['message']);
    // _failSnackbar('Error Signing In');
    // }
    // } catch (e) {
    //   print(e);
    //   _failSnackbar(e);
    // }
    // }
    setState(() {
      _isLoading = false;
    });
    return msg;
    // Navigator.popUntil(
    //     context, ModalRoute.withName(Navigator.defaultRouteName));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _displayImage(),
              switchLoginSignup(),
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
                          _emailfield(),
                          _passwordfield(),
                          if (!isLogin) _namefield(),
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

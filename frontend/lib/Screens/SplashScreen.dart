import 'package:flutter/material.dart';
import 'package:growgreen/Screens/HomeScreen.dart';
import 'package:splashscreen/splashscreen.dart' as ss;

class SplashScreen extends StatefulWidget {
  static const routeName = '/splashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    Future<Widget> wait5Sec() async {
      await Future.delayed(const Duration(seconds: 4));
      // isLoggedIn = Provider.of<ClassUser.User>(context, listen: false).loggedIn;
      return Future.value(
          // isLoggedIn ? MainScreen() : UserOrganizationSelectScreen()
          HomeScreen());
    }

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        child: ss.SplashScreen(
          navigateAfterFuture: wait5Sec(),
          image: Image.asset(
            'assets/logoVertical.png',
            fit: BoxFit.contain,
          ),
          useLoader: false,
          // backgroundColor: Colors.white,
          // loadingText: Text(
          //   'Developed By\nSkynners Pvt. Ltd.',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 15,
          //   ),
          // ),
          photoSize: MediaQuery.of(context).size.width * 0.4,
        ),
      ),
    );
  }
}

// class NavigationScreen extends StatelessWidget {
//   static const routeName = '/navigation-screen';
//   @override
//   Widget build(BuildContext context) {
//     final isLoggedIn =
//         Provider.of<ClassUser.User>(context, listen: false).loggedIn;
//     print('Is Logged In:  $isLoggedIn');
//     return isLoggedIn ? MainScreen() : UserOrganizationSelectScreen();
//   }
// }

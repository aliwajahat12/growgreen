import 'package:flutter/material.dart';
import 'package:growgreen/Screens/LeaderboardScreen.dart';
import 'package:growgreen/Screens/PlantDetailScreen.dart';
import 'package:growgreen/Screens/ProfilePage.dart';
import 'package:growgreen/Screens/RegisterScreen.dart';
import 'package:growgreen/Screens/SplashScreen.dart';

import 'Screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return
        // MultiProvider(
        //   providers: [
        //     // ChangeNotifierProvider<UserClass.User>(create: (_) => UserClass.User()),
        //   ],
        //   child:
        MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff4BAD9A),
        accentColor: Color(0xff565656),
        // accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'ProductSans',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
          bodyText1: TextStyle(fontSize: 18.0),
        ),
      ),
      home: SplashScreen(),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        ProfilePage.routeName: (ctx) => ProfilePage(),
        RegisterScreen.routeName: (ctx) => RegisterScreen(),
        PlantDetailScreen.routeName: (ctx) => PlantDetailScreen(),
        LeaderBoardScreen.routeName: (ctx) => LeaderBoardScreen(),
      },
      // ),
    );
  }
}

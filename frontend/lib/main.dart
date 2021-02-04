import 'package:flutter/material.dart';
import 'package:growgreen/Models/Credits.dart';
import 'package:growgreen/Models/Leaderboard.dart';
import 'package:growgreen/Models/Places.dart';
import 'package:growgreen/Models/Plant.dart';
import 'package:growgreen/Models/Planted.dart';
import 'package:growgreen/Models/Seller.dart';
import 'package:growgreen/Screens/AddNewPlaceScreen.dart';
import 'package:growgreen/Screens/CameraScreen.dart';
import 'package:growgreen/Screens/LeaderboardScreen.dart';
import 'package:growgreen/Screens/PlacesListScreen.dart';
import 'package:growgreen/Screens/PlantDetailScreen.dart';
import 'package:growgreen/Screens/ProfilePage.dart';
import 'package:growgreen/Screens/RegisterScreen.dart';
import 'package:growgreen/Screens/SplashScreen.dart';
import 'package:growgreen/Screens/UpdateUserInfoScreen.dart';
import 'package:provider/provider.dart';

import 'Models/User.dart';
import 'Screens/HomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<User>(create: (_) => User()),
        ChangeNotifierProvider<Credits>(create: (_) => Credits()),
        ChangeNotifierProvider<Places>(create: (_) => Places()),
        ChangeNotifierProvider<Plant>(create: (_) => Plant()),
        ChangeNotifierProvider<Planted>(create: (_) => Planted()),
        ChangeNotifierProvider<Seller>(create: (_) => Seller()),
        ChangeNotifierProvider<Leaderboard>(create: (_) => Leaderboard()),
      ],
      child: MaterialApp(
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
          CameraScreen.routeName: (ctx) => CameraScreen(),
          UpdateUserInfoScreen.routeName: (ctx) => UpdateUserInfoScreen(),
          PlacesListScreen.routeName: (ctx) => PlacesListScreen(),
          AddNewPlaceScreen.routeName: (ctx) => AddNewPlaceScreen(),
        },
      ),
    );
  }
}

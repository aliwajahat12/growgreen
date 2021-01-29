import 'package:flutter/material.dart';
import 'package:growgreen/Models/User.dart';
import 'package:growgreen/widgets/homeScreen/Sidebar.dart';
import 'package:growgreen/widgets/homeScreen/UserPlants.dart';
import 'package:growgreen/widgets/homeScreen/calender.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/homeScreen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.only(right: 12.0),
              alignment: Alignment.centerRight,
              height: mediaQuery.size.height * 0.07,
              child: Image.asset(
                'assets/logoWhite.png',
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 12.0),
              child: Text(
                'Welcome Back !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 12.0),
              child: FutureBuilder(
                future: Provider.of<User>(context).getUserCredits(),
                builder: (ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return Text(
                      'Credits: ${snap.data}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            CalenderHome(mediaQuery.size.height * 0.1),
            SizedBox(
              height: 25,
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Sidebar(),
                  ),
                  Expanded(
                    flex: 8,
                    child: UserPlants(),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

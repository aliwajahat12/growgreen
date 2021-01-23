import 'package:flutter/material.dart';
import 'package:growgreen/Screens/ProfilePage.dart';
import 'package:growgreen/Screens/RegisterScreen.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 55,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: IconButton(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(RegisterScreen.routeName);
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(ProfilePage.routeName);
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {}),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: IconButton(
                icon: Icon(
                  Icons.leaderboard,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () {}),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: IconButton(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 35,
                ),
                onPressed: () {}),
          ),
        ],
      ),
    );
  }
}

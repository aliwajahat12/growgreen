import 'package:flutter/material.dart';
import 'package:growgreen/Models/Places.dart';
import 'package:growgreen/Models/User.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  static const routeName = '/places-list';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: Provider.of<Places>(context, listen: false).getPlaces(
            user.userID,
          ),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final places = snap.data as List<Place>;
              return Container(
                child: Text('done'),
              );
            }
          },
        ),
      ),
    );
  }
}

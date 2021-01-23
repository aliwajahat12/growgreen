import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CalenderHome extends StatelessWidget {
  final height;
  CalenderHome(this.height);

  String dayToString(int d) {
    if (d == 1) {
      return 'Mon';
    } else if (d == 2) {
      return 'Tue';
    } else if (d == 3) {
      return 'Wed';
    } else if (d == 4) {
      return 'Thu';
    } else if (d == 5) {
      return 'Fri';
    } else if (d == 6) {
      return 'Sat';
    } else
      return 'Sun';
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final width = MediaQuery.of(context).size.width;
    final widthEachItem = width / 8.5;

    Widget calenderItem(DateTime date) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        width: widthEachItem,
        height: height * 0.9,
        decoration: BoxDecoration(
          // border: Border.all(width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          color: date.day == DateTime.now().day
              ? Color(0xffFBB03B)
              : Theme.of(context).primaryColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                dayToString(date.weekday),
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                date.day.toString(),
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        itemBuilder: (ctx, i) => calenderItem(
          currentDate.add(
            Duration(days: i),
          ),
        ),
      ),
    );
  }
}

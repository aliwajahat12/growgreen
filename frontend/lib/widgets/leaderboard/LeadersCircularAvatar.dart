import 'package:flutter/material.dart';

class LeadersCircularAvatar extends StatelessWidget {
  final double width;
  final name;
  final score;
  final position;
  final imageUrl;
  LeadersCircularAvatar(
      {this.width, this.name, this.score, this.position, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width,
          height: width * 0.9,
          child: Stack(
            children: [
              Positioned(
                left: 5,
                top: 5,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: width / 2.3,
                  backgroundImage: NetworkImage(
                    imageUrl != ''
                        ? imageUrl
                        : 'https://www.pinclipart.com/picdir/middle/128-1286122_business-person-icon-clipart.png',
                    // fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                  top: 0,
                  left: 0,
                  child: CircleAvatar(
                    backgroundColor: Color(0xFFFBB03B),
                    radius: width / 6,
                    child: Text(
                      position,
                      style: TextStyle(color: Colors.white),
                    ),
                  ))
            ],
          ),
        ),
        Text(name,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18)),
        Container(
          width: 35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            // color: Colors.white
          ),
          child: Text(
            score,
            textAlign: TextAlign.center,
            style: TextStyle(
                // color: Theme.of(context).primaryColor,
                color: Colors.white,
                fontSize: 16),
          ),
        ),
      ],
    );
  }
}

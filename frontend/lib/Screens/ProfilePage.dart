import 'package:flutter/material.dart';
import 'package:growgreen/Models/User.dart';
import 'package:growgreen/Screens/UpdateUserInfoScreen.dart';
import 'package:growgreen/widgets/profilepage/semiCircle.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = Provider.of<User>(context);

    iconButtonWidget(IconData icon, Function func) {
      return Container(
        // alignment: Alignment.centerLeft,
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: const Color(0xFFFFFFFF).withOpacity(0.85),
        ),
        child: IconButton(
            icon: Icon(
              icon,
              color: Theme.of(context).accentColor,
              size: 35,
            ),
            onPressed: func),
      );
    }

    textHeading(String text) {
      return Text(
        text,
        style: TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
      );
    }

    textDetails(String text) {
      return Text(
        text,
        maxLines: 5,
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
      );
    }

    detailRowWidget(String text1, String text2, String text3, String text4) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textHeading(text1),
                    textDetails(text2),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textHeading(text3),
                    textDetails(text4),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
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
      body: FutureBuilder(
        future: user.getUserDetails(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Container(
                  height: size.height * 0.42,
                  child: Stack(
                    children: [
                      // background
                      SemiCircle(
                        diameter: size.width,
                      ),
                      //profile Image
                      Positioned(
                        left: size.width * 0.33,
                        child: Container(
                          height: size.height * 0.2,
                          width: size.width * 0.3,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Image.network(
                            user.image ??
                                'https://www.clipartkey.com/mpngs/m/151-1515360_transparent-profile-clipart-male-user-icon.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      //help button
                      Positioned(
                          top: size.height * 0.18,
                          left: size.width * 0.05,
                          child: iconButtonWidget(Icons.help, () {})),
                      //camera Button
                      Positioned(
                        top: size.height * 0.28,
                        left: size.width * 0.25,
                        child: iconButtonWidget(Icons.photo_camera, () {}),
                      ),
                      //Edit Button
                      Positioned(
                        top: size.height * 0.28,
                        right: size.width * 0.25,
                        child: iconButtonWidget(Icons.edit, () {
                          Navigator.of(context)
                              .pushNamed(UpdateUserInfoScreen.routeName);
                        }),
                      ),
                      //Delete Button
                      Positioned(
                        top: size.height * 0.18,
                        right: size.width * 0.05,
                        child: iconButtonWidget(Icons.delete, () {}),
                      ),
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      detailRowWidget(
                          'NAME', user.name, 'PASSWORD', '********'),
                      detailRowWidget('EMAIL', user.email, 'DOB',
                          DateFormat.yMMMd().format(user.dob)),
                      // detailRowWidget(
                      //     'COUNTRY', user.country, 'CITY', user.city),
                      detailRowWidget(
                          'CITY', user.city, 'ADDRESS', user.address),
                      // detailRowWidget(
                      //     'STATE', 'Sindh', 'ADDRESS', user.address),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

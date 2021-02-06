import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:growgreen/Models/Planted.dart';
import 'package:growgreen/Models/User.dart';
import 'package:growgreen/Screens/PlantDetailScreen.dart';
import 'package:provider/provider.dart';

class UserPlants extends StatelessWidget {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  // Future<String> _getAddressFromLatLng(Planted plantedItem) async {
  //   try {
  //     print('${plantedItem.latitude} ${plantedItem.longitude}');
  //     // List<Placemark> p = await geolocator.placemarkFromCoordinates(lat, long);
  //     // print('PlaceMark $p');
  //     // Placemark place = p[0];

  //     // return "${place.name}, ${place.locality}, ${place.country}";
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    userPlantItem(double height1, double width, Planted plantedItem) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(PlantDetailScreen.routeName);
        },
        child: Container(
          height: height1,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 8),
                width: width * 0.3,
                height: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  border: Border.all(
                    color: Theme.of(context).accentColor,
                    width: 1,
                  ),
                ),
                child: Image.network(
                  plantedItem.image,
                  // 'https://atlas-content-cdn.pixelsquid.com/stock-images/potted-plant-flower-pot-mdm41mF-600.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      plantedItem.nickname,
                      textAlign: TextAlign.center,
                      // 'Giant Sequoia',
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                    // FutureBuilder(
                    //     future: _getAddressFromLatLng(plantedItem),
                    //     builder: (ctx, snap) {
                    //       if (snap.connectionState != ConnectionState.waiting) {
                    // return
                    Text(
                      plantedItem.plantName,
                      // 'Block 2, Gulshan-e-Iqbal, Karachi',
                      maxLines: 3,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          color: Theme.of(context).accentColor, fontSize: 12),
                    ),
                    //   } else {
                    //     return Container(
                    //       height: 10,
                    //       width: 10,
                    //       child: CircularProgressIndicator(
                    //         strokeWidth: 1,
                    //       ),
                    //     );
                    //   }
                    // })
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(70.0)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: FutureBuilder(
            future: Provider.of<Planteds>(context, listen: false)
                .getPlanted(Provider.of<User>(context, listen: false).userID),
            builder: (ctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                final userPlants = snap.data as List<Planted>;
                if (userPlants == null || userPlants.isEmpty) {
                  return Center(
                    child: Text('No Plants Planted'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: userPlants.length,
                    itemBuilder: (ctx, i) => userPlantItem(
                      constraints.maxHeight / 3.25,
                      constraints.maxWidth,
                      userPlants[i],
                    ),
                  );
                }
              }
            },
          ),
        ),
      ),
    );
  }
}

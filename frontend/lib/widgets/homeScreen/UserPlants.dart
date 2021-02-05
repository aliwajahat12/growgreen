import 'package:flutter/material.dart';
import 'package:growgreen/Models/Planted.dart';
import 'package:growgreen/Screens/PlantDetailScreen.dart';

class UserPlants extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    userPlantItem(
      double height1,
      double width,
      //  Planted plantedItem
    ) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(PlantDetailScreen.routeName);
        },
        child: Container(
          height: height1,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
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
                  // plantedItem.media,
                  'https://atlas-content-cdn.pixelsquid.com/stock-images/potted-plant-flower-pot-mdm41mF-600.jpg',
                  fit: BoxFit.contain,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // plantedItem.nickname,
                    'Giant Sequoia',
                    style: TextStyle(
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  FutureBuilder(
                      future: null,
                      builder: (ctx, snap) {
                        // if (snap.hasData) {
                        return Text(
                          'Block 2, Gulshan-e-Iqbal, Karachi',
                          maxLines: 3,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                              color: Theme.of(context).accentColor,
                              fontSize: 12),
                        );
                        // } else {
                        //   return Container(
                        //     height: 10,
                        //     width: 10,
                        //     child: CircularProgressIndicator(
                        //       strokeWidth: 1,
                        //     ),
                        //   );
                        // }
                      })
                ],
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
              future: null,
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  // final userPlants = snap.data as List<Planted>;
                  // if (userPlants == null || userPlants.isEmpty) {
                  //   return Center(
                  //     child: Text('No Plants Planted'),
                  //   );
                  // } else {
                  return ListView.builder(
                    itemCount: 3,
                    itemBuilder: (ctx, i) => userPlantItem(
                      constraints.maxHeight / 3.25,
                      constraints.maxWidth,
                      // userPlants[i],
                    ),
                  );
                }
              }
              // },
              ),
        ),
      ),
    );
  }
}

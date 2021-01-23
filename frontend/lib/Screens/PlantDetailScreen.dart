import 'package:flutter/material.dart';

class PlantDetailScreen extends StatelessWidget {
  static const routeName = '/plantDetail';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    imagePlacer(double height, String link) {
      return Container(
        height: height,
        width: height,
        padding: EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            link,
            fit: BoxFit.contain,
          ),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: size.height * 0.35,
                  color: theme.primaryColor,
                ),
                Positioned(
                  // top: size.height * 0.05,
                  right: size.width * 0.05,
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Positioned(
                  top: size.height * 0.07,
                  left: size.width * 0.05,
                  child: imagePlacer(size.height * 0.22,
                      'https://atlas-content-cdn.pixelsquid.com/stock-images/potted-plant-flower-pot-mdm41mF-600.jpg'),
                ),
                Positioned(
                  top: size.height * 0.1,
                  right: size.width * 0.05,
                  child: Container(
                    width: size.width * 0.5,
                    height: size.height * 0.3,
                    child: Column(
                      children: [
                        Text(
                          'Giant Sequoia',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Block 2 Gulistan e jauhar Karachi',
                          style: TextStyle(color: Colors.white, fontSize: 13),
                        ),
                        Container(
                          width: size.width * 0.5,
                          height: size.height * 0.1,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) => imagePlacer(
                                size.height * 0.075,
                                'https://atlas-content-cdn.pixelsquid.com/stock-images/potted-plant-flower-pot-mdm41mF-600.jpg'),
                            itemCount: 4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

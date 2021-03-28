import 'package:flutter/material.dart';
import 'package:growgreen/Models/Credits.dart';
import 'package:growgreen/Models/Planted.dart';
import 'package:growgreen/Screens/CameraScreen.dart';
import 'package:provider/provider.dart';

class PlantDetailScreen extends StatelessWidget {
  static const routeName = '/plantDetail';
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final plantedId = ModalRoute.of(context).settings.arguments as String;
    Planted plantDetail;
    List<Credits> plantedDetails;

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

    headerText(String text) {
      return Text(text,
          style: TextStyle(fontSize: 18), textAlign: TextAlign.center);
    }

    headerRow() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 6),
        child: Row(
          children: [
            Expanded(flex: 2, child: headerText('Date')),
            Expanded(flex: 6, child: headerText('Approval')),
            Expanded(flex: 3, child: headerText('Earnings')),
          ],
        ),
      );
    }

    String approvalStageToString(int approvalStage) {
      String status = '';
      switch (approvalStage) {
        case 0:
          {
            status = 'Pending';
          }
          break;
        case 1:
          {
            status = 'Approved';
          }
          break;
        case -1:
          {
            status = 'Rejected';
          }
          break;

        default:
          {
            status = '';
          }
          break;
      }

      return status;
    }

    detailRow(Credits plantedDetail) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        margin: const EdgeInsets.symmetric(vertical: 2),
        width: size.width,
        height: 60,
        color: plantedDetail.approvalStage == -1
            ? theme.errorColor
            : theme.primaryColor,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    plantedDetail.date.month.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                  Text(
                    plantedDetail.date.day.toString(),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: null,
                    disabledColor: Colors.white,
                    color: Colors.white,
                  ),
                  Text(
                    approvalStageToString(plantedDetail.approvalStage),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Credits',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    plantedDetail.credits.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }

    plantHistory() {
      return Container(
        height: size.height * 0.448,
        child: ListView.builder(
          itemBuilder: (ctx, i) => detailRow(plantedDetails[i]),
          itemCount: plantedDetails.length,
        ),
      );
    }

    Future<void> getPlantAndPlantedDetails() async {
      //TODO: implement function to return the planted Details
      plantDetail = await Provider.of<Planteds>(context, listen: false)
          .getPlantDetails(plantedId);
      plantedDetails = await Provider.of<Credits>(context, listen: false)
          .getPlantedCredits(plantedId);
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
        future: getPlantAndPlantedDetails(),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Column(
              children: [
                Container(
                  height: size.height * 0.35,
                  child: Stack(
                    children: [
                      Container(
                        height: size.height * 0.35,
                        color: theme.primaryColor,
                      ),
                      Positioned(
                        // top: size.height * 0.05,
                        right: size.width * 0.05,
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(CameraScreen.routeName);
                          },
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
                        child: imagePlacer(
                            size.height * 0.22,
                            // 'https://atlas-content-cdn.pixelsquid.com/stock-images/potted-plant-flower-pot-mdm41mF-600.jpg'),
                            plantDetail.image),
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
                                plantDetail.nickname,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                plantDetail.location,
                                // 'Block 2 Gulistan e jauhar Karachi',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                              Container(
                                width: size.width * 0.5,
                                height: size.height * 0.1,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (ctx, i) => imagePlacer(
                                    size.height * 0.075,
                                    plantedDetails[i].image,
                                  ),
                                  // 'https://atlas-content-cdn.pixelsquid.com/stock-images/potted-plant-flower-pot-mdm41mF-600.jpg'),
                                  itemCount: plantedDetails.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                headerRow(),
                plantHistory(),
              ],
            );
          }
        },
      ),
    );
  }
}

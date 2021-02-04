import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:growgreen/Models/Places.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:growgreen/Models/User.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'AddNewPlaceScreen.dart';

class PlacesListScreen extends StatelessWidget {
  static const routeName = '/places-list';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    PickedFile _imageFile;
    String _pickImageError;
    final ImagePicker _picker = ImagePicker();
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    Future<void> _onImageButtonPressed(
      ImageSource source,
    ) async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
          maxWidth: 600,
          maxHeight: 600,
          imageQuality: 100,
        );

        _imageFile = pickedFile;
      } catch (e) {
        _pickImageError = e.toString();
      }
    }

    addNewPlaceWidget() {
      return GestureDetector(
        onTap: () async {
          await _onImageButtonPressed(ImageSource.camera);
          if (_imageFile != null) {
            print('Image Picked');
            Navigator.of(context)
                .pushNamed(AddNewPlaceScreen.routeName, arguments: _imageFile);
          } else {
            print('Image Not Picked. $_pickImageError');
          }
        },
        child: Container(
          height: size.height * 0.20,
          decoration: BoxDecoration(
            color: Color(0xFF218754),
            // borderRadius: BorderRadius.only(
            //   topLeft: Radius.circular(10),
            //   topRight: Radius.circular(10),
            // ),
          ),
          child: Row(
            children: [
              Container(
                width: size.width * 0.2,
                height: size.width * 0.2,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.white, width: 2)),
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: size.width * 0.2 * 0.8,
                ),
              ),
              SizedBox(width: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a place',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    imagePlacer(double height, String link) {
      // print(link);
      return Container(
        height: height,
        width: height,
        padding: EdgeInsets.symmetric(horizontal: 5),
        margin: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(color: Color(0xFF218754), width: 1),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(
            link,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    launchURL(String homeLat, String homeLng) async {
      final String googleMapslocationUrl =
          "https://www.google.com/maps/search/?api=1&query=$homeLat,$homeLng";

      final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

      if (await canLaunch(encodedURl)) {
        await launch(encodedURl);
      } else {
        print('Could not launch $encodedURl');
        throw 'Could not launch $encodedURl';
      }
    }

    // ignore: missing_return
    Future<String> _getAddressFromLatLng(double lat, double long) async {
      try {
        List<Placemark> p =
            await geolocator.placemarkFromCoordinates(lat, long);
        Placemark place = p[0];
        return "${place.name}, ${place.locality}, ${place.country}";
      } catch (e) {
        print(e);
      }
    }

    placeSelection(Place placeItem) {
      return GestureDetector(
        onTap: () async {
          await launchURL(
              placeItem.latitude.toString(), placeItem.longitude.toString());
        },
        child: Container(
          height: size.height * 0.20,
          decoration: BoxDecoration(
            color: Colors.white,
            // borderRadius: BorderRadius.only(
            // topLeft: Radius.circular(10),
            // topRight: Radius.circular(10),
            // ),
          ),
          child: Row(
            children: [
              imagePlacer(
                size.height * 0.15,
                placeItem.image,
                // 'https://atlas-content-cdn.pixelsquid.com/stock-images/potted-plant-flower-pot-mdm41mF-600.jpg'
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    placeItem.name,
                    // 'Shadman Ground',
                    style: TextStyle(
                      color: Color(0xFF218754),
                      fontSize: 20,
                    ),
                  ),
                  FutureBuilder(
                      future: _getAddressFromLatLng(
                          placeItem.latitude, placeItem.longitude),
                      builder: (ctx, snap) {
                        if (snap.connectionState == ConnectionState.done) {
                          return Text(
                            snap.data.toString(),
                            style: TextStyle(
                              color: Color(0xFF218754),
                              fontSize: 12,
                            ),
                          );
                        } else {
                          return Container();
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
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
        body: Column(
          children: [
            Container(height: size.height * 0.17, color: theme.primaryColor),
            addNewPlaceWidget(),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<Places>(context).getPlaces(
                  user.userID,
                ),
                builder: (ctx, snap) {
                  if (snap.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final places = snap.data as List<Place>;
                    return ListView.builder(
                        itemCount: places.length,
                        itemBuilder: (ctx, i) => placeSelection(places[i]));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

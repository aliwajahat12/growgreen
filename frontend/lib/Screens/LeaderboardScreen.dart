import 'package:flutter/material.dart';
import 'package:growgreen/Models/Leaderboard.dart';
import 'package:growgreen/widgets/leaderboard/LeadersCircularAvatar.dart';
import 'package:provider/provider.dart';

class LeaderBoardScreen extends StatefulWidget {
  static const routeName = '/leaderboard';

  @override
  _LeaderBoardScreenState createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  bool thisWeek = true;
  List<LeaderboardItem> weekly = [];
  List<LeaderboardItem> overall = [];
  List<LeaderboardItem> toShow = [];
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final leaderboard = Provider.of<Leaderboard>(context, listen: false);

    Widget switchWeekAlltime() {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: size.width * 0.3,
              child: RaisedButton(
                elevation: 0,
                onPressed: thisWeek
                    ? null
                    : () {
                        setState(() {
                          thisWeek = true;
                          // toShow = overall;
                        });
                      },
                child: Text(
                  'This Week',
                  style: TextStyle(
                    color:
                        thisWeek ? Colors.white : Theme.of(context).accentColor,
                    fontSize: 18,
                  ),
                ),
                color: thisWeek ? Theme.of(context).accentColor : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
              ),
            ),
            Container(
              width: size.width * 0.3,
              child: RaisedButton(
                elevation: 0,
                onPressed: !thisWeek
                    ? () {}
                    : () {
                        setState(() {
                          thisWeek = false;
                          // toShow = weekly;
                        });
                      },
                child: Text(
                  'All Time',
                  style: TextStyle(
                    color: !thisWeek
                        ? Colors.white
                        : Theme.of(context).accentColor,
                    fontSize: 18,
                  ),
                ),
                color: !thisWeek ? Theme.of(context).accentColor : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    detailRow(int i, String imageUrl, String name, int score) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        width: size.width,
        height: 60,
        // color: theme.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Text(
                  i.toString(),
                  textAlign: TextAlign.end,
                  style: TextStyle(color: theme.accentColor, fontSize: 20),
                )),
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  Text(name,
                      style: TextStyle(
                          color: theme.accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                score.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.accentColor, fontSize: 18),
              ),
            )
          ],
        ),
      );
    }

    Future<void> getLeaderboard(bool thisWeek) async {
      print('This Week $thisWeek');
      if (overall.isEmpty && weekly.isEmpty) {
        final receivedLeaderboard = await leaderboard.getleaderboard();
        overall = receivedLeaderboard['overall'];
        weekly = receivedLeaderboard['weekly'];
      }
      // overall.forEach((e) {
      //   print('${e.totalCredits} ${e.userData.name} ${e.userData.imageUrl}');
      // });
      // print('Overall $overall');
      // print('Weekly $weekly');
      if (thisWeek)
        toShow = weekly;
      else {
        toShow = overall;
      }
    }

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        // title: Text('Leaderboard'),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: size.width * 0.9,
            height: 60,
            child: switchWeekAlltime(),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: FutureBuilder(
              future: getLeaderboard(thisWeek),
              builder: (ctx, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return toShow.length < 1
                      ? Center(
                          child: Text(
                          'No LeaderBoard To Show',
                          style: TextStyle(color: Colors.white),
                        ))
                      : Column(
                          children: [
                            //2nd position
                            Container(
                              height: size.height * 0.25,
                              width: size.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (toShow.length > 1)
                                    Container(
                                      width: size.width * 0.3,
                                      padding: const EdgeInsets.only(
                                          top: 15.0, left: 5, right: 5),
                                      child: LeadersCircularAvatar(
                                        name:
                                            toShow[1].userData.name ?? 'Rohaan',
                                        position: '2',
                                        score: toShow[1]
                                            .totalCredits
                                            .toStringAsFixed(0),
                                        width: size.width / 4,
                                        imageUrl:
                                            toShow[1].userData.imageUrl ?? '',
                                      ),
                                    ),
                                  //1st position
                                  Container(
                                    width: size.width * 0.3,
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: LeadersCircularAvatar(
                                      name: toShow[0].userData.name != null
                                          ? toShow[0].userData.name
                                          : 'Ali Zafar',
                                      position: '1',
                                      score: toShow[0]
                                          .totalCredits
                                          .toStringAsFixed(0),
                                      width: size.width / 4,
                                      imageUrl:
                                          toShow[0].userData.imageUrl == ''
                                              ? ''
                                              : toShow[0].userData.imageUrl,
                                    ),
                                  ),
                                  //3rd position
                                  if (toShow.length > 2)
                                    Container(
                                      width: size.width * 0.3,
                                      padding: const EdgeInsets.only(
                                          top: 15.0, left: 5, right: 5),
                                      child: LeadersCircularAvatar(
                                        name: toShow[2].userData.name ??
                                            'Atif Aslam',
                                        position: '3',
                                        score: toShow[2]
                                            .totalCredits
                                            .toStringAsFixed(0),
                                        width: size.width / 4,
                                        imageUrl:
                                            toShow[2].userData.imageUrl ?? '',
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(40),
                                      topRight: Radius.circular(40)),
                                ),
                                child: toShow.length < 3
                                    ? Center(
                                        child: Text('Get Your Name here!'),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: ListView.builder(
                                            itemCount: toShow.length - 3 > 0
                                                ? toShow.length - 3
                                                : 0,
                                            itemBuilder: (ctx, i) => detailRow(
                                                i + 4,
                                                toShow[i + 3].userData.imageUrl,
                                                toShow[i + 3].userData.name,

                                                // 'https://www.pinclipart.com/picdir/middle/128-1286122_business-person-icon-clipart.png',
                                                // 'Sharukh Khan',
                                                60)),
                                      ),
                              ),
                            ),
                          ],
                        );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

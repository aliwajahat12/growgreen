import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'User.dart';

class UserData {
  String name;
  String imageUrl;

  UserData.fromJson(Map<String, dynamic> json)
      : this.name = json['name'],
        this.imageUrl = json['avatar'] ?? null;
}

class LeaderboardItem {
  String userID;
  int totalCredits;
  UserData userData;

  LeaderboardItem.fromJson(Map<String, dynamic> json)
      : this.userID = json['_id'],
        this.totalCredits = json['totalCredits'],
        this.userData = UserData.fromJson(json['userData']);
}

class Leaderboard with ChangeNotifier {
  Future<Map<String, dynamic>> getleaderboard() async {
    List<LeaderboardItem> overallLeaderboard = [];
    List<LeaderboardItem> weeklyeaderboard = [];
    Map<String, List<LeaderboardItem>> returnMap;
    try {
      final response = await http.get(backendLink + 'credit/');
      final responseData = jsonDecode(response.body);
      final Iterable overall = responseData['overallLeaderboard'];
      final Iterable weekly = responseData['weeklyLeaderboard'];

      // Iterable list = responseData['place'];
      overallLeaderboard =
          overall.map((model) => LeaderboardItem.fromJson(model)).toList();
      weeklyeaderboard =
          weekly.map((model) => LeaderboardItem.fromJson(model)).toList();

      returnMap = {'overall': overallLeaderboard, 'weekly': weeklyeaderboard};
    } catch (e) {
      print(e);
    }
    return returnMap;
  }
}

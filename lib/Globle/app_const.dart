import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppConst{


 String formatDate(String rawDate) {
  try {
    final dateTime = DateTime.parse(rawDate);
    return DateFormat("MMM dd, yyyy").format(dateTime); // Aug 23, 2025
  } catch (e) {
    return rawDate; // fallback if parsing fails
  }
}


 static int? userId;
  static String? username;
  static String? useremail;
  static String? displayName;

  /// Save user data into SharedPreferences
  static Future<void> saveUserData(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("userId", user["id"]);
    await prefs.setString("username", user["username"]);
    await prefs.setString("email", user["email"]);
    await prefs.setString("displayName", user["display_name"]);

    // assign to global vars
    userId = user["id"];
    username = user["username"];
    useremail = user["email"];
    displayName = user["display_name"];
  }

  /// Load user data from SharedPreferences
  static Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("userId");
    username = prefs.getString("username");
    useremail = prefs.getString("email");
    displayName = prefs.getString("displayName");
  }

  /// Clear user data on logout
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    userId = null;
    username = null;
    useremail = null;
    displayName = null;
  }





}
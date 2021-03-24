import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/create_ads_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_button_customer.dart';

class HomeButton extends StatefulWidget {
  @override
  _HomeButtonState createState() => _HomeButtonState();
}

class _HomeButtonState extends State<HomeButton> {
  String userType = 'Customer';
  @override
  void initState() {
    getUserType();
    super.initState();
  }

  getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    userType = user.userType;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (userType.toLowerCase() == 'customer') {
      return HomeButtonCustomer();
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CreateAdsScreen.route());
      },
      child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: StyleResources.green),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  color: StyleResources.shadowColor)
            ],
            color: Colors.white,
          ),
          child: Center(
            child: Container(
              width: 55,
              height: 55,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              child: Center(
                child: Icon(
                  Icons.add,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/resources/string_resources.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/my_account_screen.dart';
import 'package:go_local_vendor/screens/my_account_screen_customer.dart';
import 'package:go_local_vendor/screens/my_ads_screen.dart';
import 'package:go_local_vendor/screens/my_favourite_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigation extends StatefulWidget {
  final int index;

  const BottomNavigation({this.index}) : super();

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
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
      return Container(
        height: 60,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              offset: Offset(0, -2),
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 6)
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
            ),
            _buildBottomNavigationIcon(
                Icons.favorite_border, StringResources.favourites,
                isSelected: widget.index == 1, onPressed: () {
              Navigator.push(context, MyFavouriteScreen.route());
            }),
            _buildBottomNavigationIcon(
                SimpleLineIcons.user, StringResources.account,
                isSelected: widget.index == 2, onPressed: () {
              Navigator.push(context, MyAccountCustomerScreen.route());
            }),
          ],
        ),
      );
    }
    return Container(
      height: 60,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            offset: Offset(0, -2),
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 6)
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
          ),
          _buildBottomNavigationIcon(Icons.live_tv, StringResources.ads,
              isSelected: widget.index == 1, onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyAdsScreen()));
          }),
          _buildBottomNavigationIcon(
              SimpleLineIcons.user, StringResources.account,
              isSelected: widget.index == 2, onPressed: () {
            Navigator.push(context, MyAccountScreen.route());
          }),
        ],
      ),
    );
  }

  _buildBottomNavigationIcon(IconData icon, String title,
      {bool isSelected: false, @required VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            color: isSelected
                ? StyleResources.bottomNavItemIconColorSelected
                : StyleResources.bottomNavItemIconColor,
          ),
          Text(
            title,
            style: isSelected
                ? StyleResources.bottomNavItemTextSelectedStyle
                : StyleResources.bottomNavItemTextStyle,
          ),
        ],
      ),
    );
  }
}

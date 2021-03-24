import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_local_vendor/resources/string_resources.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/my_account_screen.dart';
import 'package:go_local_vendor/screens/my_ads_screen.dart';

class BottomNavigationCustomer extends StatelessWidget {
  final int index;

  const BottomNavigationCustomer({@required this.index}) : super();

  @override
  Widget build(BuildContext context) {
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

          _buildBottomNavigationIcon(
              Icons.live_tv, StringResources.ads,
              isSelected: index == 1, onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyAdsScreen()));
          }),
          _buildBottomNavigationIcon(
              SimpleLineIcons.user, StringResources.account,
              isSelected: index == 2, onPressed: () {
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

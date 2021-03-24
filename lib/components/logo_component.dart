import 'package:flutter/material.dart';
import 'package:go_local_vendor/resources/style_resources.dart';

class LogoComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width/4,
      width: MediaQuery.of(context).size.width/4,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              offset: Offset(0,2),
              color: StyleResources.shadowColor,
              blurRadius: 6,
            ),
          ]
      ),
      child: Image.asset("assets/images/GoLocal_LOGO-Login.png"),
    );
  }
}

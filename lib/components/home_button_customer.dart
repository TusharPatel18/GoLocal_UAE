import 'package:flutter/material.dart';
import 'package:go_local_vendor/resources/image_resources.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/home_screen.dart';

class HomeButtonCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushReplacement(context, HomeScreen.route());
      },
      child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  offset: Offset(0,3),
                  blurRadius: 6,
                  color: StyleResources.shadowColor
              ),
            ],
            color: Colors.green,
          ),
          child:Image.asset(
            ImageResources.home_button,fit: BoxFit.contain,width: 60,height: 60,),
      ),
    );
  }
}

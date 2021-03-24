import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/login_screen.dart';

class SuccessScreen extends StatelessWidget {
  final String message;
  final VoidCallback redirect;
  const SuccessScreen({Key key, @required this.message, this.redirect}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/images/check_circle.png"),
                SizedBox(
                  height: 20,
                ),
                Text(
                  message ?? "Password Reset Link on your Mail Successfully",
                  style: StyleResources.cardTitleStyle,
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      color: StyleResources.green,
                      onPressed: () {
                        Navigator.pushReplacement(context, LoginScreen.route());
                      },
                      child: Text(
                        "Continue to Login",
                        style: StyleResources.buttonFontStyle,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

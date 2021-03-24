
import 'package:flutter/material.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:permission_handler/permission_handler.dart';

import 'screens/SplashScreen.dart';

void main(){
  // await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  initState() {
    super.initState();
    checkCameraPermission();
  }

  checkCameraPermission() async {
    var status = await Permission.photos.status;
    if (!status.isGranted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.photos,
      ].request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Go Local',
      theme: ThemeData(
        appBarTheme: AppBarTheme(color: StyleResources.green),
        scaffoldBackgroundColor: StyleResources.scaffoldBackgroundColor,
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashPage(),
    );
  }
}




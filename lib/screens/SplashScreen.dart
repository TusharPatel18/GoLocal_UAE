import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/login/login_screen_bloc.dart';
import 'package:go_local_vendor/bloc/splashScreen/splash_bloc.dart';
import 'package:go_local_vendor/repository/user_repository.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashBloc _splashBloc = SplashBloc(initialState);

  static SplashState get initialState => null;

  @override
  void initState() {
    _splashBloc.add(SetSplash());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: BlocProvider(
          create: (_) => _splashBloc,
          child: BlocListener<SplashBloc, SplashState>(
            listener: (context, state) {
              if (state is SplashLoaded) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>  BlocProvider<LoginScreenBloc>(
                      create: (context) =>
                          LoginScreenBloc(
                            UserRepository(
                              ApiHandler(
                                http.Client(),
                              ),
                            ),
                          ),
                      child: LoginScreen(),
                    ),
                  ),
                );
              }
            },
            child: _buildSplashWidget(),
          ),
        ),
      ),
    );
  }

  Widget _buildSplashWidget() {
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 300,
              width: 300,
              child: Image.asset("assets/images/GoLocal_LOGO-1.png",
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // Text("GoLocal UAE",style: StyleResources.SplashScreenTextStyle,),
          ],
        ),
    );
  }
}
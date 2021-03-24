import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/login/login_screen_bloc.dart';
import 'package:go_local_vendor/bloc/password_toggle/password_toggle_bloc.dart';
import 'package:go_local_vendor/components/logo_component.dart';
import 'package:go_local_vendor/components/text_field_wrapper.dart';
import 'package:go_local_vendor/repository/user_repository.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/forgot_password_screen.dart';
import 'package:go_local_vendor/screens/home_screen.dart';
import 'package:go_local_vendor/screens/register_screen.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
      builder: (context) => BlocProvider<LoginScreenBloc>(
          create: (context) =>
              LoginScreenBloc(UserRepository(ApiHandler(http.Client()))),
          child: LoginScreen()));
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode emailFocusNode = FocusNode();

  final FocusNode passwordFocusNode = FocusNode();

  final FocusNode loginFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  checkLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isLoggedIn = preferences.getBool('IS_LOGGED_IN');
    if (isLoggedIn ?? false) {
      Navigator.pushAndRemoveUntil(
          context, HomeScreen.route(), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginScreenBloc, LoginScreenState>(
        listener: (context, state) {
          if (state is LoggingIn) {
            showLoaderDialog(context);
          }
          if (state is LoginSuccess) {
            Navigator.pop(context);
            Navigator.pushAndRemoveUntil(
                context, HomeScreen.route(), (route) => false);
          }
          if (state is LoginFailed) {
            Navigator.pop(context);
            showErrorMessage(context, message: state.message);
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    width: MediaQuery.of(context).size.width - 100,
                    child: Image.asset("assets/images/GoLocal_LOGO-1.png",height: 150,width: 150,),
                  ),
                  // Container(
                  //   margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  //   width: MediaQuery.of(context).size.width - 100,
                  //   child: Text("GoLocal",textAlign: TextAlign.center,style: StyleResources.AppNameTextStyle,),
                  // ),
                  // Container(
                  //   width: MediaQuery.of(context).size.width - 100,
                  //   child: Text("UAE",textAlign: TextAlign.center,style: StyleResources.AppNameTextStyle,),
                  // ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  Stack(
                      children: [
                    Container(
                      height: 310,
                      width: MediaQuery.of(context).size.width - 100,
                    ),
                    Positioned(
                      top: 50,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        decoration: BoxDecoration(
                            color: StyleResources.loginBg,
                            borderRadius: BorderRadius.circular(15),
                        ),
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                              TextFieldWrapper(
                                child: TextFormField(
                                  controller: _emailController,
                                  // validator: (val) {
                                  //   if (val.isEmpty) {
                                  //     return "Please enter a valid phone";
                                  //   }
                                  //   // if (!RegExp(Patterns.email).hasMatch(val)) {
                                  //   //   return "Please enter a valid email";
                                  //   // }
                                  //   // return null;
                                  //   return null;
                                  // },
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 5.0),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide.none),
                                    prefixIcon: Icon(Icons.email,color: StyleResources.green,),
                                    labelText: "Email",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              BlocProvider<PasswordToggleBloc>(
                                create: (context) => PasswordToggleBloc(),
                                child: TextFieldWrapper(
                                  child: BlocBuilder<PasswordToggleBloc, bool>(
                                    builder: (context, state) {
                                      return TextFormField(
                                        obscureText: state,
                                        controller: _passwordController,
                                        focusNode: passwordFocusNode,
                                        onEditingComplete: () {
                                          FocusScope.of(context).requestFocus(loginFocusNode);
                                        },
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(25),
                                                borderSide: BorderSide.none),
                                            prefixIcon: Icon(Icons.lock,color: StyleResources.green,),
                                            suffixIcon: IconButton(
                                              icon: Icon(state
                                                  ? Icons.visibility_off
                                                  : Icons.visibility),
                                              onPressed: () {
                                                BlocProvider.of<PasswordToggleBloc>(context).add(
                                                        state
                                                        ? PasswordToggleEvent.HIDE
                                                        : PasswordToggleEvent.SHOW);
                                              },
                                            ),
                                            labelText: "Password",
                                            floatingLabelBehavior: FloatingLabelBehavior.never),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                    ),
                                    color: StyleResources.green,
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        BlocProvider.of<LoginScreenBloc>(context).add(Login(_emailController.text, _passwordController.text));
                                      } else {
                                        showErrorMessage(context,
                                            message: "Please check all fields");
                                      }
                                    },
                                    child: Text(
                                      "Login",
                                      style: StyleResources.buttonFontStyle,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text.rich(
                                TextSpan(children: [
                                TextSpan(text: "Don't Have an Account?"),
                                WidgetSpan(
                                    child: SizedBox(
                                  width: 5,
                                ),
                                ),
                                WidgetSpan(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context, RegisterScreen.route());
                                    },
                                    child: Text(
                                      "Register",
                                      style: StyleResources.linkTextLinkStyle,
                                    ),
                                  ),
                                ),
                              ]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 25,
                    //   left: 0,
                    //   right: 0,
                    //   child: Align(
                    //     alignment: Alignment.center,
                    //     child: LogoComponent(),
                    //   ),
                    // )
                  ]),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Text.rich(
                    TextSpan(
                        children: [
                      TextSpan(text: "Forgot Password?"),
                      WidgetSpan(
                          child: SizedBox(
                        width: 5,
                      ),
                      ),
                      WidgetSpan(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen(),
                                ),
                            );
                          },
                          child: Text(
                            "Reset Now",
                            style: StyleResources.linkTextLinkStyle,
                          ),
                        ),
                      ),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

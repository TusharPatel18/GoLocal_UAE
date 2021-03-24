import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_local_vendor/bloc/password_toggle/password_toggle_bloc.dart';
import 'package:go_local_vendor/bloc/register/registration_bloc.dart';
import 'package:go_local_vendor/components/logo_component.dart';
import 'package:go_local_vendor/components/text_field_wrapper.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/login_screen.dart';
import 'package:go_local_vendor/screens/otp_screen.dart';
import '../repository/user_repository.dart';
import '../utils/api_handler.dart';
import 'package:http/http.dart' as http;
import '../utils/dialogs.dart';

class RegisterScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => BlocProvider<RegistrationBloc>(
          create: (context) => RegistrationBloc(
            UserRepository(
              ApiHandler(
                http.Client(),
              ),
            ),
          ),
          child: RegisterScreen(),
        ),
      );

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastNameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode registerFocusNode = FocusNode();
  final _formKey = new GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _vendorOrCustomer = 'Customer';
  String code = "+971";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is Registering) {
            showLoaderDialog(context);
          }
          if (state is RegistrationFailed) {
            Navigator.pop(context);
            showErrorMessage(context, message: state.message);
          }
          if (state is RegistrationSuccess) {
            Navigator.pop(context);
            showSuccessMessage(context, message: state.message, callback: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  OtpScreen.route(
                      _vendorOrCustomer,
                      emailController.text,
                      phoneController.text,
                      firstNameController.text,
                      lastNameController.text),
                  (route) => false);
            });
          }
        },
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                  width: MediaQuery.of(context).size.width - 100,
                  child: Image.asset("assets/images/GoLocal_LOGO-1.png",height: 150,width: 150,),
                ),
                Stack(
                  children: [
                    Container(
                      height: 500,
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
                        height: 450,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                TextFieldWrapper(
                                  child: TextFormField(
                                    focusNode: firstNameFocusNode,
                                    controller: firstNameController,
                                    keyboardType: TextInputType.name,
                                    onEditingComplete: () {
                                      FocusScope.of(context)
                                          .requestFocus(lastNameFocusNode);
                                    },
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 5.0),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide.none),
                                        prefixIcon: Icon(FontAwesome.user),
                                        labelText: "First Name",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFieldWrapper(
                                  child: TextFormField(
                                    focusNode: lastNameFocusNode,
                                    controller: lastNameController,
                                    keyboardType: TextInputType.name,
                                    onEditingComplete: () {
                                      FocusScope.of(context).requestFocus(phoneFocusNode);
                                    },
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide.none),
                                        prefixIcon: Icon(FontAwesome.user),
                                        labelText: "Last Name",
                                        floatingLabelBehavior: FloatingLabelBehavior.never),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: TextFieldWrapper(
                                          child: Container(
                                                  margin: const EdgeInsets.fromLTRB(8, 0, 3, 0),
                                              child: DropdownButtonHideUnderline(
                                                        child: DropdownButton(
                                                          value: code,
                                                          onChanged: (val) {
                                                            setState(() {
                                                              code = val;
                                                            });
                                                          },
                                                          items: [
                                                           DropdownMenuItem(
                                                             value: "+971", child: Text("+971"),
                                                           ),
                                                          DropdownMenuItem(
                                                           value: "+91", child: Text("+91"),
                                                          ),
                                                           ],
                                               ),
                                              ),
                                          ),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      flex: 3,
                                      child: TextFieldWrapper(
                                        child: TextFormField(
                                          keyboardType: TextInputType.phone,
                                          controller: phoneController,
                                          focusNode: phoneFocusNode,
                                          onEditingComplete: () {
                                            FocusScope.of(context)
                                                .requestFocus(emailFocusNode);
                                          },
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(
                                                  vertical: 5.0, horizontal: 5.0),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: BorderSide.none),
                                              prefixIcon: Icon(Icons.phone),
                                              labelText: "Mobile No.",
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFieldWrapper(
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: emailController,
                                    focusNode: emailFocusNode,
                                    onEditingComplete: () {
                                      FocusScope.of(context).requestFocus(passwordFocusNode);
                                    },
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 5.0),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide.none),
                                        prefixIcon: Icon(Icons.email),
                                        labelText: "Email",
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never),
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
                                          focusNode: passwordFocusNode,
                                          controller: passwordController,
                                          onEditingComplete: () {
                                            FocusScope.of(context)
                                                .requestFocus(registerFocusNode);
                                          },
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(
                                                  vertical: 5.0, horizontal: 5.0),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  borderSide: BorderSide.none),
                                              suffixIcon: IconButton(
                                                icon: Icon(state
                                                    ? Icons.visibility_off
                                                    : Icons.visibility),
                                                onPressed: () {
                                                  BlocProvider.of<
                                                              PasswordToggleBloc>(
                                                          context)
                                                      .add(state
                                                          ? PasswordToggleEvent.HIDE
                                                          : PasswordToggleEvent
                                                              .SHOW);
                                                },
                                              ),
                                              prefixIcon: Icon(Icons.lock),
                                              labelText: "Password",
                                              floatingLabelBehavior:
                                                  FloatingLabelBehavior.never),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                    children: [
                                    InkWell(
                                    onTap: () {
                                      setState(() {
                                        _vendorOrCustomer = "Customer";
                                      });
                                    },
                                    child: Row(children: [
                                      Radio(
                                        groupValue: _vendorOrCustomer,
                                        value: 'Customer',
                                        onChanged: (val) {
                                          setState(() {
                                            _vendorOrCustomer = val;
                                          });
                                        },
                                      ),
                                      Text("Customer")
                                    ]),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _vendorOrCustomer = "Vendor";
                                      });
                                    },
                                    child: Row(children: [
                                      Radio(
                                        groupValue: _vendorOrCustomer,
                                        value: 'Vendor',
                                        onChanged: (val) {
                                          setState(() {
                                            _vendorOrCustomer = val;
                                          });
                                        },
                                      ),
                                      Text("Vendor")
                                    ]),
                                  ),
                                ]),
                                // TextFieldWrapper(
                                //   child: Padding(
                                //     padding:
                                //         const EdgeInsets.symmetric(horizontal: 8.0),
                                //     child: Center(
                                //       child: DropdownButtonHideUnderline(
                                //         child: DropdownButton(
                                //           value: _vendorOrCustomer,
                                //           onChanged: (val) {
                                //             setState(() {
                                //               _vendorOrCustomer = val;
                                //             });
                                //           },
                                //           items: [
                                //             DropdownMenuItem(
                                //               value: "Customer",
                                //               child: Text("Customer"),
                                //             ),
                                //             DropdownMenuItem(
                                //               value: "Vendor",
                                //               child: Text("Vendor"),
                                //             )
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  height: 10,
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
                                        if (firstNameController.text.isEmpty) {
                                          _scaffoldKey.currentState
                                              // ignore: deprecated_member_use
                                              .showSnackBar(SnackBar(
                                                 content: Text(
                                                "Plese enter a valid first name"),
                                            ),
                                          );
                                        }
                                        else if (lastNameController.text.isEmpty) {
                                          _scaffoldKey.currentState
                                              // ignore: deprecated_member_use
                                              .showSnackBar(SnackBar(
                                                 content: Text(
                                                "Plese enter a valid last name"),
                                           ),
                                          );
                                        }
                                        else if (phoneController.text.isEmpty) {
                                          _scaffoldKey.currentState
                                              // ignore: deprecated_member_use
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("Plese enter a valid phone"),
                                          ));
                                        }
                                        else if (emailController.text.isEmpty) {
                                          _scaffoldKey.currentState
                                              // ignore: deprecated_member_use
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("Plese enter a valid email"),
                                          ),
                                              );
                                        }
                                        else if (!RegExp(emailController.text).hasMatch(emailController.text)) {
                                          _scaffoldKey.currentState
                                              // ignore: deprecated_member_use
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("Plese enter a valid email"),
                                          ),
                                          );
                                        }
                                        else if (passwordController.text.isEmpty) {
                                          _scaffoldKey.currentState
                                              // ignore: deprecated_member_use
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text("Plese enter a valid email"),
                                          ),
                                          );
                                        }
                                        else {BlocProvider.of<RegistrationBloc>(context).add(
                                            Register(
                                                  firstNameController.text,
                                                  lastNameController.text,
                                                  code + phoneController.text,
                                                  emailController.text,
                                                  passwordController.text,
                                                  _vendorOrCustomer),
                                          );
                                        }
                                      },
                                      child: Text(
                                        "Register",
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
                                    TextSpan(text: "Have an Account?"),
                                    WidgetSpan(
                                        child: SizedBox(
                                      width: 5,
                                     ),
                                    ),
                                    WidgetSpan(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushReplacement(
                                              context, LoginScreen.route());
                                        },
                                        child: Text(
                                          "Login",
                                          style: StyleResources.linkTextLinkStyle,
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   left: 0,
                    //   right: 0,
                    //   child: Align(
                    //       alignment: Alignment.center, child: LogoComponent(),
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

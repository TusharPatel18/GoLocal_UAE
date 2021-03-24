import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/otp/otp_cubit.dart';
import 'package:go_local_vendor/components/logo_component.dart';
import 'package:go_local_vendor/components/text_field_wrapper.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/success_screen.dart';
import 'package:go_local_vendor/utils/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget {
  final String vendorOrCustomer;
  final String email;
  final String phone;
  final String firstName;
  final String lastName;

  const OtpScreen(
      {Key key,
      this.vendorOrCustomer,
      this.email,
      this.phone,
      this.firstName,
      this.lastName})
      : super(key: key);

  static route(vendorOrCustomer, email, phone, firstName, lastName) =>
      MaterialPageRoute(
          builder: (context) => BlocProvider<OtpCubit>(
              create: (context) => OtpCubit(),
              child: OtpScreen(
                  vendorOrCustomer: vendorOrCustomer,
                  email: email,
                  phone: phone,
                  firstName: firstName,
                  lastName: lastName),
          ),
      );

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  String otp = "";

  @override
  void initState() {
    getOtp();
    super.initState();
  }

  getOtp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    otp = preferences.getString("OTP");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<OtpCubit, OtpState>(
      listener: (context, state) {
        if (state is OtpVerifying) {
          showLoaderDialog(context);
        }
        if (state is OtpVerified) {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => SuccessScreen(
              message: "OTP Confirmed Successfully",
              ),
             ),
            );
        }
        if (state is OtpError) {
          Navigator.pop(context);
          showErrorMessage(context, message: state.message);
           }
        },
         child: Center(
          child: Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  // Container(child: Text(otp ?? "N/A")),
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    height: 250,
                  ),
                  Positioned(
                    top: 50,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 100,
                      decoration: BoxDecoration(
                          color: StyleResources.loginBg,
                          borderRadius: BorderRadius.circular(15),
                      ),
                      height: 200,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              child: TextFieldWrapper(
                                child: TextFormField(
                                  controller: otpController,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 5.0),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide.none,
                                      ),
                                      prefixIcon: Icon(Icons.lock),
                                      labelText: "OTP",
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              height: 40,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                // ignore: deprecated_member_use
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: StyleResources.green,
                                  onPressed: () {
                                    // ignore: deprecated_member_use
                                    context.bloc<OtpCubit>()
                                      ..verifyOtp(otpController.text);
                                  },
                                  child: Text(
                                    "Confirm",
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
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: LogoComponent(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}

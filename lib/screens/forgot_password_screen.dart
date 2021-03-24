import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_local_vendor/components/logo_component.dart';
import 'package:go_local_vendor/components/text_field_wrapper.dart';
import 'package:go_local_vendor/repository/user_repository.dart';
import 'package:go_local_vendor/resources/string_resources.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/success_screen.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/dialogs.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController mailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 250,
                    width:  MediaQuery.of(context).size.width-100,
                  ),
                  Positioned(
                    top: 50,
                    child: Container(
                      width: MediaQuery.of(context).size.width-100,
                      decoration: BoxDecoration(
                          color: StyleResources.loginBg,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      height: 200,
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
                                height: 40,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: TextFieldWrapper(
                                  child: TextFormField(
                                    controller: mailController,
                                    validator: (val){
                                      if(val.isEmpty){
                                        return "Please enter a valid email";
                                      }
                                      if(!RegExp(Patterns.email).hasMatch(val)){
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior.never,
                                      contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          borderSide: BorderSide.none),
                                      prefixIcon: Icon(Icons.email),
                                      labelText: "Email",
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15,),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    color: StyleResources.green,
                                    onPressed: ()async{
                                      if(_formKey.currentState.validate()){
                                        showLoaderDialog(context);
                                        try{
                                          
                                          bool success = await UserRepository(ApiHandler(http.Client())).resetPassword(email: mailController.text);
                                          if(success){
                                            Navigator.pop(context);
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SuccessScreen(
                                              message: "Password Reset Link on your Mail Successfully",
                                            )));
                                            
                                          }else{
                                            Navigator.pop(context);
                                            showErrorMessage(context,message: "Couldn't Reset your password");
                                          }
                                        }on ErrorHandler catch(ex){
                                          Navigator.pop(context);
                                          showErrorMessage(context,message: ex.getMessage());
                                        }
                                      }
                                    },
                                    child: Text("Reset",style: StyleResources.buttonFontStyle,),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_local_vendor/bloc/user/user_bloc.dart';
import 'package:go_local_vendor/components/home_button.dart';
import 'package:go_local_vendor/components/navigation/bottom_navigation_customer.dart';
import 'package:go_local_vendor/components/navigation/sidebar_navigation.dart';
import 'package:go_local_vendor/components/text_field_wrapper.dart';
import 'package:go_local_vendor/repository/user_repository.dart';
import 'package:go_local_vendor/resources/string_resources.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/resources/url_resources.dart';
import 'package:go_local_vendor/screens/home_screen.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/dialogs.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'login_screen.dart';

class MyAccountScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
      builder: (context) => BlocProvider<UserBloc>(
          create: (context) =>
              UserBloc(UserRepository(ApiHandler(http.Client())))
                ..add(GetUser()),
          child: MyAccountScreen(),
      ),
  );
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  File userImage;
  File images;
  File images2;
  bool _isImageUploaded = false, _isServerImage = false;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final TextEditingController facebookController = TextEditingController();
  // final TextEditingController twitterController = TextEditingController();
  // final TextEditingController instagramController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  UserBloc userBloc;
  final picker = ImagePicker();

  String image1;
  String fb,insta,twitter;

  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: (){
        Navigator.pushAndRemoveUntil(
            context, HomeScreen.route(), (route) => false);
      },
      child: Stack(
        children: [
          Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text(StringResources.my_account),
            ),
            body: SafeArea(
              child: BlocConsumer<UserBloc, UserState>(listener: (context, state) {
                if (state is UserUpdated) {
                  showSuccessMessage(context,
                      message: "User Updated Successfully",callback: (){
                        Navigator.pushAndRemoveUntil(
                            context,
                            HomeScreen.route(),
                                (route) => false);
                      });
                }
                if (state is UserDeactivated) {
                  showSuccessMessage(context,
                      message: "User Deactivated Successfully", callback: () {
                    Navigator.pushAndRemoveUntil(
                        context, LoginScreen.route(), (route) => false);
                  });
                }
              }, builder: (context, state) {
                if (state is UserLoaded) {
                  firstNameController.text = state.user.firstName;
                  lastNameController.text = state.user.lastName;
                  emailController.text = state.user.emailId;
                  mobileController.text = state.user.mobileNo;
                  // facebookController.text = state.user.facebook;
                  fb = state.user.facebook ?? "";
                  // twitterController.text = state.user.twitter;
                  twitter = state.user.twitter ?? "";
                  // instagramController.text = state.user.instagram;
                  insta = state.user.instagram ?? "";
                  addressController.text = state.user.address;
                  image1 = state.user.image;
                  if(image1 != null){
                    _isImageUploaded = false;
                    _isServerImage = true;
                  }else{
                    _isImageUploaded = false;
                    _isServerImage = false;
                  }

                  return Container(
                      height: double.infinity,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height / 5,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      bottomRight: Radius.circular(20),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 2),
                                        blurRadius: 6,
                                        color: StyleResources.shadowColor),
                                  ]),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                    title: Text("Choose Source.."),
                                                    content: Text("Where you want to select your profile"),
                                                    actions: [
                                                      // ignore: deprecated_member_use
                                                      FlatButton(
                                                        onPressed: () async {
                                                          showLoaderDialog(context);
                                                          PickedFile file = await ImagePicker().getImage(source: ImageSource.camera);
                                                              userImage = File(file.path);
                                                              await UserRepository(ApiHandler(http.Client())).changeImage(image: userImage);
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text("CAMERA"),
                                                      ),
                                                      BlocProvider.value(
                                                        value: userBloc,
                                                        // ignore: deprecated_member_use
                                                        child: FlatButton(
                                                          onPressed: () async {
                                                            showLoaderDialog(context);
                                                            PickedFile file = await ImagePicker().getImage(source: ImageSource.gallery);
                                                            userImage = File(file.path);
                                                            print(userImage);
                                                            try {
                                                              bool uploaded = await UserRepository(ApiHandler(http.Client())).changeImage(image: userImage);
                                                              if (uploaded) {
                                                                userBloc..add(GetUserNew());
                                                              } else {}
                                                            } on ErrorHandler catch (ex) {
                                                              showErrorMessage(context,message: ex.getMessage());
                                                            }
                                                            Navigator.pop(context);
                                                            Navigator.pop(context);
                                                          },
                                                          child: Text("GALLERY"),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                               );
                                            },
                                        child: Container(
                                          width: 75,
                                          height: 75,
                                          padding: EdgeInsets.all(4.0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(0, 2),
                                                    blurRadius: 6,
                                                    color: StyleResources.green.withOpacity(0.3),
                                                ),
                                              ]),
                                          child: BlocBuilder<UserBloc, UserState>(
                                              builder: (context, state) {
                                            if (state is UserLoaded) {
                                              if (userImage != null) {
                                                return ClipRRect(
                                                    borderRadius: BorderRadius.circular(36.5),
                                                    child: Image.file(userImage),
                                                );
                                              }
                                              if (state.user.imageUrl.replaceAll(" ", "replace").isEmpty) {
                                                return ClipRRect(
                                                  borderRadius: BorderRadius.circular(36.5),
                                                  child: Image.asset(
                                                    "assets/images/no-user.png",
                                                    fit: BoxFit.cover,),
                                                );
                                              }
                                              return ClipRRect(
                                                borderRadius: BorderRadius.circular(36.5),
                                                child: CachedNetworkImage(
                                                    errorWidget: (context, _, __) {
                                                      return Image.asset(
                                                        "assets/images/no-user.png",
                                                        fit: BoxFit.cover,);
                                                    },
                                                    imageUrl: UrlResources.mainUrl + (state.user.imageUrl),
                                                    fit: BoxFit.cover,
                                                    placeholder: (context, source) {
                                                      return Center(
                                                          child: CircularProgressIndicator());
                                                    }),
                                              );
                                            }
                                            return ClipRRect(
                                              borderRadius: BorderRadius.circular(36.5),
                                              child: Image.asset(
                                                  "assets/images/no-user.png",
                                                fit: BoxFit.cover,),
                                            );
                                          }),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(state.user.firstName.toUpperCase() + " " + state.user.lastName.toUpperCase()),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(child: _buildAccountInfoUi()),
                          ],
                        ),
                      ),
                    );
                   }
                   if(state is UserError) {
                    return Center(
                        child: Text(state.message),
                    );
                      }
                   return Center(
                       child: CircularProgressIndicator(),
                   );
                }),
            ),
            bottomNavigationBar: BottomNavigation(
              index: 2,
            ),
          ),
          Positioned(
            left: 30,
            bottom: 30,
            child: HomeButton(),
          ),
        ],
      ),
    );
  }

  _buildAccountInfoUi() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      // padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              TextFieldWrapper(
                child: TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    prefixIcon: Icon(FontAwesome.user),
                    labelText: "First Name",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWrapper(
                child: TextFormField(
                  controller: lastNameController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    prefixIcon: Icon(FontAwesome.user),
                    labelText: "Last Name",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWrapper(
                child: TextFormField(
                  controller: addressController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    prefixIcon: Icon(
                      Icons.location_on,
                    ),
                    labelText: "Address",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWrapper(
                child: TextFormField(
                  enabled: false,
                  controller: emailController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.email),
                    labelText: "Email",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWrapper(
                child: TextFormField(
                  controller: mobileController,
                  enabled: false,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.phone),
                    labelText: "Phone",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWrapper(
                child: TextFormField(
                  controller: TextEditingController(text: fb),
                  obscureText: false,
                  keyboardType: TextInputType.text,
                  onChanged: (value) => fb = value,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    prefixIcon: IconButton(icon: Image.asset("assets/images/fb.png",width:20,height:20),),
                    labelText: "Facebook",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWrapper(
                child: TextFormField(
                  controller: TextEditingController(text: insta),
                  onChanged: (value) => insta = value,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    prefixIcon: IconButton(icon: Image.asset("assets/images/instagram.png",width:20,height:20),),
                    labelText: "Instagram",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWrapper(
                child: TextFormField(
                  controller: TextEditingController(text: twitter),
                  onChanged: (value) => twitter = value,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    prefixIcon: IconButton(icon: Image.asset("assets/images/twitter.png",width:20,height:20),),
                    labelText: "Twitter",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWrapper(
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text("Your Licence :",style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Choose Source.."),
                      content: Text("Where you want to Upload your Licence?"),
                      actions: [
                        FlatButton(
                          onPressed: () async {
                            showLoaderDialog(context);
                            try {
                              getImageFromCamera();
                            } catch (ex) {}
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text("CAMERA"),
                        ),
                        FlatButton(
                          onPressed: () async {
                            showLoaderDialog(context);
                            try {
                              getImageFromGallery();
                            } catch (ex) {}
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text("GALLERY"),
                        ),
                      ],
                    ),
                  );
                },
                child: SizedBox(
                  width: 75,
                  height: 75,
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                    ),
                    shadowColor: StyleResources.shadowColor,
                    child: Icon(
                      EvilIcons.camera,
                      size: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  (_isServerImage)
                     ? Container(
                      width: 75,
                      height: 75,
                      margin: EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: (image1 != null) ? CachedNetworkImage(
                        imageUrl: image1,
                        fit: BoxFit.cover,
                        width: 75,
                        height: 75,
                      ) : Container(),
                    )
                     : Container(),
                  (images2 != null)
                      ? Container(
                              width: 75,
                              height: 75,
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  border: Border.all(color: Colors.grey),
                              ),
                              child:(images2 != null) ? Image.file(
                                images2,
                                fit: BoxFit.cover,
                                width: 75,
                                height: 75,
                                 ) : Container(),
                              ) : Container()
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                  children: [
                   Expanded(
                    child: RaisedButton(
                    onPressed: () {
                      showDialog(context: context, builder: (context) {
                            return AlertDialog(
                              title: Text("Are you sure?"),
                              content: Text("You will be blocked from accesing our resource"),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("No"),
                                ),
                                FlatButton(
                                    onPressed: () {
                                      userBloc..add(DeactivateUser());
                                    },
                                    child: Text("Yes"),
                                ),
                              ],
                            );
                          });
                       },
                      color: StyleResources.red,
                       shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      ),
                     child:Text("Deactivate", style: StyleResources.buttonFontStyle),
                  ),
                ),
                   SizedBox(
                  width: 10,
                ),
                   Expanded(
                     child: RaisedButton(
                      onPressed: () {
                      if (firstNameController.text.isEmpty) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                          "Please enter a valid first name",
                            ),
                          ),
                        );
                      } else if (lastNameController.text.isEmpty) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text(
                          "Please enter a valid last name",
                           ),
                         ),
                        );
                      // ignore: unrelated_type_equality_checks
                      }
                      else {
                        try{
                          if(images == null){
                            try{
                              BlocProvider.of<UserBloc>(context).add(UpdateUser(
                                firstNameController.text,
                                lastNameController.text,
                                passwordController.text,
                                fb.toString(),
                                insta.toString(),
                                twitter.toString(),
                                addressController.text,
                              ),
                              );
                            }catch (ex) {}
                          }
                          else {
                            try{
                              BlocProvider.of<UserBloc>(context).add(UpdateUser1(
                                firstNameController.text,
                                lastNameController.text,
                                passwordController.text,
                                fb.toString(),
                                insta.toString(),
                                twitter.toString(),
                                addressController.text,
                                images,
                              ));
                            }catch (ex) {}
                          }
                        }catch (ex) {}

                        }
                      },
                       color: StyleResources.green,
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      ),
                       child: Text("Update", style: StyleResources.buttonFontStyle),
                  ),
                ),
              ]),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future getImageFromCamera() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera,);
    images = File(image.path);
    images2 = image;
    setState(() { });
  }

  Future getImageFromGallery() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery,);
    images = File(image.path);
    images2 = image;
      setState(() { });
  }
}

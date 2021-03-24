import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_local_vendor/bloc/ads/ads_bloc.dart';
import 'package:go_local_vendor/bloc/favourite/favourite_bloc.dart';
import 'package:go_local_vendor/bloc/user/user_bloc.dart';
import 'package:go_local_vendor/components/ad_component_customer.dart';
import 'package:go_local_vendor/components/ad_component_withoutImage_customer.dart';
import 'package:go_local_vendor/components/home_button.dart';
import 'package:go_local_vendor/components/navigation/bottom_navigation_customer.dart';
import 'package:go_local_vendor/components/navigation/sidebar_navigation.dart';
import 'package:go_local_vendor/components/text_field_wrapper.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
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

import 'my_favourite_screen.dart';

class MyAccountCustomerScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
      builder: (context) => BlocProvider<UserBloc>(
          create: (context) =>
              UserBloc(UserRepository(ApiHandler(http.Client())))
                ..add(GetUser()),
          child: MyAccountCustomerScreen()));
  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountCustomerScreen> {
  int current = 0;
  File userImage;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
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
            body: BlocConsumer<UserBloc, UserState>(
              listener: (context, state) {
                if (state is UserUpdated) {
                  showSuccessMessage(context,
                      message: "User Updated Successfully");
                }
              },
              builder: (context, state) {
                if (state is UserLoaded) {
                  firstNameController.text = state.user.firstName;
                  lastNameController.text = state.user.lastName;
                  emailController.text = state.user.emailId;
                  mobileController.text = state.user.mobileNo;
                  return SafeArea(
                    child: Container(
                      height: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height / 4,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 2),
                                      blurRadius: 6,
                                      color: StyleResources.shadowColor)
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
                                                  content: Text(
                                                      "Where you want to select your profile"),
                                                  actions: [
                                                    FlatButton(
                                                      onPressed: () async {
                                                        showLoaderDialog(context);
                                                        PickedFile file =
                                                            await ImagePicker().getImage(
                                                                    source: ImageSource.camera);
                                                        userImage = File(file.path);
                                                        try {
                                                          bool uploaded =
                                                              await UserRepository(ApiHandler(http.Client())).changeImage(
                                                                      image: userImage);
                                                          if (uploaded) {
                                                            userBloc
                                                              ..add(GetUserNew());
                                                          }
                                                        } on ErrorHandler catch (ex) {
                                                          showErrorMessage(
                                                              context,
                                                              message: ex.getMessage());
                                                        }
                                                        Navigator.pop(context);
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("CAMERA"),
                                                    ),
                                                    BlocProvider.value(
                                                      value: userBloc,
                                                      child: FlatButton(
                                                        onPressed: () async {
                                                          showLoaderDialog(
                                                              context);
                                                          PickedFile file =
                                                              await ImagePicker().getImage(
                                                                      source: ImageSource.gallery);
                                                          userImage = File(file.path);
                                                          try {
                                                            bool uploaded = await UserRepository(
                                                                    ApiHandler(http.Client())).changeImage(
                                                                    image: userImage);
                                                            if (uploaded) {
                                                              userBloc
                                                                ..add(
                                                                    GetUserNew());
                                                            }
                                                          } on ErrorHandler catch (ex) {
                                                            showErrorMessage(
                                                                context,
                                                                message: ex.getMessage());
                                                          }
                                                          Navigator.pop(context);
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text("GALLERY"),
                                                      ),
                                                    ),
                                                  ],
                                                ));
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
                                          builder: (context, state) => ClipRRect(
                                            borderRadius: BorderRadius.circular(36.5),
                                            child: !(state is UserLoaded) || userImage != null
                                                ? Image.file(userImage,fit: BoxFit.cover,)
                                                : CachedNetworkImage(
                                                    imageUrl: state is UserLoaded ? UrlResources.mainUrl + state.user.imageUrl ?? "" : '',
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, source) {
                                                      return Image.asset(
                                                          "assets/images/no-user.png",);
                                                    }),
                                          ),
                                        ),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          current = 0;
                                        });
                                      },
                                      child: Text(
                                        "My Info",
                                        style: current == 0
                                            ? StyleResources.accountTabStyleActive
                                            : StyleResources.accountTabStyle,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          current = 1;
                                        });
                                      },
                                      child: Text(
                                        "My Favourites",
                                        style: current == 1
                                            ? StyleResources.accountTabStyleActive
                                            : StyleResources.accountTabStyle,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: current == 0
                                ? _buildAccountInfoUi(state.user)
                                : _buildMyFavouriteUI(),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is UserError) {
                  return Center(child: Text(state.message));
                }
                return Center(child: CircularProgressIndicator());
              },
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

  _buildAccountInfoUi(User user) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              TextFieldWrapper(
                child: TextFormField(
                  controller: firstNameController,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    prefixIcon: Icon(FontAwesome.user),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
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
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    prefixIcon: Icon(FontAwesome.user),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelText: "Last Name",
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWrapper(
                child: TextFormField(
                  controller: emailController,
                  enabled: false,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none),
                    prefixIcon: Icon(Icons.email),
                    labelText: "Email",
                    floatingLabelBehavior: FloatingLabelBehavior.never,
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
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none),
                          prefixIcon: Icon(Icons.phone),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          labelText: "Mobile No."),
                  ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldWrapper(
                  child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 5.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25),
                              borderSide: BorderSide.none),
                          prefixIcon: Icon(Icons.lock),
                          labelText: "Password"),
                  ),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
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
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text(
                        "Please enter a valid first name",
                          ),
                        ),
                      );
                    } else {
                      BlocProvider.of<UserBloc>(context).add(UpdateUser(
                          firstNameController.text,
                          lastNameController.text,
                          passwordController.text,
                          '',
                          '',
                          '',
                          '',
                        ),
                      );
                    }
                  },
                  color: StyleResources.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text("Update", style: StyleResources.buttonFontStyle),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildMyFavouriteUI() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AdsBloc>(
          create: (context) => AdsBloc(AdsRepository(ApiHandler(http.Client())))
            ..add(GetFavouriteAds(1)),
        ),
        BlocProvider<FavouriteBloc>(
          create: (context) =>
              FavouriteBloc(AdsRepository(ApiHandler(http.Client()))),
        ),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          primary: true,
          child: BlocListener<FavouriteBloc, FavouriteState>(
            listener: (context, state) {
              if (state is Favourited) {
                BlocProvider.of<AdsBloc>(context)..add(GetFavouriteAds(1));
              }
            },
            child: BlocBuilder<AdsBloc, AdsState>(builder: (context, state) {
              if (state is AdsLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is AdsLoaded) {
                if (state.ads.length == 0) {
                  return Center(child: Text("No Favourites Found"));
                }
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: state.ads.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5),
                        itemBuilder: (context, index) => state.ads[index].imageurl.length == 0
                            ? BlocProvider.value(
                                value: BlocProvider.of<FavouriteBloc>(context),
                                child: AdComponentWithoutImageCustomer(
                                  bloc: BlocProvider.of<FavouriteBloc>(context),
                                  ads: state.ads[index],
                                ),
                              )
                            : BlocProvider.value(
                                value: BlocProvider.of<FavouriteBloc>(context),
                                child: AdComponentCustomer(
                                  bloc: BlocProvider.of<FavouriteBloc>(context),
                                  adModel: state.ads[index],
                                ),
                              ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 40,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: StyleResources.green,
                          onPressed: () {
                            Navigator.push(context, MyFavouriteScreen.route());
                            // Navigator.push(context,
                            //    MaterialPageRoute(
                            //    builder: (context) => MyFavouriteScreen()));
                          },
                          child: Text(
                            "See More",
                            style: StyleResources.buttonFontStyle,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                );
              }
              if (state is AdsError) {
                return Center(child: Text(state.message));
              }
              return Container();
            }),
          ),
        ),
      ),
    );
  }
}

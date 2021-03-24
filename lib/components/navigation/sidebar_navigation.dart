import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_local_vendor/bloc/user/user_bloc.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/repository/user_repository.dart';
import 'package:go_local_vendor/resources/string_resources.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/resources/url_resources.dart';
import 'package:go_local_vendor/screens/home_screen.dart';
import 'package:go_local_vendor/screens/login_screen.dart';
import 'package:go_local_vendor/screens/my_account_screen.dart';
import 'package:go_local_vendor/screens/my_account_screen_customer.dart';
import 'package:go_local_vendor/screens/my_ads_screen.dart';
import 'package:go_local_vendor/screens/my_favourite_screen.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SideBarNavigation extends StatefulWidget {
  @override
  _SideBarNavigationState createState() => _SideBarNavigationState();
}

class _SideBarNavigationState extends State<SideBarNavigation> {
  String userType = 'customer';

  @override
  void initState() {
    getUserType();
    super.initState();
  }

  getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    this.userType = user.userType;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (userType.toLowerCase() == 'customer') {
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            BlocProvider<UserBloc>(
              create: (context) =>
                  UserBloc(UserRepository(ApiHandler(http.Client())))
                    ..add(GetUser()),
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) => state is UserLoaded
                    ?
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: StyleResources.green,
                      ),
                         accountName: Text(state.user.firstName + ' ' + state.user.lastName),
                         accountEmail: Text(state.user.emailId,),
                         currentAccountPicture: ClipRRect(
                           borderRadius:
                           BorderRadius.circular(36.5),
                           child: CachedNetworkImage(
                             imageUrl: UrlResources.mainUrl + (state.user.imageUrl ?? "upload/no-user-1.png"),
                             fit: BoxFit.cover,
                                placeholder:
                                (context, source) {
                                  return Image.asset(
                                      "assets/images/no-user.png");
                                }
                               ),
                         ),
                       )
                         :  UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: StyleResources.green,
                  ),
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            accountName: Text("Go Local User",),
                            accountEmail: Text("+91 123456987",),
                            currentAccountPicture: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(36.5),
                              child: CachedNetworkImage(
                                imageUrl: UrlResources.mainUrl + "upload/no-user-1.png",
                                fit: BoxFit.cover,
                                  placeholder:
                                      (context, source) {
                                    return Image.asset(
                                        "assets/images/no-user.png");
                                  },
                              ),
                            ),
                  ),
                ),
              ),
            _buildListItem(Icons.home, StringResources.home, onPressed: () {
              Navigator.pushReplacement(context, HomeScreen.route());
            }),
            // _buildListItem(Icons.event_outlined, StringResources.events, onPressed: () {
            //   Navigator.pushReplacement(
            //       context, MaterialPageRoute(builder: (context) => HomeScreen()));
            // }),
            _buildListItem(Icons.favorite_border, StringResources.my_favourites,
                onPressed: () {
              Navigator.push(context, MyFavouriteScreen.route());
            }),
            _buildListItem(FontAwesome.user, StringResources.my_account,
                onPressed: () {
              Navigator.push(context, MyAccountCustomerScreen.route());
            }),
            _buildListItem(Icons.help_outline, StringResources.help,
                onPressed: () async {
              if (await canLaunch(
                  "http://golocaluae.com/terms-and-conditions/")) {
                launch(
                  "http://golocaluae.com/terms-and-conditions/",
                  forceWebView: true,
                  enableJavaScript: true,
                );
              } else {
                showErrorMessage(context, message: "Couldn't load");
              }
            }),
            _buildListItem(Icons.mail_outline, StringResources.terms_of_service,
                onPressed: () async {
              if (await canLaunch(
                  "http://golocaluae.com/terms-and-conditions/")) {
                launch(
                  "http://golocaluae.com/terms-and-conditions/",
                  forceWebView: true,
                  enableJavaScript: true,
                );
              } else {
                showErrorMessage(context, message: "Couldn't load");
              }
            }),
            _buildListItem(Icons.power_settings_new, StringResources.logout,
                onPressed: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.clear();
              Navigator.pushReplacement(context, LoginScreen.route());
            }),
          ],
        ),
      );
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          BlocProvider<UserBloc>(
            create: (context) =>
                UserBloc(UserRepository(ApiHandler(http.Client())))
                  ..add(GetUser()),
            child: BlocBuilder<UserBloc, UserState>(builder: (context, state) {
              if (state is UserLoaded) {
                return  UserAccountsDrawerHeader(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  decoration: BoxDecoration(
                  color: StyleResources.green,
                   ),
                  accountName: Text(state.user.firstName + ' ' + state.user.lastName),
                  accountEmail: Text(state.user.mobileNo,),
                  currentAccountPicture: ClipRRect(
                    borderRadius: BorderRadius.circular(36.5),
                    child: CachedNetworkImage(
                        imageUrl: UrlResources.mainUrl + (state.user.imageUrl ?? "upload/no-user-1.png"),
                        fit: BoxFit.cover,
                        placeholder:
                            (context, source) {
                          return Image.asset(
                              "assets/images/no-user.png");
                        }
                    ),
                  ),
                );
              }
              return
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: StyleResources.green,
                      ),
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        accountName: Text("Go Local User",),
                        accountEmail: Text("+91 123456987",),
                        currentAccountPicture: CircleAvatar(
                          child: CachedNetworkImage(
                          imageUrl: UrlResources.mainUrl + "upload/no-user-1.png",
                    ),
                  ),
                );
            }),
          ),
          _buildListItem(Icons.home, StringResources.home, onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          }),
          // _buildListItem(Icons.event_outlined, StringResources.events, onPressed: () {
          //   Navigator.pushReplacement(
          //       context, MaterialPageRoute(builder: (context) => HomeScreen()));
          // }),
          _buildListItem(Icons.live_tv, StringResources.my_ads, onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MyAdsScreen()));
          }),
          _buildListItem(SimpleLineIcons.user, StringResources.my_account,
              onPressed: () {
            Navigator.push(context, MyAccountScreen.route());
          }),
          _buildListItem(Icons.help_outline, StringResources.help,
              onPressed: () async {
            if (await canLaunch("http://golocaluae.com/terms-and-conditions/")) {
              launch(
                "http://golocaluae.com/terms-and-conditions/",
                forceWebView: true,
                enableJavaScript: true,
              );
            } else {
              showErrorMessage(context, message: "Couldn't load");
            }
          }),
          _buildListItem(Icons.mail_outline, StringResources.terms_of_service,
              onPressed: () async {
            if (await canLaunch("http://golocaluae.com/terms-and-conditions/")) {
              launch(
                "http://golocaluae.com/terms-and-conditions/",
                forceWebView: true,
                enableJavaScript: true,
              );
            } else {
              showErrorMessage(context, message: "Couldn't load");
            }
          }),
          _buildListItem(Icons.power_settings_new, StringResources.logout,
              onPressed: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.clear();
            Navigator.pushReplacement(context, LoginScreen.route(),);
          }),
        ],
      ),
    );
  }

  _buildListItem(IconData icon, String title,
      {@required VoidCallback onPressed}) {
    return ListTile(
        onTap: onPressed,
        leading: Icon(
          icon,
          color: StyleResources.sideNavItemIconColor,
          ),
        title: Text(
          title,
          style: StyleResources.sideNavItemTextStyle,
         ),
    );
  }
}

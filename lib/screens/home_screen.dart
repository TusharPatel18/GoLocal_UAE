import 'dart:convert';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/ads/ads_bloc.dart';
import 'package:go_local_vendor/bloc/banners/banner_bloc.dart';
import 'package:go_local_vendor/bloc/category/category_bloc.dart';
import 'package:go_local_vendor/bloc/favourite/favourite_bloc.dart';
import 'package:go_local_vendor/bloc/user/user_bloc.dart';
import 'package:go_local_vendor/components/ad_component.dart';
import 'package:go_local_vendor/components/ad_component_customer.dart';
import 'package:go_local_vendor/components/ad_component_withoutImage.dart';
import 'package:go_local_vendor/components/ad_component_withoutImage_customer.dart';
import 'package:go_local_vendor/components/banner_component.dart';
import 'package:go_local_vendor/components/category/category_item.dart';
import 'package:go_local_vendor/components/home_button.dart';
import 'package:go_local_vendor/components/navigation/bottom_navigation_customer.dart';
import 'package:go_local_vendor/components/navigation/sidebar_navigation.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/models/category_model.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/repository/banner_repository.dart';
import 'package:go_local_vendor/repository/category_repository.dart';
import 'package:go_local_vendor/repository/user_repository.dart';
import 'package:go_local_vendor/resources/string_resources.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/categories_screen.dart';
import 'package:go_local_vendor/screens/search_screen.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String meta = "home_screen";
  static route() => MaterialPageRoute(
      builder: (context) => BlocProvider<AdsBloc>(
          create: (context) => AdsBloc(AdsRepository(ApiHandler(http.Client())))
            ..add(GetAds(0, ads: [])),
          child: HomeScreen()));

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CategoryModel> categories = [];
  int _currentPage = 1;
  int _currentAdsPage = 1;
  List<AdModel> ads = [];
  String userType = 'customer';

  @override
  initState() {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(StringResources.home),
      ),
      drawer: SideBarNavigation(),
      body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: Stack(
            children: [
          SingleChildScrollView(
            primary: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Stack(
                //   children: <Widget>[
                //
                //   ],
                // ),
                // Container(
                //   height: (MediaQuery.of(context).size.height / 3) + 5,
                // ),
                BlocProvider<BannerBloc>(
                    create: (context) => BannerBloc(
                        BannerRepository(ApiHandler(http.Client())))
                      ..add(GetBanners()),
                    child: BannerComponent(),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  // left: 30,
                  // right: 30,
                  // bottom: 5,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, SearchScreen.route());
                    },
                    child: Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 4.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 6,
                                  color: StyleResources.shadowColor)
                            ]),
                        child: Center(
                          child: TextFormField(
                            enabled: false,
                            readOnly: true,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: "Search Here...",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                            ),
                          ),
                        ),
                    ),
                  ),
                ),



                _headerWidget("Categories", "See All", onPressed: () {
                  Navigator.push(context, CategoriesScreen.route());
                }),

                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BlocProvider<CategoryBloc>(
                    create: (context) => CategoryBloc(
                        CategoryRepository(ApiHandler(http.Client())))
                      ..add(GetCategories(1)),
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryInitial) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is CategoriesLoading) {
                          return GridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1),
                            itemCount: state.categories.length + 1,
                            itemBuilder: (context, index) {
                              if (index > state.categories.length - 1) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return CategoryItem(
                                categoryModel: state.categories[index],
                              );
                            },
                          );
                        }
                        if (state is CategoriesLoaded) {
                          categories = categories..addAll(state.categories);
                          _currentPage = state.page + 1;
                          if (state.categories.length != 0 && _currentPage <= 2) {
                            BlocProvider.of<CategoryBloc>(context).add(
                              GetCategories(_currentPage, categories: categories),
                            );
                          }
                          return GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1),
                              itemCount: categories.length > 6 ? 6 : categories.length,
                              itemBuilder: (context, index) {
                                return CategoryItem(
                                    categoryModel: categories[index]);
                              });
                        }
                        if (state is CategoryError) {
                          return Center(
                            child: Text(state.message),
                          );
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Divider(),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BlocProvider<AdsBloc>(
                    create: (context) =>
                        AdsBloc(AdsRepository(ApiHandler(http.Client())))
                          ..add(GetAds(1)),
                    child: BlocBuilder<AdsBloc, AdsState>(
                      builder: (context, state) {
                        if (state is AdsInitial) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (state is AdsLoading) {
                          if (userType.toLowerCase() == 'customer') {
                            return BlocProvider<FavouriteBloc>(
                              create: (context) => FavouriteBloc(
                                  AdsRepository(ApiHandler(http.Client()))),
                              child: GridView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: state.ads.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.8,
                                        mainAxisSpacing: 5,
                                        crossAxisSpacing: 5),
                                itemBuilder: (context, index) => ads[index].imageurl.length == 0
                                    ? BlocProvider.value(
                                        value: BlocProvider.of<FavouriteBloc>(context),
                                        child: AdComponentWithoutImageCustomer(
                                          ads: ads[index],
                                          bloc: BlocProvider.of<FavouriteBloc>(context),
                                        ),
                                    )
                                    : BlocProvider.value(
                                        value: BlocProvider.of<FavouriteBloc>(context),
                                        child: AdComponentCustomer(
                                          bloc: BlocProvider.of<FavouriteBloc>(context),
                                          adModel: ads[index],
                                        ),
                                    ),
                              ),
                            );
                          }
                          return GridView.builder(
                            primary: false,
                            shrinkWrap: true,
                            itemCount: state.ads.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.8,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5),
                            itemBuilder: (context, index) => ads[index].imageurl.length == 0
                                    ? AdComponentWithoutImage(
                                        ad: ads[index],
                                      )
                                    : AdComponent(
                                        ad: ads[index],
                                      ),
                          );
                        }
                        if (state is AdsLoaded) {
                          ads = state.ads;
                          if (ads.length == 0) {
                            return Center(
                                child: Text("It looks like you dont have any Ads"),
                            );
                          }
                          _currentAdsPage = state.page + 1;
                           if (userType.toLowerCase() == 'customer') {
                            return BlocProvider<FavouriteBloc>(
                              create: (context) => FavouriteBloc(
                                  AdsRepository(ApiHandler(http.Client()))),
                              child: GridView.builder(
                                 primary: false,
                              shrinkWrap: true,
                              itemCount: ads.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 0.8,
                                          mainAxisSpacing: 5,
                                          crossAxisSpacing: 5,
                                          ),
                                itemBuilder: (context, index) => ads[index].imageurl.length == 0
                                    ? BlocProvider.value(
                                        value: BlocProvider.of<FavouriteBloc>(context),
                                        child: AdComponentWithoutImageCustomer(
                                          ads: ads[index],
                                          bloc: BlocProvider.of<FavouriteBloc>(context),
                                        ),
                                     )
                                    : BlocProvider.value(
                                        value: BlocProvider.of<FavouriteBloc>(context),
                                        child: AdComponentCustomer(
                                          bloc: BlocProvider.of<FavouriteBloc>(context),
                                          adModel: ads[index],
                                        ),
                                      ),
                              ),
                            );
                          }
                          return GridView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: ads.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.8,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5,
                              ),
                              itemBuilder: (context, index) =>
                                  ads[index].imageurl.length == 0
                                      ? AdComponentWithoutImage(
                                          ad: ads[index],
                                        )
                                      : AdComponent(
                                          ad: ads[index],
                                        ),
                          );
                        }
                        if (state is AdsError) {
                          return Center(child: Text(state.message));
                        }
                        return Container();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BottomNavigation(),
          ),
          Positioned(
            left: 30,
            bottom: 30,
            child: HomeButton(),
          ),
        ]),
      ),
    );
  }

  _headerWidget(String title, String linkTitle, {VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: StyleResources.homeHeaderTextStyle,
          ),
          InkWell(
              onTap: onPressed,
              child: Text(
                linkTitle,
                style: StyleResources.homeHeaderLinkTextStyle,
              ),
          ),
        ],
      ),
    );
  }
}

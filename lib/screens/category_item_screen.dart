import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/ads_with_category/cubit/ads_with_category_cubit.dart';
import 'package:go_local_vendor/bloc/favourite/favourite_bloc.dart';
import 'package:go_local_vendor/components/ad_component.dart';
import 'package:go_local_vendor/components/ad_component_customer.dart';
import 'package:go_local_vendor/components/ad_component_withoutImage.dart';
import 'package:go_local_vendor/components/ad_component_withoutImage_customer.dart';
import 'package:go_local_vendor/components/home_button.dart';
import 'package:go_local_vendor/components/navigation/bottom_navigation_customer.dart';
import 'package:go_local_vendor/models/category_model.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryItemScreen extends StatefulWidget {
  final CategoryModel categoryModel;

  const CategoryItemScreen({Key key, this.categoryModel}) : super(key: key);
  static route(CategoryModel categoryModel) => MaterialPageRoute(
        builder: (context) => BlocProvider<AdsWithCategoryCubit>(
            create: (context) =>
                AdsWithCategoryCubit()..getAdsWithCategory(categoryModel.id),
            child: CategoryItemScreen(
              categoryModel: categoryModel,
            )),
      );
  @override
  _CategoryItemScreenState createState() => _CategoryItemScreenState();
}

class _CategoryItemScreenState extends State<CategoryItemScreen> {
  int current = 0;
  String userType = 'customer';
  double rating = 4.0;
  final TextEditingController reviewController = TextEditingController();

  @override
  initState() {
    getUserType();
    super.initState();
  }

  getUserType() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    userType = user.userType;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (userType.toLowerCase() == 'customer') {
      return Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: Text(widget.categoryModel.categoriesname),
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<AdsWithCategoryCubit, AdsWithCategoryState>(
                    builder: (context, state) {
                  if (state is AdsWithCategoryLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is AdsWithCategoryLoaded) {
                    return BlocProvider<FavouriteBloc>(
                      create: (context) => FavouriteBloc(
                          AdsRepository(ApiHandler(http.Client()))),
                      child: GridView.builder(
                          itemCount: state.ads.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5),
                          itemBuilder: (context, index) => state
                                      .ads[index].imageurl.length ==
                                  0
                              ? AdComponentWithoutImageCustomer(
                                  ads: state.ads[index],
                                  bloc: BlocProvider.of<FavouriteBloc>(context),
                                )
                              : AdComponentCustomer(
                                  adModel: state.ads[index],
                                  bloc:
                                      BlocProvider.of<FavouriteBloc>(context))),
                    );
                  }
                  if (state is AdsWithCategoryError) {
                    return Center(child: Text(state.message));
                  }
                  return Container();
                }),
              ),
            ),
            bottomNavigationBar: BottomNavigation(),
          ),
          Positioned(
            left: 30,
            bottom: 25,
            child: HomeButton(),
          ),
        ],
      );
    }
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(widget.categoryModel.categoriesname),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocBuilder<AdsWithCategoryCubit, AdsWithCategoryState>(
                  builder: (context, state) {
                if (state is AdsWithCategoryLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is AdsWithCategoryLoaded) {
                  if (state.ads.length == 0) {
                    return Center(
                        child: Text("Sorry! We couldn't find anything"));
                  }
                  return GridView.builder(
                      itemCount: state.ads.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 5,
                          crossAxisSpacing: 5),
                      itemBuilder: (context, index) =>
                          state.ads[index].imageurl.length == 0
                              ? AdComponentWithoutImage(
                                  ad: state.ads[index],
                                )
                              : AdComponent(
                                  ad: state.ads[index],
                                ));
                }
                if (state is AdsWithCategoryError) {
                  return Center(child: Text(state.message));
                }
                return Container();
              }),
            ),
          ),
          bottomNavigationBar: BottomNavigation(),
        ),
        Positioned(
          left: 30,
          bottom: 25,
          child: HomeButton(),
        ),
      ],
    );
  }
}

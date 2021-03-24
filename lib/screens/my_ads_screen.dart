import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/ads/ads_bloc.dart';
import 'package:go_local_vendor/components/ad_component.dart';
import 'package:go_local_vendor/components/ad_component_withoutImage.dart';
import 'package:go_local_vendor/components/home_button.dart';
import 'package:go_local_vendor/components/navigation/bottom_navigation_customer.dart';
import 'package:go_local_vendor/components/navigation/sidebar_navigation.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/resources/string_resources.dart';
import 'package:go_local_vendor/screens/home_screen.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:http/http.dart' as http;

class MyAdsScreen extends StatefulWidget {
  @override
  _MyAdsScreenState createState() => _MyAdsScreenState();
}

class _MyAdsScreenState extends State<MyAdsScreen> {
  int current = 0;
  int _currentAdsPage = 1;
  List<AdModel> ads = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
        onWillPop: () {
          Navigator.pushAndRemoveUntil(
              context, HomeScreen.route(), (route) => false);
        },
      child: Stack(
          children: [
        Scaffold(
          appBar: AppBar(
            title: Text(StringResources.my_ads),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical:16.0),
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
                      return GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: state.ads.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.8,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5),
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
                    if (state is AdsLoaded) {
                      ads = ads..addAll(state.ads);
                      if (ads.length == 0) {
                        return Center(
                            child: Text("It looks like you dont have any Ads"),
                        );
                      }

                      _currentAdsPage = state.page + 1;
                       if (state.ads.length != 0) {
                            BlocProvider.of<AdsBloc>(context).add(
                              GetAds(_currentAdsPage, ads: ads),
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
          ),
          bottomNavigationBar: BottomNavigation(
            index: 1,
          ),
        ),
        Positioned(
          left: 30,
          bottom: 30,
          child: HomeButton(),
        ),
      ]),
    );
  }
}

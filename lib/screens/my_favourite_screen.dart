import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/ads/ads_bloc.dart';
import 'package:go_local_vendor/bloc/favourite/favourite_bloc.dart';
import 'package:go_local_vendor/components/ad_component_customer.dart';
import 'package:go_local_vendor/components/ad_component_withoutImage_customer.dart';
import 'package:go_local_vendor/components/home_button.dart';
import 'package:go_local_vendor/components/navigation/bottom_navigation_customer.dart';
import 'package:go_local_vendor/components/navigation/sidebar_navigation.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/resources/string_resources.dart';
import 'package:go_local_vendor/screens/home_screen.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:http/http.dart' as http;

class MyFavouriteScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<AdsBloc>(
                create: (context) =>
                    AdsBloc(AdsRepository(ApiHandler(http.Client())))
                      ..add(GetFavouriteAds(1, ads: [])),
              ),
              BlocProvider<FavouriteBloc>(
                create: (context) =>
                    FavouriteBloc(AdsRepository(ApiHandler(http.Client()))),
              ),
            ],
            child: MyFavouriteScreen(),
          ),
  );
  @override
  _MyFavouriteScreenState createState() => _MyFavouriteScreenState();
}

class _MyFavouriteScreenState extends State<MyFavouriteScreen> {
  int current = 0;
  List<AdModel> ads = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          WillPopScope(
            // ignore: missing_return
            onWillPop: () {
              Navigator.pushAndRemoveUntil(
                  context, HomeScreen.route(), (route) => false);
            },
             child: Scaffold(
               appBar: AppBar(
                  title: Text(StringResources.my_favourites),
          ),
              body: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BlocListener<FavouriteBloc,FavouriteState>(
                    listener: (context,state){
                      if(state is Favourited || state is FavouriteError){
                        ads = [];current = 1;
                        BlocProvider.of<AdsBloc>(context).add(GetFavouriteAds(1,ads:[]));
                      }
                    },
                    child: BlocBuilder<AdsBloc, AdsState>(
                      builder: (context, state) {
                        if (state is AdsInitial) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state is AdsLoading) {
                          return GridView.builder(
                              itemCount: state.ads.length + 1,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.8,
                                  mainAxisSpacing: 5,
                                  crossAxisSpacing: 5),
                              itemBuilder: (context, index) {
                                if (index > state.ads.length - 1) {
                                  return Center(child: CircularProgressIndicator());
                                }
                                return state.ads[index].imageurl.length == 0
                                    ? BlocProvider.value(
                                        value: BlocProvider.of<FavouriteBloc>(context),
                                        child: AdComponentWithoutImageCustomer(
                                          ads: state.ads[index],
                                          bloc: BlocProvider.of<FavouriteBloc>(context),
                                        ),
                                      )
                                    : AdComponentCustomer(
                                        adModel: state.ads[index],
                                        bloc: BlocProvider.of<FavouriteBloc>(context),
                                      );
                              });
                        }
                        if (state is AdsLoaded) {
                          current = state.page + 1;
                          ads = ads..addAll(state.ads);
                          if (state.ads.length != 0 && state.ads.length >= 4) {
                           // BlocProvider.of<AdsBloc>(context)
                           //   ..add(GetFavouriteAds(state.page + 1, ads: ads,));
                          }
                          if(ads.length==0){
                            return Center(child:Text("No Favourites Found"));
                          }
                          return GridView.builder(
                              itemCount: ads.length,
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
                                        adModel: ads[index],
                                        bloc: BlocProvider.of<FavouriteBloc>(context),
                                          ),
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
      ),
      Positioned(
        left: 30,
        bottom: 30,
        child: HomeButton(),
      ),
    ]);
  }
}

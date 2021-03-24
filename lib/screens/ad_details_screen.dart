import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_local_vendor/bloc/ad/ad_bloc.dart';
import 'package:go_local_vendor/bloc/ads_with_category/cubit/ads_with_category_cubit.dart';
import 'package:go_local_vendor/bloc/review/review_bloc.dart';
import 'package:go_local_vendor/bloc/vendor/cubit/vendor_cubit.dart';
import 'package:go_local_vendor/components/banner_list.dart';
import 'package:go_local_vendor/components/home_button.dart';
import 'package:go_local_vendor/components/navigation/bottom_navigation_customer.dart';
import 'package:go_local_vendor/components/related_item.dart';
import 'package:go_local_vendor/components/review_component.dart';
import 'package:go_local_vendor/components/time_component.dart';
import 'package:go_local_vendor/components/vendor_info_component.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/repository/reviews_repository.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/edit_ads_screen.dart';
import 'package:go_local_vendor/screens/home_screen.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/dialogs.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_ads_images_screen.dart';

class AdDetailsScreen extends StatefulWidget {
  final AdModel ad;

  static route(AdModel adModel) => MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<AdBloc>(
                create: (context) =>
                    AdBloc(AdsRepository(ApiHandler(http.Client())))..add(GetAd(int.parse(adModel.id.toString()))),
              ),
              BlocProvider<ReviewBloc>(
                create: (context) =>
                    ReviewBloc(ReviewsRepository(ApiHandler(http.Client())))..add(GetReview(int.parse(adModel.id.toString()), 1)),
              ),
            ],
            child: AdDetailsScreen(
              ad: adModel,
            ),
          ),
  );

  const AdDetailsScreen({Key key, this.ad}) : super(key: key);

  @override
  _AdDetailsScreenState createState() => _AdDetailsScreenState();
}

class _AdDetailsScreenState extends State<AdDetailsScreen> {
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
      // ignore: close_sinks
      final reviewBloc = BlocProvider.of<ReviewBloc>(context);
      return Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: Text(widget.ad.title),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  BlocBuilder<AdBloc, AdState>(
                    builder: (context, state) {
                      if (state is AdInitial) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state is AdLoaded) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            state.adModel.imageurl.length > 0
                                ? AdBannerList(
                                    images: state.adModel.imageurl,
                                    imgtitles: state.adModel.imagetitle,
                                  )
                                : SizedBox(
                                    height: 10,
                                  ),
                            Align(
                              alignment: Alignment.topRight,
                              child: TimeComponent(
                                time: state.adModel.createdAt,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                state.adModel.title,
                                style: StyleResources.cardTitleStyle,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                state.adModel.description,
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        );
                      }
                      if (state is AdError) {
                        return Center(child: Text(state.message));
                      }
                      return Container();
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Contact Us",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: StyleResources.green,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BlocProvider<VendorCubit>(
                        create: (context) =>
                            VendorCubit()..getVendor(widget.ad.userid),
                        child: VendorInfoComponent(),
                      ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Comments",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: StyleResources.green,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: RatingBar(
                            initialRating: rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemCount: 5,
                            itemSize: 25,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            ratingWidget: RatingWidget(
                                empty: Icon(Icons.star_border,
                                    color: Colors.amber),
                                full: Icon(Icons.star, color: Colors.amber),
                                half:
                                    Icon(Icons.star_half, color: Colors.amber)),
                            onRatingUpdate: (rating) {
                              this.rating = rating;
                              setState(() {});
                            }),
                      ),
                      Container(
                        height: 120,
                        child: Center(
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 0.2),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 2),
                                          blurRadius: 6,
                                          color: StyleResources.shadowColor)
                                    ]),
                                width: double.infinity,
                                height: 80,
                                child: Center(
                                  child: TextFormField(
                                    controller: reviewController,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                    maxLines: 8,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      labelText: "Type your comment here...",
                                      labelStyle: TextStyle(color: StyleResources.green),
                                    ),
                                  ),
                                ),
                              )),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 16),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: BlocProvider<ReviewBloc>(
                            create: (context) => ReviewBloc(
                                ReviewsRepository(ApiHandler(http.Client()))),
                            child: RaisedButton(
                              color: StyleResources.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)),
                              onPressed: () {
                                reviewBloc
                                  ..add(NewReview(
                                      int.parse(widget.ad.id.toString()),
                                      reviewController.text,
                                      rating.toString()));
                                FocusScope.of(context)
                                    .requestFocus(FocusNode());
                                reviewController.text = "";
                              },
                              child: Text(
                                "Add Review",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      BlocConsumer<ReviewBloc, ReviewState>(
                          listener: (context, state) {
                        if (state is ReviewAdded) {
                          showSuccessMessage(context,
                              message: "Review Added successfully");
                          BlocProvider.of<ReviewBloc>(context)
                            ..add(GetReview(
                                int.parse(widget.ad.id.toString()), 1));
                        }
                      }, builder: (context, state) {
                        if (state is ReviewInitial || state is AddingReview) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (state is ReviewsLoaded) {
                          return Column(
                            children: state.reviews
                                .map((e) => Column(
                                      children: [
                                        ReviewComponent(
                                          reviewModel: e,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ))
                                .toList(),
                          );
                        }
                        if (state is ReviewError) {
                          return Center(child: Text(state.message));
                        }
                        return Container();
                      }),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Related",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: StyleResources.green,
                      ),
                    ),
                  ),
                  BlocBuilder<AdBloc, AdState>(
                    builder: (context, state) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BlocProvider<AdsWithCategoryCubit>(
                        create: (context) {
                          if (state is AdLoaded) {
                            return AdsWithCategoryCubit()
                              ..getAdsWithCategory(state.adModel.categories[0]);
                          }
                          return AdsWithCategoryCubit();
                        },
                        child: BlocBuilder<AdsWithCategoryCubit,
                            AdsWithCategoryState>(
                          builder: (context, state) {
                            if (state is AdsWithCategoryLoading) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (state is AdsWithCategoryLoaded) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: state.ads
                                      .where((e) => e.imageurl.length > 0)
                                      .map(
                                        (e) => RelatedItem(
                                          ad: e,
                                        ),
                                      )
                                      .toList(),
                                ),
                              );
                            }
                            if (state is AdsWithCategoryError) {
                              return Center(child: Text(state.message));
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
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
            title: Text(widget.ad.title),
          ),

          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                BlocBuilder<AdBloc, AdState>(
                  builder: (context, state) {
                    if (state is AdInitial) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is AdLoaded) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          state.adModel.imageurl.length > 0
                              ? AdBannerList(
                                  images: state.adModel.imageurl,
                                  imgtitles: state.adModel.imagetitle,
                                )
                              : SizedBox(
                                  height: 10,
                                ),
                          SizedBox(
                            height: 5,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: TimeComponent(time: widget.ad.createdAt),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              widget.ad.title,
                              style: StyleResources.cardTitleStyle,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              state.adModel.description,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      );
                    }
                    if (state is AdError) {
                      return Center(child: Text(state.message),
                      );
                    }
                    return Container();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: SizedBox(
                              height: 40,
                              child: RaisedButton(
                                color: StyleResources.red,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Text(
                                  "Remove",
                                  style: StyleResources.buttonFontStyle,
                                ),
                                onPressed: () async {
                                  try {
                                    bool success = await AdsRepository(
                                            ApiHandler(http.Client()))
                                        .deleteAd(int.parse(widget.ad.id));
                                    if (success) {
                                      showSuccessMessage(context,
                                          message: "Ad Removed Successfully",
                                          callback: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            HomeScreen.route(),
                                            (route) => false);
                                      });
                                    } else {
                                      showErrorMessage(context,
                                          message: "Couldn't remove ad");
                                    }
                                  } on ErrorHandler catch (ex) {}
                                },
                              ),
                            )),
                        SizedBox(
                          width: 10,
                        ),
                        BlocBuilder<AdBloc, AdState>(
                          builder: (context, state) {
                            return Expanded(
                                flex: 1,
                                child: SizedBox(
                                  height: 40,
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(15),
                                        ),
                                    ),
                                    color: StyleResources.green,
                                    child: Text("Edit",
                                        style: StyleResources.buttonFontStyle),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          EditAdsScreen.route(state is AdLoaded
                                              ? state.adModel
                                              : widget.ad)
                                      );
                                    },
                                  ),
                                ),
                            );
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        BlocBuilder<AdBloc, AdState>(
                          builder: (context, state) {
                            return Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 40,
                                child: RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(15),
                                    ),
                                  ),
                                  color: StyleResources.green,
                                  child: Text("Images",
                                      style: StyleResources.buttonFontStyle),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        EditAdsImagesScreen.route(state is AdLoaded
                                            ? state.adModel
                                            : widget.ad)
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Comments",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: StyleResources.green,
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                BlocBuilder<ReviewBloc, ReviewState>(builder: (context, state) {
                  if (state is ReviewInitial || state is AddingReview) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is ReviewsLoaded) {
                    return Column(
                      children: state.reviews
                          .map((e) => Column(
                                children: [
                                  ReviewComponent(
                                    reviewModel: e,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ))
                          .toList(),
                    );
                  }
                  if (state is ReviewError) {
                    return Center(child: Text(state.message));
                  }
                  return Container();
                }),
                SizedBox(
                  height: 10,
                )
              ],
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

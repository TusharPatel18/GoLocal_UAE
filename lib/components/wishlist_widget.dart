import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/favourite/favourite_bloc.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:http/http.dart' as http;

class WishlistWidget extends StatelessWidget{
  final bool isFavourite;
  final VoidCallback onWished;

  const WishlistWidget({Key key, this.isFavourite:true, this.onWished}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FavouriteBloc>(
      create: (context)=>FavouriteBloc(AdsRepository(ApiHandler(http.Client()))),
      child: InkWell(
        onTap: onWished,
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFavourite?Colors.white:StyleResources.green
          ),
          child: Icon(Icons.favorite,color: isFavourite?StyleResources.green:Colors.white,),
        ),
      ),
    );
  }

}
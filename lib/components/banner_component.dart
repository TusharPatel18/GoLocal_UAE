import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/banners/banner_bloc.dart';

class BannerComponent extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: MediaQuery.of(context).size.width,
      child: BlocBuilder<BannerBloc,BannerState>(
        builder:(context,state) {
          if(state is BannerInitial){
            return Center(child: CircularProgressIndicator(),);
          }
          if(state is BannersLoaded){
            return CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                pauseAutoPlayOnTouch: true,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
                aspectRatio: 1,
                viewportFraction: 1,
              ),
              items: List.generate(
                  state.banners.length,
                      (index) => Container(
                    width: double.infinity,
                    child: CachedNetworkImage(
                      imageUrl: state.banners[index].bannerUrl,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fitWidth,
                      placeholder: (context, source) =>
                          Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ),
            );
          }
          if(state is BannerError){
            return Center(child:Text(state.message));
          }
          return Container();
        }
      ),
    );
  }
}

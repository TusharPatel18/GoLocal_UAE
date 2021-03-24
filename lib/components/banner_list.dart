import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdBannerList extends StatelessWidget {
  final List<String> images;
  final List<String> imgtitles;

  const AdBannerList({@required this.images,this.imgtitles}) : super();

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.45,
        width: MediaQuery.of(context).size.width,
        child: CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            pauseAutoPlayOnTouch: true,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            aspectRatio: 1,
            viewportFraction: 1,
          ),
          items:  List.generate(
                images.length,
                    (index) => Stack(
                      children: [
                        Container(
                           width: double.infinity,
                        child: CachedNetworkImage(
                             imageUrl: images[index],
                             width: MediaQuery.of(context).size.width,
                             fit: BoxFit.cover,
                             placeholder: (context, source) =>
                            Center(child: CircularProgressIndicator()),
                          ),
                         ),
                        Container(
                          alignment: Alignment.bottomRight,
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          width: double.infinity,
                          height: 300,
                          child: Text(imgtitles[index],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                        ),
                      ],
                    ),
              ),
        ),
    );
  }
}

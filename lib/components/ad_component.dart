import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_local_vendor/components/time_component.dart';
import 'package:go_local_vendor/components/wishlist_widget.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/ad_details_screen.dart';

class AdComponent extends StatelessWidget {
  final bool isFavourite;
  final AdModel ad;

  const AdComponent({this.isFavourite: false, @required this.ad}) : super();


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, AdDetailsScreen.route(ad));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 4.0,
        shadowColor: StyleResources.green.withOpacity(0.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: TimeComponent(
                  time: ad.createdAt,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Text(
                ad.title,
                style: StyleResources.cardTitleStyle,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Stack(children: [
              Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: ad.imageurl[0],
                    placeholder: (context, source) =>
                        Center(child: CircularProgressIndicator()),
                    fit: BoxFit.cover,
                    width: 200,
                    height: 80,
                  ),
              ),
              // Positioned(
              //   right: 5,
              //   top: 5,
              //   child: WishlistWidget(
              //     isFavourite: isFavourite,
              //   ),
              // )
            ]),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      ad.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                  // IconButton(
                  //   iconSize: 18,
                  //   icon: Icon(Icons.thumb_up), onPressed: () {  },
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

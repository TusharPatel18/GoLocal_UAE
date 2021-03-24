import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/resources/style_resources.dart';

class RelatedItem extends StatelessWidget {
  final AdModel ad;

  const RelatedItem({@required this.ad}) : super();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigator.push()
      },
      child: SizedBox(
        height: 135,
        width: 125,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          shadowColor: StyleResources.shadowColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: Container(
                    height: 100,
                    width: 125,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                    ),
                    child: CachedNetworkImage(
                      imageUrl: ad.imageurl[0],
                      fit: BoxFit.cover,
                    )),
              ),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    ad.title,
                    style: StyleResources.cardTitleStyle,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

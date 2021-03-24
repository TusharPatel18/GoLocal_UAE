import 'package:flutter/material.dart';
import 'package:go_local_vendor/components/time_component.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/ad_details_screen.dart';

class SearchItem extends StatelessWidget {
  final AdModel ads;

  const SearchItem({@required this.ads}) : super();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, AdDetailsScreen.route(ads));
      },
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Colors.grey.withOpacity(0.5), width: 0.2)),
        elevation: 4.0,
        shadowColor: StyleResources.shadowColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    ads.title,
                    style: StyleResources.cardTitleStyle,
                  ),
                  TimeComponent(
                    time: ads.createdAt,
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                ads.description,
                maxLines: 3,
                style: TextStyle(fontSize: 12),
              )
            ],
          ),
        ),
      ),
    );
  }
}

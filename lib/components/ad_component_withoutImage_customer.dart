import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_local_vendor/bloc/favourite/favourite_bloc.dart';
import 'package:go_local_vendor/components/time_component.dart';
import 'package:go_local_vendor/components/wishlist_widget.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/ad_details_screen.dart';

class AdComponentWithoutImageCustomer extends StatefulWidget {
  final AdModel ads;
  final FavouriteBloc bloc;
  const AdComponentWithoutImageCustomer({
    @required this.ads,
    @required this.bloc,
  }) : super();

  @override
  _AdComponentWithoutImageState createState() =>
      _AdComponentWithoutImageState();
}

class _AdComponentWithoutImageState
    extends State<AdComponentWithoutImageCustomer> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, AdDetailsScreen.route(widget.ads));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 0.5,
          ),
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
                  time: widget.ads.createdAt,
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
                widget.ads.title,
                style: StyleResources.cardTitleStyle,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Text(
                  widget.ads.description,
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  WishlistWidget(
                    isFavourite: widget.ads.userfavorite,
                    onWished: () {
                      widget.bloc.add(AddToFavourite(int.parse(widget.ads.id)));
                      setState(() {
                        widget.ads.userfavorite = !widget.ads.userfavorite;
                      });
                    },
                  ),
                  IconButton(
                    iconSize: 18,
                    onPressed: () {},
                    icon: Icon(
                      Icons.thumb_up,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

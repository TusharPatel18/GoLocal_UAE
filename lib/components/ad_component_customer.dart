import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_local_vendor/bloc/favourite/favourite_bloc.dart';
import 'package:go_local_vendor/components/time_component.dart';
import 'package:go_local_vendor/components/wishlist_widget.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/ad_details_screen.dart';

class AdComponentCustomer extends StatefulWidget {
  final AdModel adModel;
  final FavouriteBloc bloc;

  const AdComponentCustomer({
    @required this.adModel,
    @required this.bloc,
  }) : super();

  @override
  _AdComponentState createState() => _AdComponentState();
}

class _AdComponentState extends State<AdComponentCustomer> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.adModel.id);
        Navigator.push(context, AdDetailsScreen.route(widget.adModel));
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
                child: TimeComponent(time: widget.adModel.createdAt),
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
                widget.adModel.title,
                style: StyleResources.cardTitleStyle,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Stack(
                children: [
              Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.adModel.imageurl[0],
                    placeholder: (context, source) =>
                        Center(child: CircularProgressIndicator()),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 120,
                  ),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: WishlistWidget(
                  isFavourite: widget.adModel.userfavorite,
                  onWished: () {
                    widget.bloc.add(AddToFavourite(int.parse(widget.adModel.id)));
                    print(widget.adModel.userid);
                    setState(() {
                      widget.adModel.userfavorite = !widget.adModel.userfavorite;
                    });
                  },
                ),
              ),
            ]),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.adModel.description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                  IconButton(
                    iconSize: 18,
                    icon: Icon(Icons.thumb_up),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

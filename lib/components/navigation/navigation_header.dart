import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/resources/url_resources.dart';

class NavigationHeader extends StatelessWidget {
  final String name;
  final String image;
  final String phone;

  const NavigationHeader(
      {@required this.name, @required this.image, @required this.phone})
      : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Container(
            width: 75,
            height: 75,
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border:
                    Border.all(color: Colors.grey.withOpacity(0.2), width: .2),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 2),
                      blurRadius: 6,
                      color: StyleResources.green.withOpacity(0.4))
                ]),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(37.5),
              child: CachedNetworkImage(
                placeholder: (context, source) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                imageUrl: image,
                errorWidget: (context, _, __) {
                  return CachedNetworkImage(
                    imageUrl:
                        image ?? UrlResources.mainUrl + "upload/no-user-1.png",
                  );
                },
                width: 75,
                height: 75,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  name,
                  style: StyleResources.sideNavUserNameTextStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  phone,
                  style: StyleResources.sideNavUserPhoneTextStyle,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

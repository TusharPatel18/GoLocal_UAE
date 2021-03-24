import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/vendor/cubit/vendor_cubit.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/resources/url_resources.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorInfoComponent extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorCubit, VendorState>(builder: (context, state) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    (state is VendorLoaded)
                        ? state.user.firstName ?? "N/A"
                        : "N/A",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _buildDetailRow(
                      state is VendorLoaded
                          ? state.user.mobileNo ?? "N/A"
                          : "N/A",
                      Icon(
                        Icons.phone,
                        size: 15,
                      ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _buildDetailRow(
                      state is VendorLoaded
                          ? state.user.emailId ?? "N/A"
                          : "N/A",
                      Icon(
                        Icons.mail,
                        size: 15,
                      ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _buildDetailRow(
                      state is VendorLoaded
                          ? state.user.address ?? ""
                          : "N/A",
                      Icon(
                        Icons.location_on,
                        size: 15,
                      ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          var url = (state is VendorLoaded)
                              ? state.user.facebook ?? ""
                              : "";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                          // if (
                          // await canLaunch(
                          //       state is VendorLoaded
                          //     ? state.user.facebook
                          //     : 'https://facebook.com'
                          //        )
                          //    )
                          // {
                          //   launch(state is VendorLoaded
                          //       ? state.user.facebook
                          //       : 'https://facebook.com');
                          // }
                        },
                        child: Image.asset("assets/images/fb.png",width:35,height:35),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () async {
                            var url = (state is VendorLoaded)
                                ? state.user.instagram ?? ""
                                : "";
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: Image.asset("assets/images/instagram.png",width:35,height:35)),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () async {
                          var url = (state is VendorLoaded)
                              ? state.user.twitter ?? ""
                              : "";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Image.asset("assets/images/twitter.png",width:35,height:35
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: state is VendorLoaded
                              ?  NetworkImage(UrlResources.mainUrl + state.user.imageUrl)
                              : AssetImage("assets/images/no-user.png",),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(36.5)),
                          boxShadow: [
                            BoxShadow(
                                color: StyleResources.shadowColor,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      // ignore: deprecated_member_use
                      child: RaisedButton(
                        color: StyleResources.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                        ),
                        onPressed:() async {
                                var url = (state is VendorLoaded)
                                    ? state.user.mobileNo ?? "N/A"
                                    : "N/A";
                                if (await canLaunch('tel:$url')) {
                                  await launch('tel:$url');
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                        child: Text(
                          "Call Me",
                          style: TextStyle(color: Colors.white),
                         ),
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      );
    });
  }

  _buildDetailRow(String title, Icon icon, {VoidCallback onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          icon,
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

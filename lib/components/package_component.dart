import 'package:flutter/material.dart';
import 'package:go_local_vendor/models/package_model.dart';
import 'package:go_local_vendor/resources/style_resources.dart';

class PackageComponent extends StatelessWidget {
  final PackageModel package;
  final VoidCallback onPackageChoosed;

  const PackageComponent(
      {@required this.package, @required this.onPackageChoosed})
      : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 10),
      width: MediaQuery.of(context).size.width - 100,
      decoration: BoxDecoration(
          color: StyleResources.loginBg,
          borderRadius: BorderRadius.circular(15)),
      height: 270,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Text(package.title,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 18)),
                SizedBox(
                  height: 10,
                ),
                Text(package.description),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
            Column(children: [
              Text("Price",
                  style: TextStyle(color: Colors.black, fontSize: 12)),
              SizedBox(height: 5),
              Text(package.amount + " AED",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Theme.of(context).primaryColor,
                onPressed: onPackageChoosed,
                child: Text(
                  "Choose",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}

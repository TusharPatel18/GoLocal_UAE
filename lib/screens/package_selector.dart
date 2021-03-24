import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/package/package_cubit.dart';
import 'package:go_local_vendor/components/package_component.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/screens/payment_page.dart';
import 'package:go_local_vendor/utils/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as ioClient;

class PackageSelector extends StatefulWidget {
  final String email;
  final String phone;
  final String name;
  final String lastName;
  final String vendorOrCustomer;
  const PackageSelector(
      {Key key,
      this.email,
      this.phone,
      this.name,
      this.lastName,
      this.vendorOrCustomer})
      : super(key: key);
  static route(String vendorOrCustomer, String email, String phone, String name,
          String lastName) =>
      MaterialPageRoute(
          builder: (context) => PackageSelector(
                email: email,
                phone: phone,
                name: name,
                lastName: lastName,
                vendorOrCustomer: vendorOrCustomer,
              ));
  @override
  _PackageSelectorState createState() => _PackageSelectorState();
}

class _PackageSelectorState extends State<PackageSelector> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocProvider(
          create: (context) => PackageCubit()..getPackages(),
          child: BlocBuilder<PackageCubit, PackageState>(
            builder: (context, state) {
              if (state is PackageLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is PackageLoaded) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Choose Your Plan",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18)),
                    SizedBox(height: 10),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        height: 270,
                        child: PageView(
                            allowImplicitScrolling: true,
                            controller: PageController(
                                viewportFraction: .7, keepPage: true),
                            onPageChanged: (index) {},
                            children: state.packages
                                .map((e) => PackageComponent(
                                      package: e,
                                      onPackageChoosed: () {
                                        payNow(e);
                                      },
                                    ))
                                .toList())),
                  ],
                );
              }
              if (state is PackageError) {
                return Center(child: Text(state.message));
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  payNow(e) async {
    showLoaderDialog(context);
    try {
      var client = ioClient.IOClient();
      var request = http.Request(
        'POST',
        Uri.parse('https://secure.innovatepayments.com/gateway/mobile.xml'),
      );
      request.headers.addAll({
        'content-type': 'text/xml' // or text/xml;charset=utf-8
      });
      var deviceId = Platform.isAndroid
          ? (await deviceInfoPlugin.androidInfo).androidId
          : (await deviceInfoPlugin.iosInfo).identifierForVendor;
      SharedPreferences preferencs = await SharedPreferences.getInstance();
      User user = User.fromJson(json.decode(preferencs.getString("USER")));

      var xml = """<?xml version="1.0" encoding="UTF-8"?>
      <mobile>
        <store>24324</store>
        <key>sBchx-SxgCK^ggVk</key>
        <device>
          <type>Android</type>
          <id>$deviceId</id>
        </device>
        <app>
          <name>Go Local</name>
          <version>1.0</version>
          <user>${user.id}</user>
          <id>${user.id}</id>
        </app>
        <tran>
          <test>1</test>
          <type>auth</type>
          <class>paypage</class>
          <cartid>${user.id}</cartid>
          <description>Go Local Vendor Registration</description>
          <currency>AED</currency>
          <amount>${e.amount}</amount>
        </tran>
       
        <billing>
          <name>
            <first>${widget.name}</first>
            <last>${widget.lastName}</last>
          </name>
          <email>${widget.email}</email>
          <phone>${widget.phone}</phone>
        </billing>
    </mobile>
    """;
      // either
      request.body = xml;
      var streamedResponse = await client.send(request);

      String start = "";
      String close = "";
      String abort = "";
      String code = "";
      var responseBody =
          await streamedResponse.stream.transform(utf8.decoder).join();

      final document = XmlDocument.parse(responseBody);
      Iterable<XmlElement> test = document.findElements('mobile');
      test.forEach((element) async {
        if (element.name == XmlName('mobile')) {
          var auth = element.findElements('auth');
          if (auth.isNotEmpty) {
            auth.forEach((element1) {
              if (element1.name == XmlName('auth')) {
                // var status = element1.getElement('status').text;
                var message = element1.getElement('message').text;
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text("oops!"),
                          content: Text(message),
                          actions: [
                            FlatButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ));
              }
            });
          }
          var webvie = element.findElements('webview');
          webvie.forEach((element1) {
            if (element1.name == XmlName('webview')) {
              start = element1.getElement('start').text;
              close = element1.getElement('close').text;
              abort = element1.getElement('abort').text;
              code = element1.getElement('code').text;
              setState(() {});
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentPage(
                          startUrl: start,
                          closeUrl: close,
                          abortUrl: abort,
                          code: code)));
            }
          });
        }
      });

      client.close();
    } on SocketException {
      Navigator.pop(context);
      showErrorMessage(context, message: "Couldn't connect to server");
    }
  }
}

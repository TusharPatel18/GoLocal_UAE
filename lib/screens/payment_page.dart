import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_local_vendor/screens/login_screen.dart';
import 'package:go_local_vendor/utils/dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart' as ioClient;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:xml/xml.dart';

class PaymentPage extends StatelessWidget {
  final String startUrl;
  final String closeUrl;
  final String abortUrl;
  final String code;

  const PaymentPage({Key key,@required this.startUrl,@required this.closeUrl,@required this.abortUrl,this.code, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return SafeArea(
          child: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: startUrl,
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith(closeUrl)) {
          
            completePayment(context,'success');

          }else if(request.url.startsWith(abortUrl)){
           
            completePayment(context,'fail');
          }
          return NavigationDecision.navigate;
        },

      ),
    );
  }

  completePayment(context,status) async {
    showLoaderDialog(context);
    var client = ioClient.IOClient();
    var request = http.Request(
      'POST',
      Uri.parse('https://secure.innovatepayments.com/gateway/mobile_complete.xml'),
    );
    request.headers.addAll({
      'content-type': 'text/xml' // or text/xml;charset=utf-8
    });

    var xml = """<?xml version="1.0" encoding="UTF-8"?>
      <mobile>
        <store>24324</store>
        <key>sBchx-SxgCK^ggVk</key>
        <complete>${this.code}</complete>
      </mobile>
    """;
    // either
    request.body = xml;
    var streamedResponse = await client.send(request);
    
    var responseBody =
    await streamedResponse.stream.transform(utf8.decoder).join();
    
    final document = XmlDocument.parse(responseBody);
    Iterable<XmlElement> test = document.findElements('mobile');
    test.forEach((element) async {
      if(element.name==XmlName('mobile')){
        var auth = element.findElements('auth');
        if(auth.isNotEmpty){
          auth.forEach((element1) {
            if(element1.name==XmlName('auth')){
              var stat = element1.getElement('status').text;
              var message = element1.getElement('message').text;
              Navigator.pop(context);
              showDialog(context: context,builder: (context)=>AlertDialog(title:Text(status=='success' && stat=='A'?"Success":"Oops!"),content:Text(message),actions: [
                status=='success' && stat=='A'
                    ?FlatButton(child: Text("OK"),onPressed: (){
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(context,LoginScreen.route(),(route)=>false);
                },):FlatButton(child: Text("Retry"),onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  
                  // Navigator.pop(context);
                  // Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>WebViewPage(
                  //     startUrl:this.startUrl,
                  //     closeUrl: this.closeUrl,
                  //     abortUrl: this.abortUrl,
                  //     code:code
                  // )));
                },)
              ],));
            }

          });
        }

      }
    });
  }
}

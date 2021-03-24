import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/resources/url_resources.dart';
import 'package:go_local_vendor/screens/ad_details_screen.dart';
import 'package:go_local_vendor/screens/home_screen.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/dialogs.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class EditAdsImagesScreen extends StatefulWidget {
  final AdModel adModel;
  static route(AdModel adModel) => MaterialPageRoute(
    builder: (context) => EditAdsImagesScreen(
      adModel: adModel,
    ),
  );
  const EditAdsImagesScreen({Key key, this.adModel}) : super(key: key);

  @override
  _EditAdsImagesScreenState createState() => _EditAdsImagesScreenState();
}

class _EditAdsImagesScreenState extends State<EditAdsImagesScreen> {
  List<File> images = [];
  List<String> image1 = [];
  List<String> titles = [];
  List<String> titles1 = [];
  List<String> imagid = [];
  List<TextEditingController> _ImageController =  [
    for (int i = 1; i < 20; i++)
      TextEditingController()
  ];
  @override
  void initState() {
    image1 = widget.adModel.imageurl;
    titles =widget.adModel.imagetitle;
    imagid = widget.adModel.imageid;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Images"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Column(
                children: [
                  (image1 != null)
                      ? Visibility(
                    visible: image1.length > 0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Row(
                                children: [
                                  Column(
                                    children: List.generate(
                                      image1.length,
                                          (index) =>
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 80,
                                                    margin: EdgeInsets.fromLTRB(1, 0, 5, 0),
                                                    // ignore: deprecated_member_use
                                                    child: RaisedButton(
                                                      textColor: Colors.white,
                                                      color: Colors.redAccent,
                                                      onPressed: () async {
                                                        var response= await http.post(UrlResources.delete_ads_images,body: {"image_id":imagid[index]});
                                                        if(response.statusCode==200)
                                                          {
                                                            Navigator.pushAndRemoveUntil(
                                                                context,
                                                                HomeScreen.route(),
                                                                    (route) => false);
                                                          }
                                                      },
                                                      child: Text('Delete'),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 75,
                                                    height: 75,
                                                    margin: EdgeInsets.only(right: 10),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey.withOpacity(0.5),
                                                      border: Border.all(color: Colors.grey),
                                                    ),
                                                    child: CachedNetworkImage(
                                                      imageUrl: this.image1[index],
                                                      width: MediaQuery.of(context).size.width,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, source) =>
                                                          Center(child: CircularProgressIndicator()),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10,)
                                            ],
                                          ),
                                    ),
                                  ),
                                  Column(
                                    children: List.generate(
                                      titles.length,
                                          (index) => Column(
                                            children: [
                                              Container(
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        height: 75,
                                        child: InputDecorator(
                                              decoration: InputDecoration(
                                                // floatingLabelBehavior: FloatingLabelBehavior.never,
                                                contentPadding: EdgeInsets.symmetric(
                                                    vertical: 30.0, horizontal: 10.0),
                                                border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                  //    borderSide: BorderSide.none
                                                ),
                                              ),
                                              child: Text(titles[index]),
                                        ),
                                      ),
                                              SizedBox(height: 10,)
                                            ],
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                      ),
                    ),
                  )
                      : Container(),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Choose Source.."),
                      content: Text("From Where you want to Upload your Product/Services Image ?"),
                      actions: [
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: () async {
                            showLoaderDialog(context);
                            try {
                              // ignore: deprecated_member_use
                              var image = await ImagePicker.pickImage(
                                source: ImageSource.camera,);
                              images.add(File(image.path));
                              setState(() {});
                            } catch (ex) {}
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text("CAMERA"),
                        ),
                        // ignore: deprecated_member_use
                        FlatButton(
                          onPressed: () async {
                            showLoaderDialog(context);
                            try {
                              // ignore: deprecated_member_use
                              var image = await ImagePicker.pickImage(
                                source: ImageSource.gallery,);
                              images.add(File(image.path));
                              setState(() {});
                            } catch (ex) {}
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text("GALLERY"),
                        ),
                      ],
                    ),
                  );
                },
                child: SizedBox(
                  width: 75,
                  height: 75,
                  child: Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                    ),
                    shadowColor: StyleResources.shadowColor,
                    child: Icon(
                      EvilIcons.camera,
                      size: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: (images.isEmpty)
                    ? Container()
                    : Visibility(
                  visible: images.length > 0,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: List.generate(
                        images.length,
                            (index) => Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Row(
                            children: [
                              Container(
                                width: 75,
                                height: 75,
                                margin: EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Image.file(
                                  images[index],
                                  fit: BoxFit.cover,
                                  width: 75,
                                  height: 75,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                height: 75,
                                child: TextFormField(
                                  maxLines: 4,
                                  controller: _ImageController[index],
                                  decoration: InputDecoration(
                                    // floatingLabelBehavior: FloatingLabelBehavior.never,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                      ),
                      color: StyleResources.green,
                      onPressed: () async {
                        for(int i=0;i<images.length;i++)
                        {
                          titles1.add(_ImageController[i].text.toString());
                        }
                        if(titles1.isEmpty)
                          {
                            showErrorMessage(context,
                                message: "Please enter a valid title for image");
                          }else{
                          showLoaderDialog(context);
                          try{
                            setState(() {});
                            String message = await AdsRepository(ApiHandler(http.Client())).updateAdImage(
                              widget.adModel.id,
                              images,
                              titles1,
                            );
                            Navigator.pop(context);
                            showSuccessMessage(context, message: message,
                                callback: () {
                                  Navigator.pushAndRemoveUntil(context,
                                      HomeScreen.route(),(route) => false);
                                });
                          } catch (ex) {}
                        }
                      },
                      child: Text(
                        "Add",
                        style: StyleResources.buttonFontStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

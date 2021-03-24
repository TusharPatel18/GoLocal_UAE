import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_local_vendor/bloc/categories/cubit/categories_cubit.dart';
import 'package:go_local_vendor/components/text_field_wrapper.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/models/category_model.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/dialogs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';

class EditAdsScreen extends StatefulWidget {
  final AdModel adModel;
  static route(AdModel adModel) => MaterialPageRoute(
      builder: (context) => EditAdsScreen(
            adModel: adModel,
          ),
  );
  const EditAdsScreen({Key key, this.adModel}) : super(key: key);
  @override
  _EditAdsScreenState createState() => _EditAdsScreenState();
}

class _EditAdsScreenState extends State<EditAdsScreen> {


  final picker = ImagePicker();
  String _type = "Product";
  final titleTextEditingController =
      TextEditingController(text: "Product Title");
  final descriptionTextEditingController =
      TextEditingController(text: "Product Description");
  List<CategoryModel> _selectedCategories = [];

  bool isInitial = false;

  @override
  void initState() {
    setState(() {
      _type = widget.adModel.adstype;
      titleTextEditingController.text = widget.adModel.title;
      descriptionTextEditingController.text = widget.adModel.description;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit Product/Service"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                TextFieldWrapper(
                  child: TextFormField(
                    controller: titleTextEditingController,
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 16.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none),
                        labelText: "Title"),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Choose Category"),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: BlocProvider<CategoriesCubit>(
                      create: (context) =>
                          CategoriesCubit()..getAllCategories(),
                      child: BlocBuilder<CategoriesCubit, CategoriesState>(
                        builder: (context, state) {
                          if (state is CategoriesLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is CategoriesLoaded) {
                            
                            if (widget.adModel.categories.length > 0 &&
                                state.categories.length > 0 &&
                                !isInitial) {
                              isInitial = true;
                              // _selectedCategories = [];
                              _selectedCategories
                                ..addAll(state.categories.where((element) =>
                                    widget.adModel.categories
                                        .contains(element.id)));
                              // setState(() {});
                            }
                            return ChipsChoice.multiple(
                                isWrapped: false,
                                value: _selectedCategories,
                                options: state.categories
                                    .map((e) =>
                                        ChipsChoiceOption<CategoryModel>(
                                            label: e.categoriesname, value: e))
                                    .toList(),
                                onChanged: (val) {
                                  _selectedCategories = val;
                                  setState(() {});
                                });
                             }
                          return Container();
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _type = "Product";
                          });
                        },
                        child: Row(children: [
                          Radio(
                            groupValue: _type,
                            value: 'Product',
                            onChanged: (val) {
                              setState(() {
                                _type = val;
                              });
                            },
                          ),
                          Text("Product")
                        ]),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _type = "Service";
                          });
                        },
                        child: Row(children: [
                          Radio(
                            groupValue: _type,
                            value: 'Service',
                            onChanged: (val) {
                              setState(() {
                                _type = val;
                              });
                            },
                          ),
                          Text("Service"),
                        ]),
                      ),
                    ]),
                SizedBox(
                  height: 10,
                ),
                TextFieldWrapper(
                  child: TextFormField(
                    maxLines: 5,
                    controller: descriptionTextEditingController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none),
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        labelText: "Description Goes Here..."),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                // InkWell(
                //   onTap: () async {
                //     try {
                //       PickedFile image = await picker.getImage(source: ImageSource.gallery);
                //       images.add(File(image.path));
                //
                //       setState(() {});
                //     } catch (ex) {}
                //   },
                //   child: SizedBox(
                //     width: 75,
                //     height: 75,
                //     child: Card(
                //       elevation: 4.0,
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(15)
                //       ),
                //       shadowColor: StyleResources.shadowColor,
                //       child: Icon(
                //         EvilIcons.camera,
                //         size: 40,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: 5,
                // ),
                // Column(
                //   children: [
                //     (image1 != null)
                //         ? Visibility(
                //       visible: image1.length > 0,
                //       child: SingleChildScrollView(
                //         scrollDirection: Axis.vertical,
                //         child: Column(
                //           children: List.generate(
                //             image1.length,
                //                 (index) => Container(
                //               margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                //               child: Row(
                //                 children: [
                //                   Container(
                //                     width: 80,
                //                     margin: EdgeInsets.fromLTRB(1, 0, 5, 0),
                //                     child: RaisedButton(
                //                       textColor: Colors.white,
                //                       color: Colors.redAccent,
                //                       onPressed: ()=>null,
                //                       child: Text('Delete'),
                //                     ),
                //                   ),
                //                   Container(
                //                     width: 75,
                //                     height: 75,
                //                     margin: EdgeInsets.only(right: 10),
                //                     decoration: BoxDecoration(
                //                       color: Colors.grey.withOpacity(0.5),
                //                       border: Border.all(color: Colors.grey),
                //                     ),
                //                     child: CachedNetworkImage(
                //                       imageUrl: this.image1[index],
                //                       width: MediaQuery.of(context).size.width,
                //                       fit: BoxFit.cover,
                //                       placeholder: (context, source) =>
                //                           Center(child: CircularProgressIndicator()),
                //                     ),
                //                   ),
                //                   SizedBox(
                //                     width: 5,
                //                   ),
                //                   Container(
                //                     width: MediaQuery.of(context).size.width * 0.45,
                //                     height: 75,
                //                     child: TextFormField(
                //                       maxLines: 4,
                //                       controller: _ImageController[index],
                //                       decoration: InputDecoration(
                //                         // floatingLabelBehavior: FloatingLabelBehavior.never,
                //                         contentPadding: EdgeInsets.symmetric(
                //                             vertical: 10.0, horizontal: 10.0),
                //                         border: OutlineInputBorder(
                //                           borderRadius: BorderRadius.circular(10),
                //                           //    borderSide: BorderSide.none
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     )
                //         : Container(),
                //     (images.isEmpty)
                //         ? Container()
                //         : Visibility(
                //       visible: images.length > 0,
                //           child: SingleChildScrollView(
                //       scrollDirection: Axis.vertical,
                //       child: Column(
                //           children: List.generate(
                //             images.length,
                //                 (index) => Container(
                //               margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                //               child: Row(
                //                 children: [
                //                   Container(
                //                     width: 80,
                //                     margin: EdgeInsets.fromLTRB(1, 0, 5, 0),
                //                     child: RaisedButton(
                //                       textColor: Colors.white,
                //                       color: Colors.redAccent,
                //                       onPressed: ()=>null,
                //                       child: Text('Delete'),
                //                     ),
                //                   ),
                //                   Container(
                //                     width: 75,
                //                     height: 75,
                //                     margin: EdgeInsets.only(right: 10),
                //                     decoration: BoxDecoration(
                //                       color: Colors.grey.withOpacity(0.5),
                //                       border: Border.all(color: Colors.grey),
                //                     ),
                //                     child: Image.file(
                //                       images[index],
                //                       fit: BoxFit.cover,
                //                       width: 75,
                //                       height: 75,
                //                     ),
                //                   ),
                //                   SizedBox(
                //                     width: 5,
                //                   ),
                //                   Container(
                //                     width: MediaQuery.of(context).size.width * 0.45,
                //                     height: 75,
                //                     child: TextFormField(
                //                       maxLines: 4,
                //                       controller: _ImageController[index],
                //                       decoration: InputDecoration(
                //                         // floatingLabelBehavior: FloatingLabelBehavior.never,
                //                         contentPadding: EdgeInsets.symmetric(
                //                             vertical: 10.0, horizontal: 10.0),
                //                         border: OutlineInputBorder(
                //                           borderRadius: BorderRadius.circular(10),
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //       ),
                //     ),
                //    ),
                //   ],
                // ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.grey,
                        onPressed: () {
                                    Navigator.pop(context);
                        },
                        child: Text(
                          "Cancel",
                          style: StyleResources.buttonFontStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: StyleResources.green,
                        onPressed: () async {
                          // for(int i=0;i<=images.length;i++)
                          // {
                          //   titles.add(_ImageController[i].text.toString());
                          // }
                          if (titleTextEditingController.text.isEmpty) {
                            showErrorMessage(context,
                                message: "Please enter a valid title");
                          } else if (descriptionTextEditingController
                              .text.isEmpty) {
                            showErrorMessage(context,
                                message: "Please enter a valid description");
                          } else if (_selectedCategories == null ||
                              _selectedCategories.length == 0) {
                            showErrorMessage(context,
                                message: "Please select at least one category");
                          } else {
                            try {
                              String categoriesId = "";
                              _selectedCategories.forEach((element) {
                                categoriesId += element.id +
                                    (_selectedCategories.indexOf(element) !=
                                            _selectedCategories.length - 1
                                        ? ','
                                        : '');
                              });

                              setState(() {});

                              String message = await AdsRepository(ApiHandler(http.Client())).updateAd(
                                          categoriesId,
                                          _type,
                                          descriptionTextEditingController.text,
                                          titleTextEditingController.text,
                                          widget.adModel.id,
                                  );
                              showSuccessMessage(context, message: message,
                                  callback: () {
                                Navigator.pushAndRemoveUntil(context,
                                    HomeScreen.route(), (route) => false);
                              });
                            } catch (ex) {}
                          }
                        },
                        child: Text(
                          "Update",
                          style: StyleResources.buttonFontStyle,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ));
  }
}

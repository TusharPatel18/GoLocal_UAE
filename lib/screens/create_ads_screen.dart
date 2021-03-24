import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:go_local_vendor/bloc/areas/areas_cubit.dart';
import 'package:go_local_vendor/bloc/categories/cubit/categories_cubit.dart';
import 'package:go_local_vendor/bloc/create_ad/cubit/create_ad_cubit.dart';
import 'package:go_local_vendor/bloc/emirates/emirates_cubit.dart';
import 'package:go_local_vendor/components/text_field_wrapper.dart';
import 'package:go_local_vendor/models/area_model.dart';
import 'package:go_local_vendor/models/category_model.dart';
import 'package:go_local_vendor/models/emirate_model.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/resources/style_resources.dart';
import 'package:go_local_vendor/screens/home_screen.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/dialogs.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class CreateAdsScreen extends StatefulWidget {
  const CreateAdsScreen({Key key}) : super(key: key);
  static route() => MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => CreateAdCubit(),
              ),
              BlocProvider(
                create: (context) => EmiratesCubit()..getEmirates(),
              ),
              BlocProvider(
                create: (context) => CategoriesCubit()..getAllCategories(),
              ),
              BlocProvider(
                create: (context) => AreasCubit(),
              ),
            ],
            child: CreateAdsScreen(),
          ),
  );
  @override
  _CreateAdsScreenState createState() => _CreateAdsScreenState();
}

class _CreateAdsScreenState extends State<CreateAdsScreen> {
  List<File> images = [];
  List<String> titles = [];
  final picker = ImagePicker();
  CategoryModel categoryModel;
  String productOrService = "Product";
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  // List<String> _ImageController =  [
  //   for (int i = 0; i < 20; i++){
  //     TextEditingController();
  //   }
  // ];
  final _formKey = GlobalKey<FormState>();
  List<CategoryModel> _selectedCategories = [];
  EmirateModel selectedEmirate;
  AreaModel selectedArea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Product/Service"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  TextFieldWrapper(
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 20.0),
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
                      child: BlocBuilder<CategoriesCubit, CategoriesState>(
                        builder: (context, state) {
                          if (state is CategoriesLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is CategoriesLoaded) {
                            return ChipsChoice.multiple(
                                isWrapped: false,
                                value: _selectedCategories,
                                options: state.categories
                                    .map((e) =>
                                        ChipsChoiceOption<CategoryModel>(
                                            label: e.categoriesname, value: e)).toList(),
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
                  SizedBox(
                    height: 10,
                  ),
                  Text("Choose Emirate"),
                  SizedBox(height: 5),
                  Container(
                    child: Center(
                      child: BlocBuilder<EmiratesCubit, EmiratesState>(
                        builder: (context, state) {
                          if (state is EmiratesLoading) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (state is EmiratesLoaded) {
                            return TextFieldWrapper(
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      value: selectedEmirate,
                                      items: state.emirates
                                          .map((e) => DropdownMenuItem(
                                              value: e, child: Text(e.name)))
                                          .toList(),
                                      onChanged: (val) {
                                        BlocProvider.of<AreasCubit>(context)
                                          ..getAreas(val.id);
                                        selectedEmirate = val;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return Container();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Center(
                      child: BlocBuilder<AreasCubit, AreasState>(
                        builder: (context, state) {
                          if (state is AreasLoading) {
                            return Center(
                                child: CircularProgressIndicator(),
                            );
                          }
                          if (state is AreasLoaded) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Choose Area"),
                                SizedBox(height: 5),
                                TextFieldWrapper(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          value: selectedArea,
                                          items: state.areas
                                              .map((e) => DropdownMenuItem(
                                                  value: e,
                                                  child: Text(e.name),
                                             ),
                                          ).toList(),
                                          onChanged: (val) {
                                            selectedArea = val;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                          return Container();
                        },
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
                              productOrService = "Product";
                            });
                          },
                          child: Row(children: [
                            Radio(
                              groupValue: productOrService,
                              value: 'Product',
                              onChanged: (val) {
                                setState(() {
                                  productOrService = val;
                                });
                              },
                            ),
                            Text("Product")
                          ]),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              productOrService = "Service";
                            });
                          },
                          child: Row(children: [
                            Radio(
                              groupValue: productOrService,
                              value: 'Service',
                              onChanged: (val) {
                                setState(() {
                                  productOrService = val;
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
                      controller: descriptionController,
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
                                  getImageFromCamera();
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
                                  getImageFromGallery();
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
                            borderRadius: BorderRadius.circular(15)),
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
                  Visibility(
                    visible: images.length > 0,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
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
                                      // controller: _ImageController[index],
                                      onChanged:(val) => titles[index] = val,
                                      decoration: InputDecoration(
                                          // floatingLabelBehavior: FloatingLabelBehavior.never,
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 10.0),
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(10),
                                          //    borderSide: BorderSide.none
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
                            Navigator.pushAndRemoveUntil(
                                context, HomeScreen.route(), (route) => false);
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
                            if (titleController.text.isEmpty) {
                              showErrorMessage(context,
                                  message: "Please enter a valid title");
                            } else if (descriptionController.text.isEmpty) {
                              showErrorMessage(context,
                                  message: "Please enter a valid description");
                            } else if (_selectedCategories == null ||
                                _selectedCategories.length == 0) {
                              showErrorMessage(context,
                                  message: "Please select at least one category");
                            } else if (selectedArea == null) {
                              showErrorMessage(context,
                                  message: "Please select area");
                            } else {
                              showLoaderDialog(context);
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

                                String message = await AdsRepository(ApiHandler(http.Client())).createAd(
                                        categoriesId.toString(),
                                        productOrService,
                                        descriptionController.text,
                                        titleController.text,
                                        selectedArea.id,
                                        images,
                                        titles,
                                );
                                Navigator.pop(context);
                                showSuccessMessage(context, message: message,
                                    callback: () {
                                  Navigator.pushAndRemoveUntil(context,
                                      HomeScreen.route(), (route) => false);
                                });
                              } catch (ex) {}
                            }
                          },
                          child: Text(
                            "Create",
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
          ),
        ),
    );
  }

  Future getImageFromCamera() async {
    try {
      PickedFile image =
      await picker.getImage(source: ImageSource.camera);
      images.add(File(image.path));
      titles.add("string");
      setState(() {});
    } catch (ex) {}
  }

  Future getImageFromGallery() async {
    try {
      PickedFile image =
      await picker.getImage(source: ImageSource.gallery);
      images.add(File(image.path));
      titles.add("string");
      setState(() {});
    } catch (ex) {}
  }

}

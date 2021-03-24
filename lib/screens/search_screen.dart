import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/areas/areas_cubit.dart';
import 'package:go_local_vendor/bloc/emirates/emirates_cubit.dart';
import 'package:go_local_vendor/bloc/search/cubit/search_cubit.dart';
import 'package:go_local_vendor/components/search_item.dart';
import 'package:go_local_vendor/components/text_field_wrapper.dart';
import 'package:go_local_vendor/models/area_model.dart';
import 'package:go_local_vendor/models/emirate_model.dart';
import 'package:go_local_vendor/resources/style_resources.dart';

class SearchScreen extends StatefulWidget {
  static route() => MaterialPageRoute(
      builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider<SearchCubit>(
                create: (context) => SearchCubit(),
              ),
              BlocProvider<EmiratesCubit>(
                create: (context) => EmiratesCubit()..getEmirates(),
              ),
              BlocProvider<AreasCubit>(
                create: (context) => AreasCubit(),
              )
            ],
            child: SearchScreen(),
          ));

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String searchType = 'all';
  EmirateModel selectedEmirate;
  AreaModel selectedArea;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: StyleResources.scaffoldBackgroundColor,
      // appBar: AppBar(
      //  leading: IconButton(
      //       icon: Icon(
      //         Icons.search,
      //         color: Colors.white,
      //       ),
      //       onPressed: () {},
      //     ),
      //     title:Text("Search"),
      //   actions: <Widget>[
      //     IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: Icon(Icons.clear),
      //       color: Colors.white,
      //     )
      //   ],
      // ),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            color: StyleResources.green,
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              searchType = 'all';
                              setState(() {});
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text("All",
                                    style: TextStyle(
                                        color: searchType == 'all'
                                            ? Colors.green
                                            : Colors.black,
                                        fontSize: 15))),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              searchType = 'emirate';
                              setState(() {});
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text("Emirates",
                                    style: TextStyle(
                                        color: searchType == 'emirate'
                                            ? Colors.green
                                            : Colors.black,
                                        fontSize: 15))),
                          ),
                          SizedBox(width: 5),
                          InkWell(
                            onTap: () {
                              searchType = 'area';
                              setState(() {});
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Text("Area",
                                    style: TextStyle(
                                        color: searchType == 'area'
                                            ? Colors.green
                                            : Colors.black,
                                        fontSize: 15))),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.clear),
                      color: Colors.white,
                    )
                  ],
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: searchType == 'emirate' || searchType == 'area',
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Choose Emirate",
                          style: TextStyle(color: Colors.white)),
                      SizedBox(height: 5),
                      BlocBuilder<EmiratesCubit, EmiratesState>(
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
                                      horizontal: 8.0),
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
                      SizedBox(height: 10),
                      Visibility(
                        visible: searchType == 'area',
                        child: BlocBuilder<AreasCubit, AreasState>(
                          builder: (context, state) {
                            if (state is AreasLoading) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (state is AreasLoaded) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Choose Area",
                                      style: TextStyle(color: Colors.white)),
                                  SizedBox(height: 5),
                                  TextFieldWrapper(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            value: selectedArea,
                                            items: state.areas
                                                .map((e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Text(e.name)))
                                                .toList(),
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
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  height: 40,
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 2),
                            color: StyleResources.shadowColor,
                            blurRadius: 4),
                      ]),
                  child: TextFormField(
                      onChanged: (val) {
                        try {
                          if (searchType == 'emirate') {
                            context.bloc<SearchCubit>()
                              ..searchAd(val, searchType, selectedEmirate?.id);
                          } else if (searchType == 'area') {
                            context.bloc<SearchCubit>()
                              ..searchAd(val, searchType, selectedArea?.id);
                          } else {
                            context.bloc<SearchCubit>()..searchAd(val, '', '');
                          }
                        } catch (ex) {}
                      },
                      decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          labelText: "Search here",
                          floatingLabelBehavior: FloatingLabelBehavior.never)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state is Searching) {
                    return Center(
                        child: Center(child: CircularProgressIndicator()));
                  }
                  if (state is SearchLoaded) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            ...state.ads
                                .map((e) => SearchItem(
                                      ads: e,
                                    ))
                                .toList()
                          ],
                        ),
                      ),
                    );
                  }
                  if (state is SearchError) {
                    return Center(child: Text(state.message));
                  }
                  return Container(
                      child: Center(
                          child: Text(
                              "Please type something to start searching")));
                },
              ),
            ),
          ),
        ],
      )),
      bottomNavigationBar: Container(
          height: 30,
          color: StyleResources.green,
          child: Center(
              child: Text("Enter at least 3 charecters to search",
                  style: TextStyle(color: Colors.white)))),
    );
  }
}

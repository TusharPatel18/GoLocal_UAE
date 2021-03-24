import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_local_vendor/bloc/category/category_bloc.dart';
import 'package:go_local_vendor/components/category/category_item.dart';
import 'package:go_local_vendor/components/home_button.dart';
import 'package:go_local_vendor/components/navigation/bottom_navigation_customer.dart';
import 'package:go_local_vendor/models/category_model.dart';
import 'package:go_local_vendor/repository/category_repository.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:http/http.dart' as http;

class CategoriesScreen extends StatefulWidget {
  static const String meta = "categories_screen";
  
  static route() => MaterialPageRoute(
      builder: (context) => BlocProvider<CategoryBloc>(
          create: (context) =>
              CategoryBloc(CategoryRepository(ApiHandler(http.Client())))
                ..add(GetCategories(1)),
          child: CategoriesScreen()));

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  List<CategoryModel> categories = [];

  @override
  void initState() {
    super.initState();
  }

  bool _handleScroll(
    ScrollNotification notification,
  ) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      BlocProvider.of<CategoryBloc>(context).add(GetCategories(
        _currentPage,
      ));
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("Categories"),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              children: [
                Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _handleScroll,
                    child: BlocBuilder<CategoryBloc, CategoryState>(
                        builder: (context, state) {
                      if (state is CategoryInitial) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is CategoriesLoading) {
                        return GridView.builder(
                          controller: _scrollController,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 1),
                          itemCount: state.categories.length + 1,
                          itemBuilder: (context, index) {
                            if (index > state.categories.length - 1) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return CategoryItem(
                              categoryModel: state.categories[index],
                            );
                          },
                        );
                      }
                      if (state is CategoriesLoaded) {
                        categories = categories..addAll(state.categories);
                        _currentPage = state.page + 1;
                        if (state.categories.length != 0) {
                          BlocProvider.of<CategoryBloc>(context).add(
                            GetCategories(_currentPage, categories: categories),
                          );
                        }
                        return GridView.builder(
                          controller: _scrollController,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3, childAspectRatio: 1),
                          itemCount: categories.length,
                          itemBuilder: (context, index) => CategoryItem(
                            categoryModel: categories[index],
                          ),
                        );
                      }
                      if (state is CategoryError) {
                        return Center(
                          child: Text(state.message),
                        );
                      }
                      return Container();
                    }),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigation(),
        ),
        Positioned(
          left: 30,
          bottom: 25,
          child: HomeButton(),
        ),
      ],
    );
  }
}

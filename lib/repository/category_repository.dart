import 'dart:convert';

import 'package:go_local_vendor/models/category_model.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/url_resources.dart';
import '../utils/api_response.dart';
import '../utils/api_handler.dart';

class CategoryRepository{
  final ApiHandler _handler;

  CategoryRepository(this._handler);

  Future<List<CategoryModel>> getCategories (int page) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    ApiListResponse response = await _handler.postList(UrlResources.categories,body: {
      "page":page.toString(),
      'userid':user.id.toString()
    });

    if(response.status=='success'){
      List data = response.data;
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    }else{
      throw ErrorHandler(message:response.message);
    }
  }

  Future<List<CategoryModel>> getAllCategories () async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    ApiListResponse response = await _handler.postList(UrlResources.all_categories,body: {
      'userid':user.id.toString()
    });

    if(response.status=='success'){
      List data = response.data;
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    }else{
      throw ErrorHandler(message:response.message);
    }
  }

}


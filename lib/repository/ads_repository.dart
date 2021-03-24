import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/models/area_model.dart';
import 'package:go_local_vendor/models/emirate_model.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/url_resources.dart';
import '../utils/api_response.dart';
import '../utils/api_handler.dart';

class AdsRepository {
  final ApiHandler _handler;

  AdsRepository(this._handler);

  Future<User> getVendor(String vendorId) async {
    ApiResponse response = await _handler.post(UrlResources.get_user, body: {'user_id': vendorId.toString()});

    if (response.status == 'success') {
      return User.fromJson(response.data);
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<List<AdModel>> search(String keyword, String type, id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));

    ApiListResponse response =
        await _handler.postList(UrlResources.search_ads, body: {
      'search': keyword,
      'type': type,
      'id': id.toString(),
      (user.userType.toLowerCase() == 'vendor' ? 'vendor_id' : 'user_id'):
          user.id.toString()
    });
    //

    if (response.status == 'success') {
      List data = response.data;
      return data.map((e) => AdModel.fromJson(e)).toList();
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<List<AdModel>> getAds(int page) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));

    ApiListResponse response =
        await _handler.postList(UrlResources.get_ads, body: {
      "page": page.toString(),
      user.userType.toLowerCase() == 'customer' ? 'user_id' : 'vendor_id':
          user.id.toString()
    });

    if (response.status == 'success') {
      print(response.data.toString());
      List data = response.data;
      return data.map((e) => AdModel.fromJson(e)).toList();
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<List<EmirateModel>> getEmirates() async {
    ApiListResponse response =
        await _handler.postList(UrlResources.get_emirates, body: {});

    if (response.status == 'success') {
      List data = response.data;
      return data.map((e) => EmirateModel.fromJson(e)).toList();
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<List<AreaModel>> getAreas(id) async {
    ApiListResponse response =
        await _handler.postList(UrlResources.getAreas(id.toString()), body: {});

    if (response.status == 'success') {
      List data = response.data;
      return data.map((e) => AreaModel.fromJson(e)).toList();
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future createAd(String categoryId, String type, String description,
      String title, area, List<File> images, List<String> _title) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    ApiResponse response = await _handler.postImage(UrlResources.create_ad,
        body: {
          'title': title,
          'description': description,
          'area_id': area.toString(),
          'type': type,
          'category_id': categoryId,
          'vendor_id': user.id.toString(),
        },
        images : images,
        title: _title,
    );
    if (response.status == 'success') {
      return response.message;
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future updateAd(String categoryId, String type, String description,
      String title,String adId,) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));

    ApiResponse response = await _handler.post(UrlResources.update_ad,
        body: {
          'title': title,
          'ad_id': adId,
          'description': description,
          'type': type,
          'categoriesId': categoryId,
          'vendor_id': user.id.toString(),
        },
    );
    if (response.status == 'success') {
      return "Ad Updated successfully";
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future updateAdImage(String adId,List<File> images,List<String> _title) async {
    print(images);
    print(_title);
     ApiResponse response = await _handler.postImage(UrlResources.update_ad_Image,
      body: {
        'adid': adId,
      },
      images : images,
      title: _title,
    );
    if (response.status == 'success') {
      return "Ad Updated successfully";
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<bool> deleteAd(int adId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    ApiResponse response = await _handler.post(UrlResources.delete_ad,
        body: {'ad_id': adId.toString(), 'vendor_id': user.id.toString()});

    if (response.status == 'success') {
      return true;
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<bool> deleteadsimages(int imageid) async {
    print(imageid);
    // ApiResponse response = await _handler.post(UrlResources.delete_ads_images,
    //     body: {'image_id ': imageid.toString()});
    // if (response.status == 'success') {
    //   print(response.message);
    //   return true;
    // } else {
    //   throw ErrorHandler(message: response.message);
    // }
  }

  Future<bool> addToFavourite(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    ApiResponse response = await _handler.post(UrlResources.add_to_favourite,
        body: {"ad_id": id.toString(), 'user_id': user.id.toString()});

    if (response.status == 'success') {
      return true;
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<List<AdModel>> getFavouriteAds(int page) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    ApiListResponse response = await _handler.postList(
        UrlResources.favourite_list,
        body: {"page": page.toString(), 'user_id': user.id.toString()});

    if (response.status == 'success') {
      print(response.data.toString());
      List data = response.data;
      return data.map((e) => AdModel.fromJson(e)).toList();
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<AdModel> getAd(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    Map<String, String> data = {
      "ad_id": id.toString()};
    if (user.userType.toLowerCase() == 'vendor') {
      data['user_id'] = user.id.toString();
    }

    ApiResponse response = await _handler.post(UrlResources.get_ad, body: data);
    if (response.status == 'success') {
      if (response.data != null) {
        print(response.data.toString());
        return AdModel.fromJson(response.data);
      }
      throw ErrorHandler(message: "Couldn't get ad");
    } else {
      throw ErrorHandler(message: response.message);
    }
  }

  Future<List<AdModel>> getAdsWithCategory(int categoryId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));

    ApiListResponse response =
        await _handler.postList(UrlResources.get_ads_by_category, body: {
      "category_id": categoryId.toString(),
      (user.userType.toLowerCase() == 'vendor' ? 'vendor_id' : 'user_id'):
          user.id.toString()
    });
    if (response.status == 'success') {
      List data = response.data;
      return data.map((e) => AdModel.fromJson(e)).toList();
    } else {
      throw ErrorHandler(message: response.message);
    }
  }
}

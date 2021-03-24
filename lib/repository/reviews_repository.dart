import 'dart:convert';
import 'package:go_local_vendor/models/review_model.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/url_resources.dart';
import '../utils/api_response.dart';
import '../utils/api_handler.dart';

class ReviewsRepository{
  final ApiHandler _handler;

  ReviewsRepository(this._handler);

  Future<List<ReviewModel>> getReviews (int page,int adid) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    ApiListResponse response = await _handler.postList(UrlResources.reviews,body: {
      "page":page.toString(),
      "ad_id":adid.toString(),
      'user_id':user.id.toString()
    });

    if(response.status=='success'){
      List data = response.data;
      return data.map((e) => ReviewModel.fromJson(e)).toList();
    }else{
      throw ErrorHandler(message:response.message);
    }
  }

  Future<String> newReview (int adid,String review,String rating) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(preferences.getString("USER")));
    ApiResponse response = await _handler.post(UrlResources.review,body: {
      "rating":rating,
      "ad_id":adid.toString(),
      "review":review,
      'user_id':user.id.toString()
    });

    if(response.status=='success'){
      return response.message;
    }else{
      throw ErrorHandler(message:response.message);
    }
  }
}


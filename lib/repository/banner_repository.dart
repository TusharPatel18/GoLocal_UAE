

import 'package:go_local_vendor/models/banner.dart';
import 'package:go_local_vendor/utils/error_handler.dart';

import '../resources/url_resources.dart';
import '../utils/api_response.dart';
import '../utils/api_handler.dart';

class BannerRepository{
  final ApiHandler _handler;

  BannerRepository(this._handler);

  Future<List<BannerModel>> getBanners () async {

    ApiListResponse response = await _handler.postList(UrlResources.banners);

    if(response.status=='success'){
      List data = response.data;
      return data.map((e) => BannerModel.fromJson(e)).toList();
    }else{
      throw ErrorHandler(message:response.message);
    }
  }

}


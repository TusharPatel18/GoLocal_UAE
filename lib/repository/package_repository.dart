import 'package:go_local_vendor/models/package_model.dart';
import 'package:go_local_vendor/resources/url_resources.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/api_response.dart';
import 'package:go_local_vendor/utils/error_handler.dart';

class PackageRepository{
   final ApiHandler _handler;

  PackageRepository(this._handler);

  getPackages() async {
    ApiListResponse response = await _handler.postList(UrlResources.getPackages,);

    if(response.status=='success'){
      List data = response.data;
      return data.map((e) => PackageModel.fromJson(e)).toList();
    }else{
      throw ErrorHandler(message:response.message);
    }
  }
}
import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'ads_with_category_state.dart';

class AdsWithCategoryCubit extends Cubit<AdsWithCategoryState> {
  AdsRepository repository = AdsRepository(ApiHandler(http.Client()));
  AdsWithCategoryCubit() : super(AdsWithCategoryInitial());

  getAdsWithCategory(categoryId) async {
    emit(AdsWithCategoryLoading());
    try {
      List<AdModel> ads = await repository.getAdsWithCategory(int.parse(categoryId.toString()));
      emit(AdsWithCategoryLoaded(ads));
    } on ErrorHandler catch (ex) {
      emit(AdsWithCategoryError(ex.getMessage()));
    }
  }
}

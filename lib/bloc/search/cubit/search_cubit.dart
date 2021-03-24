import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  AdsRepository repository = AdsRepository(ApiHandler(http.Client()));
  SearchCubit() : super(SearchInitial());

  searchAd(String search, String type, id) async {
    emit(Searching());
   
    if (search.length >= 3) {
      try {
        List<AdModel> ads = await repository.search(search, type, id);
        emit(SearchLoaded(ads));
      } on ErrorHandler catch (ex) {
        emit(SearchError(ex.getMessage()));
      }
    }
    if (search.length == 0) {
      emit(SearchInitial());
    }
  }
}

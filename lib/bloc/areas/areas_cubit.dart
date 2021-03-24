import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/area_model.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'areas_state.dart';

class AreasCubit extends Cubit<AreasState> {
  AdsRepository repository = AdsRepository(ApiHandler(http.Client()));
  AreasCubit() : super(AreasInitial());

  getAreas(id) async {
    emit(AreasLoading());
    try {
      List<AreaModel> areas = await repository.getAreas(id);
      emit(AreasLoaded(areas));
    } on ErrorHandler catch (ex) {
      emit(AreasError(ex.toString()));
    }
  }
}

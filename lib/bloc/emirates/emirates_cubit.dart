import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/emirate_model.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'emirates_state.dart';

class EmiratesCubit extends Cubit<EmiratesState> {
  AdsRepository repository = AdsRepository(ApiHandler(http.Client()));
  EmiratesCubit() : super(EmiratesInitial());

  getEmirates() async {
    emit(EmiratesLoading());
    try {
      List<EmirateModel> emirates = await repository.getEmirates();
      emit(EmiratesLoaded(emirates));
    } on ErrorHandler catch (ex) {
    
      emit(EmiratesError(ex.getMessage()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'vendor_state.dart';

class VendorCubit extends Cubit<VendorState> {
  AdsRepository repository = AdsRepository(ApiHandler(http.Client()));
  VendorCubit() : super(VendorInitial());

  getVendor(vendorId) async {
    emit(VendorLoading());
    try {
      User user = await repository.getVendor(vendorId);
      print(user.id);
      emit(VendorLoaded(user));
    } on ErrorHandler catch (ex) {
      emit(VendorError(ex.getMessage()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/repository/user_repository.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  UserRepository repository = UserRepository(ApiHandler(http.Client()));
  OtpCubit() : super(OtpInitial());

  verifyOtp(String otp) async {
    emit(OtpVerifying());
    try {
      await repository.verifyOtp(otp);
      emit(OtpVerified());
    } on ErrorHandler catch (ex) {
      emit(OtpError(ex.getMessage()));
    }
  }
}

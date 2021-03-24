import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:device_info/device_info.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';
import '../../repository/user_repository.dart';
import 'dart:io' show Platform;
part 'login_screen_event.dart';
part 'login_screen_state.dart';

class LoginScreenBloc extends Bloc<LoginScreenEvent, LoginScreenState> {
  final UserRepository _repository;
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  LoginScreenBloc(this._repository) : super(LoginScreenInitial());

  @override
  Stream<LoginScreenState> mapEventToState(LoginScreenEvent event,) async* {
    try {
      if (event is Login) {
        yield LoggingIn();
        await _repository.login(
          deviceToken: Platform.isAndroid
              ? (await deviceInfoPlugin.androidInfo).androidId
              : (await deviceInfoPlugin.iosInfo).identifierForVendor,
          password: event.password,
          email: event.emailId,
        );
        yield LoginSuccess();
      }
    } on ErrorHandler catch (ex) {
      yield LoginFailed(ex.getMessage());
    }
  }
}

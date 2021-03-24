import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info/device_info.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';
import '../../repository/user_repository.dart';
part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  final UserRepository _repository;

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  RegistrationBloc(this._repository) : super(RegistrationInitial());

  @override
  Stream<RegistrationState> mapEventToState(
    RegistrationEvent event,
  ) async* {
    try {
      if (event is Register) {
        yield Registering();
        String message = await _repository.register(
            deviceToken: Platform.isAndroid
                ? (await deviceInfoPlugin.androidInfo).androidId
                : (await deviceInfoPlugin.iosInfo).identifierForVendor,
            password: event.password,
            email: event.email,
            usertype: event.userType,
            firstName: event.firstName,
            lastName: event.lastName,
            mobileNumber: event.mobileNumber);
        yield RegistrationSuccess(message);
      }
    } on ErrorHandler catch (ex) {
      yield RegistrationFailed(ex.getMessage());
    }
  }
}

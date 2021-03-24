import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/user.dart';
import 'package:go_local_vendor/repository/user_repository.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;
  UserBloc(this._repository) : super(UserInitial());

  @override
  Stream<UserState> mapEventToState(
    UserEvent event,
  ) async* {
    try{
      if(event is GetUser){
        User user = await _repository.getUser();
        yield UserLoaded(user);
      }
      if(event is GetUserNew){
        User user = await _repository.getUserNew();
        yield UserLoaded(user);
      }
      if(event is DeactivateUser){
        await _repository.deactivateUser();
        yield UserDeactivated();
      }
      if(event is UpdateUser){
        await _repository.updateUser(
          firstName: event.firstName,
          lastName: event.lastName,
          password: event.password,
          facebook:event.facebook,
          twitter:event.twitter,
          instagram:event.instagram,
          address:event.address,
        );
        yield UserUpdated();
        User user = await _repository.getUserNew();
        yield UserLoaded(user);
      }
      if(event is UpdateUser1){
        await _repository.updateUser1(
          firstName: event.firstName,
          lastName: event.lastName,
          password: event.password,
          facebook:event.fb,
          twitter:event.twitter,
          instagram:event.insta,
          address:event.address,
          images:event.Images,
        );
        yield UserUpdated();
        User user = await _repository.getUserNew();
        yield UserLoaded(user);
      }
    }
    on ErrorHandler catch(ex){
      yield UserError(ex.getMessage());
    }
  }
}

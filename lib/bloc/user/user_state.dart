part of 'user_bloc.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}
class UpdatingUser extends UserState {}
class UserUpdated extends UserState {}
class UserDeactivated extends UserState {}
class UserLoaded extends UserState {
  final User user;

  UserLoaded(this.user);
}
class UserError extends UserState {
  final String message;

  UserError(this.message);
}

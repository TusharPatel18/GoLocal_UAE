part of 'login_screen_bloc.dart';

@immutable
abstract class LoginScreenState {}

class LoginScreenInitial extends LoginScreenState {}
class LoggingIn extends LoginScreenState {}
class LoginSuccess extends LoginScreenState {}
class LoginFailed extends LoginScreenState {
  final String message;

  LoginFailed(this.message);
}

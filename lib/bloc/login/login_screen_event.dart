part of 'login_screen_bloc.dart';

@immutable
abstract class LoginScreenEvent {}

class Login extends LoginScreenEvent{
  final String emailId;
  final String password;

  Login(this.emailId, this.password);

}
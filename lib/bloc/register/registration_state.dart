part of 'registration_bloc.dart';

@immutable
abstract class RegistrationState {}

class RegistrationInitial extends RegistrationState {}
class Registering extends RegistrationState {}
class RegistrationSuccess extends RegistrationState {
  final String message;

  RegistrationSuccess(this.message);
}
class RegistrationFailed extends RegistrationState {
  final String message;

  RegistrationFailed(this.message);
}

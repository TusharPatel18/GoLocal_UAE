part of 'registration_bloc.dart';

@immutable
abstract class RegistrationEvent {}

class Register extends RegistrationEvent {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String email;
  final String password;
  final String userType;

  Register(this.firstName, this.lastName, this.mobileNumber, this.email,
      this.password,this.userType);
}

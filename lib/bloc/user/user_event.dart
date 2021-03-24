part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

class GetUser extends UserEvent {}

class GetUserNew extends UserEvent {}

class DeactivateUser extends UserEvent {}

class UpdateUser extends UserEvent {
  final String firstName;
  final String lastName;
  final String password;
  final String facebook;
  final String instagram;
  final String twitter;
  final String address;

  UpdateUser(this.firstName, this.lastName, this.password, this.facebook,
      this.instagram, this.twitter,this.address);
}
class UpdateUser1 extends UserEvent {
  final String firstName;
  final String lastName;
  final String password;
  final String fb;
  final String insta;
  final String twitter;
  final String address;
  final File Images;

  UpdateUser1(this.firstName, this.lastName, this.password, this.fb,
      this.insta, this.twitter,this.address,this.Images);
}
class UpdateUser2 extends UserEvent {
  final String firstName;
  final String lastName;
  final String password;
  final String fb;
  final String insta;
  final String twitter;
  final String address;
  final String Images;

  UpdateUser2(this.firstName, this.lastName, this.password, this.fb,
      this.insta, this.twitter,this.address,this.Images);
}

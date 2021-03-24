part of 'vendor_cubit.dart';

@immutable
abstract class VendorState {}

class VendorInitial extends VendorState {}

class VendorLoading extends VendorState {}

class VendorLoaded extends VendorState {
  final User user;

  VendorLoaded(this.user);
}

class VendorError extends VendorState {
  final String message;

  VendorError(this.message);
}

part of 'package_cubit.dart';

@immutable
abstract class PackageState {}

class PackageInitial extends PackageState {}

class PackageLoading extends PackageState {}

class PackageLoaded extends PackageState {
  final List<PackageModel> packages;

  PackageLoaded(this.packages);
}

class PackageError extends PackageState {
  final String message;

  PackageError(this.message);
}

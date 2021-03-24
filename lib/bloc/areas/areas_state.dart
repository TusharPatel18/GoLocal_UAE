part of 'areas_cubit.dart';

@immutable
abstract class AreasState {}

class AreasInitial extends AreasState {}

class AreasLoading extends AreasState {}

class AreasLoaded extends AreasState {
  final List<AreaModel> areas;

  AreasLoaded(this.areas);
}

class AreasError extends AreasState {
  final String message;

  AreasError(this.message);
}

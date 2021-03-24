part of 'ad_bloc.dart';

@immutable
abstract class AdState {}

class AdInitial extends AdState {}

class AdLoaded extends AdState{
  final AdModel adModel;

  AdLoaded(this.adModel);
}
class AdError extends AdState{
  final String message;

  AdError(this.message);
}
part of 'favourite_bloc.dart';

@immutable
abstract class FavouriteState {}

class FavouriteInitial extends FavouriteState {}
class Favourited extends FavouriteState {}
class FavouriteError extends FavouriteState {
  final String message;

  FavouriteError(this.message);
}

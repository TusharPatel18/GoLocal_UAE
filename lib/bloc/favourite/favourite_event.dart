part of 'favourite_bloc.dart';

@immutable
abstract class FavouriteEvent {}

class AddToFavourite extends FavouriteEvent{
  final int id;

  AddToFavourite(this.id);
}
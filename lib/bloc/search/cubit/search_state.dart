part of 'search_cubit.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class Searching extends SearchState {}

class SearchLoaded extends SearchState {
  final List<AdModel> ads;

  SearchLoaded(this.ads);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}

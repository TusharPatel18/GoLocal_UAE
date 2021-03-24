part of 'ads_bloc.dart';

@immutable
abstract class AdsState {}

class AdsInitial extends AdsState {}
class AdsLoading extends AdsState {
  final List<AdModel> ads;

  AdsLoading(this.ads);
}
class AdsLoaded extends AdsState {
  final List<AdModel> ads;
  final int page;

  AdsLoaded(this.ads, this.page);
}
class AdsError extends AdsState {
  final String message;

  AdsError(this.message);
}

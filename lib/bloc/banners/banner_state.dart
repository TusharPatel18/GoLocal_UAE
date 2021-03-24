part of 'banner_bloc.dart';

@immutable
abstract class BannerState {}

class BannerInitial extends BannerState {}
class BannersLoaded extends BannerState {
  final List<BannerModel> banners;

  BannersLoaded(this.banners);
}
class BannerError extends BannerState {
  final String message;

  BannerError(this.message);
}

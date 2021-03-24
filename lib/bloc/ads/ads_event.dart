part of 'ads_bloc.dart';

@immutable
abstract class AdsEvent {}
class GetAds extends AdsEvent{
  final int page;
  final List<AdModel> ads;

  GetAds(this.page, {this.ads:const []});
}

class GetFavouriteAds extends AdsEvent{
  final int page;
  final List<AdModel> ads;

  GetFavouriteAds(this.page, {this.ads:const []});
}

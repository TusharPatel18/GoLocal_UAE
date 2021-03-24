import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';

part 'ads_event.dart';
part 'ads_state.dart';

class AdsBloc extends Bloc<AdsEvent, AdsState> {
  final AdsRepository _repository;
  AdsBloc(this._repository) : super(AdsInitial());

  @override
  Stream<AdsState> mapEventToState(
    AdsEvent event,
  ) async* {
    try{
      if(event is GetAds){

        if(event.ads.length>0){
          yield AdsLoading(event.ads);
        }
        List<AdModel> categories = await _repository.getAds(event.page);
        yield AdsLoaded(categories, event.page??0);
      }
      if(event is GetFavouriteAds){

        if(event.ads.length>0){
          yield AdsLoading(event.ads);
        }
        List<AdModel> categories = await _repository.getFavouriteAds(event.page);
        yield AdsLoaded(categories, event.page??0);
      }

    }on ErrorHandler catch(ex){
      yield AdsError(ex.getMessage());
    }
  }
}

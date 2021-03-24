import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/banner.dart';
import 'package:go_local_vendor/repository/banner_repository.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository _repository;

  BannerBloc(this._repository) : super(BannerInitial());

  @override
  Stream<BannerState> mapEventToState(
    BannerEvent event,
  ) async* {
    try{
     if(event is GetBanners){
       List<BannerModel> banners = await _repository.getBanners();
       yield BannersLoaded(banners);
     }
    }on ErrorHandler catch(ex){
      yield BannerError(ex.getMessage());
    }
  }
}

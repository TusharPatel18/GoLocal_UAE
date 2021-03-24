import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/ad_model.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';

part 'ad_event.dart';
part 'ad_state.dart';

class AdBloc extends Bloc<AdEvent, AdState> {
  final AdsRepository repository;

  AdBloc(this.repository) : super(AdInitial());

  @override
  Stream<AdState> mapEventToState(
    AdEvent event,
  ) async* {
   try{
     if(event is GetAd){
       AdModel ad= await repository.getAd(event.id);
       yield AdLoaded(ad);
     }
   }on ErrorHandler catch(ex){
     yield AdError(ex.getMessage());
   }
  }
}

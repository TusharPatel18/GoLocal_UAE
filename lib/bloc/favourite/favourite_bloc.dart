import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/repository/ads_repository.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';

part 'favourite_event.dart';
part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavouriteEvent, FavouriteState> {
  final AdsRepository repository;

  FavouriteBloc(this.repository) : super(FavouriteInitial());

  @override
  Stream<FavouriteState> mapEventToState(
    FavouriteEvent event,
  ) async* {
    try{
      if(event is AddToFavourite){
        await repository.addToFavourite(event.id);
        yield Favourited();
      }
    }on ErrorHandler catch(ex){
      yield FavouriteError(ex.getMessage());
    }
  }
}

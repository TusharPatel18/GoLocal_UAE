import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/review_model.dart';
import 'package:go_local_vendor/repository/reviews_repository.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewsRepository _repository;

  ReviewBloc(this._repository) : super(ReviewInitial());

  @override
  Stream<ReviewState> mapEventToState(
    ReviewEvent event,
  ) async* {
    try{
      if(event is NewReview){
        yield AddingReview();
        await _repository.newReview(event.id, event.review, event.rating.toString());
        yield ReviewAdded();
      }
      if(event is GetReview){
        List<ReviewModel> reviews = await _repository.getReviews(event.page, event.id);
        yield ReviewsLoaded(reviews);
      }
    }on ErrorHandler catch(ex){
      yield ReviewError(ex.getMessage());
    }
  }
}

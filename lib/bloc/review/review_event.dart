part of 'review_bloc.dart';

@immutable
abstract class ReviewEvent {}

class GetReview extends ReviewEvent{
  final int id;
  final int page;

  GetReview(this.id, this.page);
}

class NewReview extends ReviewEvent{
  final int id;
  final String review;
  final String rating;

  NewReview(this.id, this.review, this.rating);
}
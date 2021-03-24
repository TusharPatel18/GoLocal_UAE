part of 'review_bloc.dart';

@immutable
abstract class ReviewState {}

class ReviewInitial extends ReviewState {}
class AddingReview extends ReviewState {}
class ReviewAdded extends ReviewState {}
class ReviewsLoaded extends ReviewState {
  final List<ReviewModel> reviews;

  ReviewsLoaded(this.reviews);
}

class ReviewError extends ReviewState {
  final String message;

  ReviewError(this.message);
}


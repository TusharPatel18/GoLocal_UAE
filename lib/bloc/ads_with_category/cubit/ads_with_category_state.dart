part of 'ads_with_category_cubit.dart';

@immutable
abstract class AdsWithCategoryState {}

class AdsWithCategoryInitial extends AdsWithCategoryState {}

class AdsWithCategoryLoading extends AdsWithCategoryState {}

class AdsWithCategoryLoaded extends AdsWithCategoryState {
  final List<AdModel> ads;

  AdsWithCategoryLoaded(this.ads);
}

class AdsWithCategoryError extends AdsWithCategoryState {
  final String message;

  AdsWithCategoryError(this.message);
}

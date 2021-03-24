part of 'category_bloc.dart';

@immutable
abstract class CategoryState {}

class CategoryInitial extends CategoryState {}
class CategoriesLoading extends CategoryState {
  final List<CategoryModel> categories;

  CategoriesLoading(this.categories);
}
class CategoriesLoaded extends CategoryState {
  final int page;
  final List<CategoryModel> categories;

  CategoriesLoaded(this.categories, this.page);
}
class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}

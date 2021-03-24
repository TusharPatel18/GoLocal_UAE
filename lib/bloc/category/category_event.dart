part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent {}

class GetCategories extends CategoryEvent{
  final int page;
  final List<CategoryModel> categories;

  GetCategories(this.page,{ this.categories:const []});
}
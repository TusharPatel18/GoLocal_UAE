import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/category_model.dart';
import 'package:go_local_vendor/repository/category_repository.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _repository;

  CategoryBloc(this._repository) : super(CategoryInitial());

  @override
  Stream<CategoryState> mapEventToState(
    CategoryEvent event,
  ) async* {
    try{
      if(event is GetCategories){

        if(event.categories.length>0){
          yield CategoriesLoading(event.categories);
        }
        List<CategoryModel> categories = await _repository.getCategories(event.page);
        yield CategoriesLoaded(categories, event.page??0);
      }
    }on ErrorHandler catch(ex){
      yield CategoryError(ex.getMessage());
    }
  }
}

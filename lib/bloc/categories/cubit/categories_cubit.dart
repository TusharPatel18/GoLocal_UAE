import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/category_model.dart';
import 'package:go_local_vendor/repository/category_repository.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:go_local_vendor/utils/error_handler.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  getAllCategories() async {
    emit(CategoriesLoading());
    try {
      List<CategoryModel> categories =
          await CategoryRepository(ApiHandler(http.Client()))
              .getAllCategories();
      emit(CategoriesLoaded(
        categories,
      ));
    } on ErrorHandler catch (ex) {
      emit(CategoriesError(ex.getMessage()));
    }
  }
}

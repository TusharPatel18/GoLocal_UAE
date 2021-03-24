import 'package:bloc/bloc.dart';
import 'package:go_local_vendor/models/package_model.dart';
import 'package:go_local_vendor/repository/package_repository.dart';
import 'package:go_local_vendor/utils/api_handler.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'package_state.dart';

class PackageCubit extends Cubit<PackageState> {
  final PackageRepository packageRepository =
      PackageRepository(ApiHandler(http.Client()));

  PackageCubit() : super(PackageInitial());

  getPackages() async {
    emit(PackageLoading());
    try {
      List<PackageModel> packages = await packageRepository.getPackages();
      emit(PackageLoaded(packages));
    } on Exception catch (ex) {
      emit(PackageError(ex.toString()));
    }
  }
}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'create_ad_state.dart';

class CreateAdCubit extends Cubit<CreateAdState> {
  CreateAdCubit() : super(CreateAdInitial());
}

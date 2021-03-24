import 'dart:async';
import 'package:bloc/bloc.dart';

enum PasswordToggleEvent{
  SHOW,HIDE
}
class PasswordToggleBloc extends Bloc<PasswordToggleEvent, bool> {
  PasswordToggleBloc() : super(true);


  @override
  Stream<bool> mapEventToState(PasswordToggleEvent event) async* {
    switch (event) {
      case PasswordToggleEvent.SHOW:
        yield true;
        break;
      case PasswordToggleEvent.HIDE:
        yield false;
        break;
    }
  }
}

part of 'emirates_cubit.dart';

@immutable
abstract class EmiratesState {}

class EmiratesInitial extends EmiratesState {}

class EmiratesLoading extends EmiratesState {}

class EmiratesLoaded extends EmiratesState {
  final List<EmirateModel> emirates;

  EmiratesLoaded(this.emirates);
}

class EmiratesError extends EmiratesState {
  final String message;

  EmiratesError(this.message);
}

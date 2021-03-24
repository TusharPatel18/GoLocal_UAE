part of 'ad_bloc.dart';

@immutable
abstract class AdEvent {}

class GetAd extends AdEvent{
  final int id;

  GetAd(this.id);
}
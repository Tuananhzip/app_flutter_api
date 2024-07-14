part of 'detail_bloc.dart';

@immutable
sealed class DetailEvent {}

class GetDetailEvent extends DetailEvent {}

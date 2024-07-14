part of 'detail_bloc.dart';

@immutable
sealed class DetailState {}

final class DetailInitial extends DetailState {}

final class DetailLoading extends DetailState {}

final class DetailSuccess extends DetailState {
  final User user;

  DetailSuccess({required this.user});
}

final class DetailFailure extends DetailState {
  final String message;

  DetailFailure({required this.message});
}

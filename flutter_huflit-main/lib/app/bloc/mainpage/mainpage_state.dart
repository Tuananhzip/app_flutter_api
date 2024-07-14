part of 'mainpage_bloc.dart';

@immutable
sealed class MainpageState {}

final class MainpageInitial extends MainpageState {}

final class MainpageLoading extends MainpageState {}

final class MainpageSuccess extends MainpageState {
  final User user;
  final int itemCountCart;

  MainpageSuccess({required this.user, required this.itemCountCart});
}

final class MainpageFailure extends MainpageState {
  final String message;
  MainpageFailure(this.message);
}

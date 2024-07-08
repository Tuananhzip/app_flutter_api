part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

class LoginInitial extends LoginState {
  final bool isVisible;

  LoginInitial({this.isVisible = false});
}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String error;

  LoginFailure({required this.error});
}

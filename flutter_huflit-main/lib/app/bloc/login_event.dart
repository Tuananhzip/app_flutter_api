part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final String account;
  final String password;

  LoginSubmitted(this.account, this.password);
}

class AppStarted extends LoginEvent {}

class TogglePasswordVisibility extends LoginEvent {}

part of 'mainpage_bloc.dart';

@immutable
sealed class MainpageEvent {}

class LoadUserEvent extends MainpageEvent {}

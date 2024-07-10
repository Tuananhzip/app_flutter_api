part of 'register_bloc.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final String message;
  RegisterSuccess(this.message);
}

final class RegisterFailure extends RegisterState {
  final String message;
  RegisterFailure(this.message);
}

class ValidateAccountId extends RegisterState {
  final String message;
  ValidateAccountId(this.message);
}

class ValidatePassword extends RegisterState {
  final String message;
  ValidatePassword(this.message);
}

class ValidateConfirmPassword extends RegisterState {
  final String message;
  ValidateConfirmPassword(this.message);
}

class ValidateFullName extends RegisterState {
  final String message;
  ValidateFullName(this.message);
}

class ValidateNumberId extends RegisterState {
  final String message;
  ValidateNumberId(this.message);
}

class ValidatePhoneNumber extends RegisterState {
  final String message;
  ValidatePhoneNumber(this.message);
}

class ValidateGender extends RegisterState {
  final String message;
  ValidateGender(this.message);
}

class ValidateBirthDay extends RegisterState {
  final String message;
  ValidateBirthDay(this.message);
}

class ValidateSchoolYear extends RegisterState {
  final String message;
  ValidateSchoolYear(this.message);
}

class ValidateSchoolKey extends RegisterState {
  final String message;
  ValidateSchoolKey(this.message);
}

class ValidateSuccess extends RegisterState {}

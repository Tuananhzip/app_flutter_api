part of 'register_bloc.dart';

@immutable
sealed class RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String accountID;
  final String password;
  final String confirmPassword;
  final String fullName;
  final String numberId;
  final String phoneNumber;
  final String gender;
  final String birthDay;
  final String schoolYear;
  final String schoolKey;
  final String? imageUrl;
  RegisterSubmitted({
    required this.accountID,
    required this.password,
    required this.confirmPassword,
    required this.fullName,
    required this.numberId,
    required this.phoneNumber,
    required this.gender,
    required this.birthDay,
    required this.schoolYear,
    required this.schoolKey,
    this.imageUrl,
  });
}

class AccountIdChanged extends RegisterEvent {
  final String accountID;
  AccountIdChanged({required this.accountID});
}

class PasswordChanged extends RegisterEvent {
  final String password;
  PasswordChanged({required this.password});
}

class ConfirmPasswordChanged extends RegisterEvent {
  final String password;
  final String confirmPassword;

  ConfirmPasswordChanged(
      {required this.password, required this.confirmPassword});
}

class FullNameChanged extends RegisterEvent {
  final String fullName;
  FullNameChanged({required this.fullName});
}

class NumberIdChanged extends RegisterEvent {
  final String numberId;
  NumberIdChanged({required this.numberId});
}

class PhoneNumberChanged extends RegisterEvent {
  final String phoneNumber;
  PhoneNumberChanged({required this.phoneNumber});
}

class GenderChanged extends RegisterEvent {
  final String gender;
  GenderChanged({required this.gender});
}

class BirthDayChanged extends RegisterEvent {
  final String birthDay;
  BirthDayChanged({required this.birthDay});
}

class SchoolYearChanged extends RegisterEvent {
  final String schoolYear;
  SchoolYearChanged({required this.schoolYear});
}

class SchoolKeyChanged extends RegisterEvent {
  final String schoolKey;
  SchoolKeyChanged({required this.schoolKey});
}

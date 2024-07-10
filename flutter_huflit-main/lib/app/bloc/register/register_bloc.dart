import 'dart:math';

import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/register.dart';
import 'package:bloc/bloc.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitted>(_registerSubmitted);
    on<AccountIdChanged>(_validateAccountId);
    on<PasswordChanged>(_validatePassword);
    on<ConfirmPasswordChanged>(_validateConfirmPassword);
    on<FullNameChanged>(_validateFullName);
    on<NumberIdChanged>(_validateNumberId);
    on<PhoneNumberChanged>(_validatePhoneNumber);
    on<GenderChanged>(_validateGender);
    on<BirthDayChanged>(_validateBirthDay);
    on<SchoolYearChanged>(_validateSchoolYear);
    on<SchoolKeyChanged>(_validateSchoolKey);
  }
  void _registerSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    try {
      if (_isNullRegister(event) || !_isValids(state)) {
        Logger().e(
            '_isNullRegister || !_isValids======================================> $state');
        emit(RegisterFailure('Please check your inputs again'));
        return;
      }

      // If all validations pass, emit loading state
      emit(RegisterLoading());

      final Signup signupData = Signup(
        accountID: event.accountID,
        numberID: event.numberId,
        password: event.password,
        confirmPassword: event.confirmPassword,
        fullName: event.fullName,
        phoneNumber: event.phoneNumber,
        gender: event.gender,
        birthDay: event.birthDay,
        schoolKey: event.schoolKey,
        schoolYear: event.schoolYear,
        imageUrl: event.imageUrl,
      );
      final String response = await APIRepository().register(signupData);
      if (response == "exists") {
        emit(RegisterFailure('Account ID already exists.'));
        return;
      }
      if (response == "ok") {
        emit(RegisterSuccess('Registration successful.'));
      } else {
        emit(RegisterFailure('Registration failed.'));
      }
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }

  bool _isNullRegister(RegisterSubmitted event) {
    return event.accountID.isEmpty ||
        event.password.isEmpty ||
        event.confirmPassword.isEmpty ||
        event.fullName.isEmpty ||
        event.numberId.isEmpty ||
        event.phoneNumber.isEmpty ||
        event.gender.isEmpty ||
        event.birthDay.isEmpty ||
        event.schoolYear.isEmpty ||
        event.schoolKey.isEmpty;
  }

  bool _isValids(RegisterState state) {
    return !(state is ValidateAccountId ||
        state is ValidatePassword ||
        state is ValidateConfirmPassword ||
        state is ValidateFullName ||
        state is ValidateNumberId ||
        state is ValidatePhoneNumber ||
        state is ValidateGender ||
        state is ValidateBirthDay ||
        state is ValidateSchoolYear ||
        state is ValidateSchoolKey);
  }

  void _validateAccountId(
    AccountIdChanged event,
    Emitter<RegisterState> emit,
  ) {
    if (event.accountID.isEmpty) {
      emit(ValidateAccountId('Account ID is required.'));
      return;
    }
    if (!RegExp(r'^\d{2}DH\d{6}$').hasMatch(event.accountID)) {
      emit(ValidateAccountId(
          'Account ID must be in the format: xxDHxxxxxx (Example: 21DH113456).'));
      return;
    }
    emit(ValidateSuccess());
  }

  void _validatePassword(
    PasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    if (event.password.isEmpty) {
      emit(ValidatePassword('Password is required.'));
      return;
    }
    if (event.password.length < 6) {
      emit(ValidatePassword('Password must be at least 6 characters.'));
      return;
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(event.password)) {
      emit(ValidatePassword(
          'Password must contain at least one uppercase letter.'));
      return;
    }
    if (!RegExp(r'(?=.*[a-z])').hasMatch(event.password)) {
      emit(ValidatePassword(
          'Password must contain at least one lowercase letter.'));
      return;
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(event.password)) {
      emit(ValidatePassword('Password must contain at least one number.'));
      return;
    }
    if (!RegExp(r'(?=.*[!@#$%^&*(),.?":{}|<>])').hasMatch(event.password)) {
      emit(ValidatePassword(
          'Password must contain at least one special character.'));
      return;
    }
    emit(ValidateSuccess());
  }

  void _validateConfirmPassword(
    ConfirmPasswordChanged event,
    Emitter<RegisterState> emit,
  ) {
    if (event.confirmPassword.isEmpty) {
      emit(ValidateConfirmPassword('Confirm password is required.'));
      return;
    }
    if (event.password != event.confirmPassword) {
      emit(ValidateConfirmPassword('Passwords do not match.'));
      return;
    }
    emit(ValidateSuccess());
  }

  void _validateFullName(
    FullNameChanged event,
    Emitter<RegisterState> emit,
  ) {
    if (event.fullName.isEmpty) {
      emit(ValidateFullName('Full name is required.'));
      return;
    }
    emit(ValidateSuccess());
  }

  void _validateNumberId(
    NumberIdChanged event,
    Emitter<RegisterState> emit,
  ) {
    if (event.numberId.isEmpty) {
      emit(ValidateNumberId('Number ID is required.'));
      return;
    }
    emit(ValidateSuccess());
  }

  void _validatePhoneNumber(
    PhoneNumberChanged event,
    Emitter<RegisterState> emit,
  ) {
    if (event.phoneNumber.isEmpty) {
      emit(ValidatePhoneNumber('Phone number is required.'));
      return;
    }
    if (!RegExp(r'^0\d{9}$').hasMatch(event.phoneNumber)) {
      emit(ValidatePhoneNumber(
          'Phone number must be in the format: 0xxxxxxxxx (Example: 0912345678).'));
      return;
    }
    emit(ValidateSuccess());
  }

  void _validateGender(GenderChanged event, Emitter<RegisterState> emit) {
    if (event.gender.isEmpty) {
      emit(ValidateGender('Gender is required.'));
      return;
    }
    emit(ValidateSuccess());
  }

  void _validateBirthDay(BirthDayChanged event, Emitter<RegisterState> emit) {
    if (event.birthDay.isEmpty) {
      emit(ValidateBirthDay('Birthday is required.'));
      return;
    } else if (!RegExp(r'^(0[1-9]|[12][0-9]|3[01])/(0[1-9]|1[0-2])/([0-9]{4})$')
        .hasMatch(event.birthDay)) {
      emit(ValidateBirthDay(
          'Birthday must be in the correct format: dd/MM/yyyy (Example: 23/08/2003).'));
      return;
    }
    emit(ValidateSuccess());
  }

  void _validateSchoolYear(
      SchoolYearChanged event, Emitter<RegisterState> emit) {
    if (event.schoolYear.isEmpty) {
      emit(ValidateSchoolYear('School year is required.'));
      return;
    }
    if (!RegExp(r'^\d{4}-\d{4}$').hasMatch(event.schoolYear)) {
      emit(ValidateSchoolYear(
          'School year must be in the format: xxxx-xxxx (Example: 2021-2025).'));
      return;
    }
    final years = event.schoolYear.split('-');
    final startYear = int.tryParse(years[0]);
    final endYear = int.tryParse(years[1]);
    if (startYear == null || endYear == null || startYear > endYear) {
      emit(ValidateSchoolYear(
          'The start year must be less than or equal to the end year.'));
      return;
    }
    emit(ValidateSuccess());
  }

  void _validateSchoolKey(SchoolKeyChanged event, Emitter<RegisterState> emit) {
    if (event.schoolKey.isEmpty) {
      emit(ValidateSchoolKey('School key is required.'));
      return;
    }
    if (!RegExp(r'^K').hasMatch(event.schoolKey)) {
      emit(ValidateSchoolKey('School key must start with Kxx (Example: K27).'));
      return;
    }
    emit(ValidateSuccess());
  }
}

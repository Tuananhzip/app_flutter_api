import 'dart:convert';

import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/data/sharepre.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_api/app/model/user.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  bool _isPasswordVisible = false;
  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
    on<TogglePasswordVisibility>(_onTogglePasswordVisibility);
    on<AppStarted>(_onAutoLogin);
  }
  void _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (event.account.isEmpty ||
        event.password.isEmpty ||
        event.account == '' ||
        event.password == '') {
      emit(LoginFailure(error: 'Vui lòng nhập đầy đủ thông tin'));
    } else {
      emit(LoginLoading());
      try {
        //lấy token (lưu share_preference)
        String token =
            await APIRepository().login(event.account, event.password);
        final User userData = await APIRepository().current(token);
        if (await saveUser(userData)) {
          Logger().i(jsonEncode(userData));
          emit(LoginSuccess());
        }
      } catch (e) {
        if (e is Exception) {
          emit(LoginFailure(error: 'Tài khoản mật khẩu không hợp lệ'));
        } else {
          emit(LoginFailure(error: e.toString()));
        }
      }
    }
  }

  void _onTogglePasswordVisibility(
    TogglePasswordVisibility event,
    Emitter<LoginState> emit,
  ) async {
    _isPasswordVisible = !_isPasswordVisible;
    emit(LoginInitial(isVisible: _isPasswordVisible));
  }

  void _onAutoLogin(AppStarted event, Emitter<LoginState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      Logger().i(prefs.getString('user'));
      emit(LoginSuccess());
    } else {
      emit(LoginInitial());
    }
  }
}

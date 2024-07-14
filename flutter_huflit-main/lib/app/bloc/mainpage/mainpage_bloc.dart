import 'dart:convert';

import 'package:app_api/app/data/sqlite.dart';
import 'package:app_api/app/model/user.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'mainpage_event.dart';
part 'mainpage_state.dart';

class MainpageBloc extends Bloc<MainpageEvent, MainpageState> {
  MainpageBloc() : super(MainpageInitial()) {
    on<LoadUserEvent>(_getUser);
  }

  Future<void> _getUser(
      LoadUserEvent event, Emitter<MainpageState> emit) async {
    emit(MainpageLoading());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (pref.containsKey('user')) {
        String strUser = pref.getString('user')!;
        final User user = User.fromJson(jsonDecode(strUser));
        final itemCount = await DatabaseHelper().getQuantityCart();
        emit(MainpageSuccess(user: user, itemCountCart: itemCount));
      } else {
        emit(MainpageFailure('User not found'));
      }
    } catch (e) {
      emit(MainpageFailure(e.toString()));
    }
  }
}

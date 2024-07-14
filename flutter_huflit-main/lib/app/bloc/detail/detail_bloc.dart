import 'dart:convert';

import 'package:app_api/app/model/user.dart';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

part 'detail_event.dart';
part 'detail_state.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc() : super(DetailInitial()) {
    on<GetDetailEvent>(_getDetail);
  }

  void _getDetail(GetDetailEvent event, Emitter<DetailState> emit) async {
    emit(DetailLoading());
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      if (pref.containsKey('user')) {
        String strUser = pref.getString('user')!;
        final User userData = User.fromJson(jsonDecode(strUser));
        emit(DetailSuccess(user: userData));
      } else {
        emit(DetailFailure(message: 'User not found'));
      }
    } catch (e) {
      emit(DetailFailure(message: e.toString()));
    }
  }
}

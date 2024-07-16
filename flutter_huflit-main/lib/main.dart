import 'package:app_api/app/bloc/login/login_bloc.dart';
import 'package:app_api/app/config/const.dart';
import 'package:app_api/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:app_api/app/page/auth/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    return MaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: myTheme,
      home: BlocProvider(
        create: (context) => LoginBloc()..add(AppStarted()),
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            if (state is LoginSuccess) {
              return const Mainpage(index: 0);
            } else if (state is LoginLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
      // initialRoute: "/",
      // onGenerateRoute: AppRoute.onGenerateRoute,  -> su dung auto route (pushName)
    );
  }
}

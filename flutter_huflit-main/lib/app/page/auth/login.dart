import 'dart:ui';

import 'package:app_api/app/bloc/login/login_bloc.dart';
import 'package:app_api/app/components/field_login_register.dart';
import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'register.dart';
import 'package:app_api/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../data/sharepre.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(),
            child: BlocListener<LoginBloc, LoginState>(
              listener: (context, state) {
                if (state is LoginSuccess) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Mainpage(
                                index: 0,
                              )));
                } else if (state is LoginFailure) {
                  Fluttertoast.showToast(
                      msg: state.error,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
              },
              child: BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  bool isVisible =
                      state is LoginInitial ? state.isVisible : false;
                  return Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(15),
                                      border: const Border(
                                          bottom: BorderSide(
                                              color: Colors.white,
                                              width: 1.0))),
                                  child: Image.asset(
                                    urlLogo,
                                    fit: BoxFit.cover,
                                    height: 90,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          spaceHeight(x: 2),
                          fieldLoginRegister(
                              textEditingController: accountController,
                              labelText: 'Account',
                              iconData: Icons.account_circle),
                          fieldLoginRegister(
                              textEditingController: passwordController,
                              labelText: 'Password',
                              iconData: Icons.password,
                              isPassword: !isVisible,
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    context
                                        .read<LoginBloc>()
                                        .add(TogglePasswordVisibility());
                                  },
                                  icon: Icon(isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off))),
                          spaceHeight(x: 2),
                          Row(
                            children: [
                              spaceWidth(),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    context.read<LoginBloc>().add(
                                          LoginSubmitted(
                                            accountController.text.trim(),
                                            passwordController.text,
                                          ),
                                        );
                                  },
                                  child: const Text("Login"),
                                ),
                              ),
                              spaceWidth(),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Register()));
                                  },
                                  child: const Text("Register"),
                                ),
                              ),
                              spaceWidth(),
                            ],
                          ),
                        ],
                      ),
                      if (state is LoginLoading)
                        const CircularProgressIndicator(),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

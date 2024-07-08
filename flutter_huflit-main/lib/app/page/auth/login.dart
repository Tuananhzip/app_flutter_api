import 'dart:ui';

import 'package:app_api/app/bloc/login_bloc.dart';
import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import '../register.dart';
import 'package:app_api/mainpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../data/sharepre.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                          builder: (context) => const Mainpage()));
                } else if (state is LoginFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.error),
                    duration: const Duration(seconds: 2),
                  ));
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
                          Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: const Border(
                                    bottom: BorderSide(color: Colors.white))),
                            child: TextFormField(
                              controller: accountController,
                              decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.account_circle),
                                  filled: true,
                                  border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  labelText: 'Account name',
                                  labelStyle: TextStyle(
                                      color: Color.fromARGB(255, 12, 12, 12)),
                                  hintStyle: TextStyle(
                                      color: Color.fromARGB(255, 12, 12, 12))),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: const Border(
                                    bottom: BorderSide(color: Colors.white))),
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: !isVisible,
                              decoration: InputDecoration(
                                  filled: true,
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.password),
                                  suffixIcon: IconButton(
                                    icon: isVisible
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                    onPressed: () {
                                      context
                                          .read<LoginBloc>()
                                          .add(TogglePasswordVisibility());
                                    },
                                  ),
                                  border: const UnderlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  labelStyle: const TextStyle(
                                      color: Color.fromARGB(255, 12, 12, 12)),
                                  hintStyle: const TextStyle(
                                      color: Color.fromARGB(255, 12, 12, 12))),
                            ),
                          ),
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
                        const Center(child: CircularProgressIndicator())
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

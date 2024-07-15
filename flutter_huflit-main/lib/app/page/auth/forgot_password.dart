import 'package:app_api/app/components/field_login_register.dart';
import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _accountIdController = TextEditingController();
  final TextEditingController _numberIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _forgotPassword() async {
    if (_accountIdController.text.isEmpty ||
        _numberIdController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please fill all fields",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    ApiResponse result = await APIRepository().forgotPassword(
      _accountIdController.text,
      _numberIdController.text,
      _passwordController.text,
    );
    if (result.success) {
      Fluttertoast.showToast(
          msg: result.data,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      Fluttertoast.showToast(
          msg: result.error,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.topCenter,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(urlBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                spaceHeight(),
                Stack(
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      child: const Text(
                        'Forgot Password',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                forgotPasswordField(context),
                const Expanded(child: SizedBox.shrink()),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: () => _forgotPassword(),
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget forgotPasswordField(BuildContext context) {
    return Column(
      children: [
        fieldLoginRegister(
            textEditingController: _accountIdController,
            labelText: 'Account ID',
            keyboardType: TextInputType.multiline,
            iconData: Icons.account_circle_outlined),
        fieldLoginRegister(
            textEditingController: _numberIdController,
            labelText: 'Number ID',
            keyboardType: TextInputType.multiline,
            iconData: Icons.numbers_outlined),
        fieldLoginRegister(
          textEditingController: _passwordController,
          labelText: 'Password',
          keyboardType: TextInputType.multiline,
          iconData: Icons.password_outlined,
          isPassword: true,
        ),
        spaceHeight(x: 1),
      ],
    );
  }
}

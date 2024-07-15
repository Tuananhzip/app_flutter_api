import 'package:app_api/app/components/field_login_register.dart';
import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/api_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> _changePassword() async {
    if (_oldPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Password must be at least 6 characters',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      String token = prefs.getString('token')!;
      ApiResponse result = await APIRepository().changePassword(
          _oldPasswordController.text, _newPasswordController.text, token);
      Logger().d(result);
      if (result.success) {
        Fluttertoast.showToast(
          msg: result.data,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
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
          fontSize: 16.0,
        );
      }
    } else {
      Logger().e('Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: styleMedium(size: 20),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(urlBackgroundProfile),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            fieldLoginRegister(
              textEditingController: _oldPasswordController,
              labelText: 'Old password',
              keyboardType: TextInputType.multiline,
              iconData: Icons.password,
            ),
            fieldLoginRegister(
              textEditingController: _newPasswordController,
              labelText: 'New password',
              keyboardType: TextInputType.multiline,
              iconData: Icons.password,
            ),
            const Expanded(
              child: SizedBox.shrink(),
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: () => _changePassword(),
                child: const Text('Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

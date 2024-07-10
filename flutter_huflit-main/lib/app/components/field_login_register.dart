import 'package:flutter/material.dart';

Widget fieldLoginRegister(
    {required TextEditingController textEditingController,
    required String labelText,
    required IconData iconData,
    bool isPassword = false,
    Widget? suffixIcon,
    String? helperText,
    String? errorText,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function()? onTap}) {
  return Container(
    padding: const EdgeInsets.all(8),
    margin: const EdgeInsets.all(8),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: const Border(bottom: BorderSide(color: Colors.white))),
    child: TextFormField(
      controller: textEditingController,
      obscureText: isPassword,
      decoration: InputDecoration(
          prefixIcon: Icon(iconData),
          suffixIcon: suffixIcon,
          helperText: helperText,
          errorText: errorText,
          errorMaxLines: 2,
          filled: true,
          border: const UnderlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          labelText: labelText,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
          hintStyle: const TextStyle(color: Color.fromARGB(255, 12, 12, 12))),
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
    ),
  );
}

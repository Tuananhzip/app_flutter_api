import 'dart:convert';

import 'package:app_api/app/config/const.dart';
import 'package:flutter/material.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  // khi dùng tham số truyền vào phải khai báo biến trùng tên require
  User user = User.userEmpty();
  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    // create style
    TextStyle mystyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.amber,
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  image: DecorationImage(
                    image: AssetImage(urlBackgroundProfile),
                    fit: BoxFit.cover,
                    opacity: 0.9,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(42),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                        user.imageURL != null && user.imageURL!.isNotEmpty
                            ? user.imageURL!
                            : urlUserDefault,
                      ),
                    ),
                  ),
                ),
              ),
              Text("NumberID: ${user.idNumber}", style: mystyle),
              Text("Fullname: ${user.fullName}", style: mystyle),
              Text("Phone Number: ${user.phoneNumber}", style: mystyle),
              Text("Gender: ${user.gender}", style: mystyle),
              Text("birthDay: ${user.birthDay}", style: mystyle),
              Text("schoolYear: ${user.schoolYear}", style: mystyle),
              Text("schoolKey: ${user.schoolKey}", style: mystyle),
              Text("dateCreated: ${user.dateCreated}", style: mystyle),
            ],
          ),
        ),
      ),
    );
  }
}

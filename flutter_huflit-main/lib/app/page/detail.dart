import 'dart:convert';

import 'package:app_api/app/bloc/detail/detail_bloc.dart';
import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/page/auth/change_password.dart';
import 'package:app_api/app/page/auth/edit_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: BlocProvider(
            create: (context) => DetailBloc()..add(GetDetailEvent()),
            child: BlocBuilder<DetailBloc, DetailState>(
              builder: (context, state) {
                if (state is DetailLoading) {
                  return const CircularProgressIndicator();
                } else if (state is DetailSuccess) {
                  final User user = state.user;
                  return Column(
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
                            image: NetworkImage(urlBackgroundProfile),
                            fit: BoxFit.cover,
                            opacity: 0.9,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 45,
                                backgroundImage: NetworkImage(
                                  user.imageURL != null &&
                                          user.imageURL!.isNotEmpty
                                      ? user.imageURL!
                                      : urlUserDefault,
                                ),
                              ),
                            ),
                            Text(
                              '${user.fullName}',
                              style: styleMedium(color: Colors.white),
                            ),
                            Text(
                              'Number Id: ${user.idNumber}',
                              style: styleSmall(color: Colors.white),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'School Key: ${user.schoolKey}',
                                  style: styleVerySmall(color: Colors.white),
                                ),
                                Text(
                                  'School Year: ${user.schoolYear}',
                                  style: styleVerySmall(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      spaceHeight(),
                      ListTile(
                        leading: const Icon(Icons.phone_android),
                        title: Text("Phone number", style: styleVerySmall()),
                        subtitle:
                            Text("${user.phoneNumber}", style: styleSmall()),
                        onTap: () {
                          Logger().i('Phone number: ${user.phoneNumber}');
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(),
                      ),
                      spaceHeight(),
                      ListTile(
                        leading: const Stack(
                          children: [
                            Icon(
                              Icons.male,
                              size: 24,
                            ),
                            Positioned(
                              top: 3.8,
                              right: 2,
                              child: Icon(Icons.female),
                            )
                          ],
                        ),
                        title: Text("Gender", style: styleVerySmall()),
                        subtitle: Text("${user.gender}", style: styleSmall()),
                        onTap: () {
                          Logger().i('Gender: ${user.gender}');
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(),
                      ),
                      spaceHeight(),
                      ListTile(
                        leading: const Icon(Icons.cake_outlined),
                        title: Text("Birthday", style: styleVerySmall()),
                        subtitle: Text("${user.birthDay}", style: styleSmall()),
                        onTap: () {
                          Logger().i('Birthday: ${user.birthDay}');
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Divider(),
                      ),
                      spaceHeight(),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ChangePassword(),
                                  ),
                                ),
                                child: const Text('Change password'),
                              ),
                            ),
                            spaceWidth(),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfile(user: user),
                                  ),
                                ),
                                child: const Text('Edit Profile'),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                } else if (state is DetailFailure) {
                  Logger().e(state.message);
                  return Text(state.message);
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

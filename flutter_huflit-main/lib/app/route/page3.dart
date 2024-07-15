import 'dart:convert';

import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/api_response.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  Future<dynamic> _futureData = Future.value();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureData = _fetchData();
  }

  Future<dynamic> _fetchData() async {
    final dynamic result = await APIRepository().getListUser();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List User"),
      ),
      body: FutureBuilder<dynamic>(
        future: _futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else if (snapshot.hasData) {
            Logger().d(snapshot.data['data'].length);
            var listUser = snapshot.data['data'];
            // listUser.sort((a, b) => b['dateCreated']
            //     .toString()
            //     .compareTo(a['dateCreated'.toString()]));

            return ListView.builder(
              itemCount: listUser.length,
              itemBuilder: (context, index) {
                final user = listUser[index];
                return ListTile(
                  title: Text(user['fullName']),
                  subtitle: Text(user['accountID']),
                  trailing: Text('${index + 1}'),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      user['imageUrl'] ?? urlUserDefault,
                    ),
                    onBackgroundImageError: (exception, stackTrace) {
                      user['imageUrl'] = urlUserDefault;
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("No Data"),
            );
          }
        },
      ),
    );
  }
}

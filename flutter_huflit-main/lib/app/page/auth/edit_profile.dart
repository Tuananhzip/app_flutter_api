import 'package:app_api/app/bloc/mainpage/mainpage_bloc.dart';
import 'package:app_api/app/components/field_login_register.dart';
import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/data/sharepre.dart';
import 'package:app_api/app/model/api_response.dart';
import 'package:app_api/app/model/user.dart';
import 'package:app_api/mainpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.user});
  final User user;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _numberIdController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  final List<String> _genderList = ["Female", "Male", "Other"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _numberIdController.text = widget.user.idNumber ?? '';
    _fullNameController.text = widget.user.fullName ?? '';
    _phoneNumberController.text = widget.user.phoneNumber ?? '';
    _genderController.text = widget.user.gender ?? '';
    _birthDayController.text = widget.user.birthDay ?? '';
    _schoolYearController.text = widget.user.schoolYear ?? '';
    _schoolKeyController.text = widget.user.schoolKey ?? '';
    _imageURLController.text = widget.user.imageURL ?? '';
  }

  Future<void> _updateProfile() async {
    final User user = User(
      idNumber: _numberIdController.text,
      accountId: null,
      fullName: _fullNameController.text,
      phoneNumber: _phoneNumberController.text,
      imageURL: _imageURLController.text,
      birthDay: _birthDayController.text,
      gender: _genderController.text,
      schoolYear: _schoolYearController.text,
      schoolKey: _schoolKeyController.text,
      dateCreated: null,
      status: null,
    );
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('token')) {
      String token = prefs.getString('token')!;
      ApiResponse result = await APIRepository().updateProfile(user, token);
      Logger().i(result);
      if (result.success) {
        final User userData = await APIRepository().current(token);
        if (prefs.containsKey('user')) {
          prefs.remove('user');
          await saveUser(userData);
        }
        Fluttertoast.showToast(
            msg: result.data,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        if (mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const Mainpage(index: 3)));
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
    } else {
      Logger().e('Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: styleMedium(size: 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(urlBackgroundProfile),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              fieldLoginRegister(
                textEditingController: _numberIdController,
                labelText: 'Number Id',
                keyboardType: TextInputType.multiline,
                iconData: Icons.numbers,
              ),
              fieldLoginRegister(
                textEditingController: _fullNameController,
                labelText: 'Full name',
                keyboardType: TextInputType.name,
                iconData: Icons.edit_outlined,
              ),
              fieldLoginRegister(
                textEditingController: _phoneNumberController,
                labelText: 'Phone number',
                keyboardType: TextInputType.phone,
                iconData: Icons.numbers,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border:
                        const Border(bottom: BorderSide(color: Colors.white))),
                child: DropdownButtonFormField<String>(
                  value: _genderController.text,
                  items: _genderList.map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem(value: e, child: Text(e));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _genderController.text = value!;
                    });
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.male),
                      filled: true,
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      label: Text('Gender'),
                      labelStyle:
                          TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 12, 12, 12))),
                ),
              ),
              fieldLoginRegister(
                textEditingController: _birthDayController,
                labelText: "Birth Day",
                keyboardType: TextInputType.datetime,
                iconData: Icons.date_range,
                onTap: () async {
                  DateTime? _selectedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (_selectedDate != null) {
                    String dateFormated =
                        DateFormat('dd/MM/yyyy').format(_selectedDate);
                    _birthDayController.text = dateFormated;
                  }
                },
              ),
              fieldLoginRegister(
                textEditingController: _schoolYearController,
                labelText: 'School year',
                iconData: Icons.school_outlined,
              ),
              fieldLoginRegister(
                textEditingController: _schoolKeyController,
                labelText: 'School key',
                iconData: Icons.school_outlined,
              ),
              fieldLoginRegister(
                textEditingController: _imageURLController,
                labelText: 'Image url',
                iconData: Icons.image_outlined,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                        onPressed: () => _updateProfile(),
                        child: const Text('Edit Profile'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

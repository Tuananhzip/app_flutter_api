import 'package:app_api/app/bloc/register/register_bloc.dart';
import 'package:app_api/app/components/field_login_register.dart';
import 'package:app_api/app/config/const.dart';
import 'package:app_api/app/data/api.dart';
import 'package:app_api/app/model/register.dart';
import 'package:app_api/app/page/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:logger/logger.dart';
import 'package:intl/intl.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final RegisterBloc registerBloc = RegisterBloc();

  int _gender = 0;
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _numberIDController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _schoolKeyController = TextEditingController();
  final TextEditingController _schoolYearController = TextEditingController();
  final TextEditingController _birthDayController = TextEditingController();
  final TextEditingController _imageURL = TextEditingController();
  final TextEditingController _genderName = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    registerBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(urlBackground),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Register Info',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  signUpWidget(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpWidget(BuildContext context) {
    return BlocProvider(
      create: (context) => registerBloc,
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            Fluttertoast.showToast(
                msg: "Register success",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.green,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          } else if (state is RegisterFailure) {
            Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            return Stack(
              children: [
                if (state is RegisterLoading) const CircularProgressIndicator(),
                Column(
                  children: [
                    fieldLoginRegister(
                        textEditingController: _accountController,
                        labelText: "Account",
                        helperText: "Example: 21DH112345",
                        iconData: Icons.account_circle,
                        errorText:
                            state is ValidateAccountId ? state.message : null,
                        onChanged: (_) {
                          registerBloc.add(AccountIdChanged(
                              accountID: _accountController.text));
                        }),
                    fieldLoginRegister(
                      textEditingController: _passwordController,
                      labelText: "Password",
                      helperText: "Example: Abcde@123",
                      errorText:
                          state is ValidatePassword ? state.message : null,
                      isPassword: true,
                      iconData: Icons.password,
                      onChanged: (_) {
                        registerBloc.add(PasswordChanged(
                            password: _passwordController.text));
                      },
                    ),
                    fieldLoginRegister(
                      textEditingController: _confirmPasswordController,
                      labelText: "Confirm password",
                      helperText: "Same as password",
                      errorText: state is ValidateConfirmPassword
                          ? state.message
                          : null,
                      isPassword: true,
                      iconData: Icons.password,
                      onChanged: (_) {
                        registerBloc.add(ConfirmPasswordChanged(
                            password: _passwordController.text,
                            confirmPassword: _confirmPasswordController.text));
                      },
                    ),
                    fieldLoginRegister(
                      textEditingController: _fullNameController,
                      labelText: "Full Name",
                      helperText: "Example: Nguyen Van A",
                      errorText:
                          state is ValidateFullName ? state.message : null,
                      iconData: Icons.short_text,
                      onChanged: (_) {
                        registerBloc.add(FullNameChanged(
                            fullName: _fullNameController.text));
                      },
                    ),
                    fieldLoginRegister(
                        textEditingController: _numberIDController,
                        labelText: "NumberID",
                        helperText: "Example: 20173245",
                        errorText:
                            state is ValidateNumberId ? state.message : null,
                        iconData: Icons.key,
                        onChanged: (_) {
                          registerBloc.add(NumberIdChanged(
                              numberId: _numberIDController.text));
                        }),
                    fieldLoginRegister(
                        textEditingController: _phoneNumberController,
                        labelText: "Phone Number",
                        errorText:
                            state is ValidatePhoneNumber ? state.message : null,
                        helperText: "Example: 0123456789",
                        iconData: Icons.phone,
                        onChanged: (_) {
                          registerBloc.add(PhoneNumberChanged(
                              phoneNumber: _phoneNumberController.text));
                        }),
                    fieldLoginRegister(
                        textEditingController: _birthDayController,
                        labelText: "Birth Day",
                        helperText: "Example: 01/01/2001",
                        errorText:
                            state is ValidateBirthDay ? state.message : null,
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
                            registerBloc.add((BirthDayChanged(
                                birthDay: _birthDayController.text)));
                          }
                        },
                        onChanged: (_) {
                          registerBloc.add(BirthDayChanged(
                              birthDay: _birthDayController.text));
                        }),
                    fieldLoginRegister(
                        textEditingController: _schoolYearController,
                        labelText: "School Year",
                        helperText: "Example: 2021-2025",
                        errorText:
                            state is ValidateSchoolYear ? state.message : null,
                        iconData: Icons.school,
                        onChanged: (_) {
                          registerBloc.add(SchoolYearChanged(
                              schoolYear: _schoolYearController.text));
                        }),
                    fieldLoginRegister(
                        textEditingController: _schoolKeyController,
                        labelText: "School Key",
                        helperText: "Example: K27",
                        errorText:
                            state is ValidateSchoolKey ? state.message : null,
                        iconData: Icons.vpn_key_outlined,
                        onChanged: (_) {
                          registerBloc.add(SchoolKeyChanged(
                              schoolKey: _schoolKeyController.text));
                        }),
                    const Text("What is your Gender?"),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: const Text("Male"),
                            leading: Transform.translate(
                                offset: const Offset(16, 0),
                                child: Radio(
                                  value: 1,
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value!;
                                    });
                                    _genderName.text = 'Male';
                                    registerBloc
                                        .add(GenderChanged(gender: 'Male'));
                                  },
                                )),
                          ),
                        ),
                        Expanded(
                          child: ListTile(
                              contentPadding: const EdgeInsets.all(0),
                              title: const Text("Female"),
                              leading: Transform.translate(
                                offset: const Offset(16, 0),
                                child: Radio(
                                  value: 2,
                                  groupValue: _gender,
                                  onChanged: (value) {
                                    setState(() {
                                      _gender = value!;
                                    });
                                    _genderName.text = 'Female';
                                    registerBloc
                                        .add(GenderChanged(gender: 'Female'));
                                  },
                                ),
                              )),
                        ),
                        Expanded(
                            child: ListTile(
                          contentPadding: const EdgeInsets.all(0),
                          title: const Text("Other"),
                          leading: Transform.translate(
                              offset: const Offset(16, 0),
                              child: Radio(
                                value: 3,
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value!;
                                  });
                                  _genderName.text = 'Other';
                                  registerBloc
                                      .add(GenderChanged(gender: 'Other'));
                                },
                              )),
                        )),
                      ],
                    ),
                    fieldLoginRegister(
                        textEditingController: _imageURL,
                        labelText: "Image URL (optional)",
                        iconData: Icons.image),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                              onPressed: () {
                                context.read<RegisterBloc>().add(
                                      RegisterSubmitted(
                                          accountID: _accountController.text,
                                          password: _passwordController.text,
                                          confirmPassword:
                                              _confirmPasswordController.text,
                                          fullName: _fullNameController.text,
                                          numberId: _numberIDController.text,
                                          phoneNumber:
                                              _phoneNumberController.text,
                                          gender: _genderName.text,
                                          birthDay: _birthDayController.text,
                                          schoolYear:
                                              _schoolYearController.text,
                                          schoolKey: _schoolKeyController.text),
                                    );
                              },
                              child: const Text('Register'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

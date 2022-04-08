import 'package:flutter/material.dart';
import 'package:skoomin/src/base/nav.dart';
import 'package:skoomin/src/data/student_model.dart';
import 'package:skoomin/src/services/connectivity_services.dart';
import 'package:skoomin/src/services/student_registration_services.dart';
import 'package:skoomin/src/ui/modals/dialog.dart' as prefix0;
import 'package:skoomin/src/ui/pages/otp_verification_page.dart';
import 'package:skoomin/src/ui/widgets/app_text_field.dart';
import 'package:skoomin/src/ui/widgets/auth_button.dart';
import 'package:skoomin/src/utils/const.dart';

class StudentRegistrationPage extends StatefulWidget {
  final String schoolId;

  const StudentRegistrationPage({
    Key? key,
    required this.schoolId,
  }) : super(key: key);

  @override
  createState() => _StudentRegistrationPageState();
}

class _StudentRegistrationPageState extends State<StudentRegistrationPage> {
  final _studentFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _usernameController = TextEditingController();
  final _rollController = TextEditingController();
  final _passwordController = TextEditingController();
  late bool obscurePassword;
  bool agreement = false;

  @override
  void initState() {
    obscurePassword = true;
    super.initState();
  }

  @override
  Widget build(context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Form(
          key: _studentFormKey,
          child: SafeArea(
            top: true,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 20.0,
                        bottom: 30.0,
                        left: 8,
                      ),
                      child: Text(
                        "Register Yourself",
                        style: TextStyle(fontSize: 27),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 60,
                          width: 50,
                          color: const Color(0xff77a200),
                          child: const Center(
                            child: Text(
                              '+1',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: AppIconTextField(
                            maxLength: 12,
                            textFieldController: _phoneController,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter phone number'
                                : value.startsWith('+')
                                    ? null
                                    : 'Please enter phone number in international format',
                            keyboardType: TextInputType.phone,
                            labelText: 'Phone Number (ex: +1905333555)',
                            isPhone: true,
                          ),
                        ),
                      ],
                    ),
                    AppIconTextField(
                      textFieldController: _usernameController,
                      labelText: 'Username',
                    ),
                    AppIconTextField(
                      textFieldController: _rollController,
                      labelText: 'Student ID',
                      isRollNo: true,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0, bottom: 10),
                      child: Text(
                        "If you don't have Student ID add 0000",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ),
                    AppIconTextField(
                      textFieldController: _passwordController,
                      labelText: 'Password',
                      isPassword: true,
                      validator: (value) => value!.isEmpty
                          ? 'Enter password'
                          : value.length < 6
                              ? 'Password must be 6 characters long'
                              : null,
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, right: 8.0),
                          child: Checkbox(
                            value: agreement,
                            activeColor: const Color(0xff77a200),
                            onChanged: (value) async {
                              setState(() {
                                agreement = value!;
                              });
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text("I accept "),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: GestureDetector(
                            onTap: () {
                              prefix0.getDialog(
                                context: context,
                                titleWidget: const Text(
                                  "Terms & Conditions",
                                  style: TextStyle(
                                    color: Color(0xff77a200),
                                  ),
                                ),
                                contentWidget: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          dummyFirstPage[0],
                                          textAlign: TextAlign.justify,
                                          softWrap: true,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButtonWidget(
                                    title: 'Ok',
                                    onPressed: () => AppNavigation.pop(context),
                                  ),
                                ],
                              );
                            },
                            child: const Text(
                              "Terms & Conditions",
                              style: TextStyle(
                                color: Color(0xff77a200),
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, left: 12.0),
                      child: AuthButton(
                        elevation: 0,
                        text: "Register",
                        onTap: agreement
                            ? () async {
                                if (!await ConnectivityServices()
                                    .getNetworkStatus()) {
                                  prefix0.showConnectionErrorDialog(context);
                                  return;
                                }
                                if (_studentFormKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  prefix0.getLoadingDialog(
                                    context: context,
                                    loadingMessage: 'Registering...',
                                  );
                                  _checkStudentInformation().then(
                                    (f) async {
                                      var check =
                                          await StudentRegistrationServices()
                                              .fetchSelected(
                                        _usernameController.text.trim(),
                                        'name',
                                      );
                                      if (check.isNotEmpty) {
                                        AppNavigation.pop(context);
                                        prefix0.getDialog(
                                          context: context,
                                          title: 'Error',
                                          contentWidget: Row(
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  "The Username you entered already exists!",
                                                  softWrap: true,
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButtonWidget(
                                              title: "Ok",
                                              onPressed: () =>
                                                  AppNavigation.pop(context),
                                            )
                                          ],
                                        );
                                      } else {
                                        AppNavigation.pop(context);
                                        final student = StudentModel(
                                          name: _usernameController.text.trim(),
                                          rollNo: _rollController.text,
                                          password: _passwordController.text,
                                          schoolId: widget.schoolId,
                                          isActive: true,
                                        );
                                        AppNavigation.pop(context);
                                        AppNavigation.to(
                                          context,
                                          OtpVerificationPage(
                                            phone: _phoneController.text,
                                            student: student,
                                            schoolId: widget.schoolId,
                                          ),
                                        );
                                      }
                                    },
                                  );
                                }
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _checkStudentInformation() async {
    return await Future.delayed(const Duration(seconds: 2), () => true);
  }
}
